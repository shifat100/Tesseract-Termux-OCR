#!/data/data/com.termux/files/usr/bin/bash

# ============================================================
# PDF OCR TOOL FOR TERMUX (ADVANCED MULTI-LANGUAGE EDITION)
#
# Storage Directory:
# /storage/emulated/0/ocr/
#
# Features:
# 1. Interactive Language Selector (Single, Multiple Combo, or All)
# 2. Main navigation menu with Back & Exit options
# 3. Individual PDF OCR or Batch "Convert All" processing
# 4. All pages / Custom range selection (e.g. 1-5, 1,6,8, 1-5,8,12-15)
# 5. Live progress bar for Conversion and OCR stages
# 6. Temporary files auto-cleanup & interruption trap handling
# ============================================================

set -u

OCR_ROOT="/storage/emulated/0/ocr"
CURRENT_TEMP_DIR=""

# ============================================================
# ANSI COLORS
# ============================================================
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

# ============================================================
# CLEANUP HANDLER ON EXIT / INTERRUPT
# ============================================================
cleanup_on_exit() {
    if [ -n "${CURRENT_TEMP_DIR:-}" ] && [ -d "$CURRENT_TEMP_DIR" ]; then
        rm -rf "$CURRENT_TEMP_DIR"
    fi
}
trap cleanup_on_exit EXIT INT TERM

# ============================================================
# CHECK STORAGE ACCESS
# ============================================================
if [ ! -d "/storage/emulated/0" ]; then
    echo
    echo -e "${RED}[ERROR] Android storage permission not granted.${NC}"
    echo "Please grant permission by running:"
    echo "  termux-setup-storage"
    exit 1
fi

mkdir -p "$OCR_ROOT" 2>/dev/null
if [ ! -w "$OCR_ROOT" ]; then
    echo -e "${RED}[ERROR] Cannot write to directory: $OCR_ROOT${NC}"
    echo "Please check storage permissions."
    exit 1
fi

# ============================================================
# CHECK REQUIRED PACKAGES
# ============================================================
MISSING_TOOLS=()
for CMD in tesseract pdftoppm pdfinfo; do
    if ! command -v "$CMD" >/dev/null 2>&1; then
        MISSING_TOOLS+=("$CMD")
    fi
done

if [ "${#MISSING_TOOLS[@]}" -gt 0 ]; then
    echo
    echo -e "${RED}[ERROR] Missing dependencies: ${MISSING_TOOLS[*]}${NC}"
    echo
    echo "Install all required packages by running:"
    echo "  pkg update && pkg install tesseract poppler -y"
    exit 1
fi

# ============================================================
# DETECT & INITIALIZE OCR LANGUAGES
# ============================================================
INSTALLED_LANGS=()
while IFS= read -r line; do
    line=$(echo "$line" | tr -d ' \r\n')
    if [[ -n "$line" && ! "$line" =~ (List|osd|:) ]]; then
        INSTALLED_LANGS+=("$line")
    fi
done < <(tesseract --list-langs 2>/dev/null)

if [ "${#INSTALLED_LANGS[@]}" -eq 0 ]; then
    echo
    echo -e "${RED}[ERROR] No Tesseract language models found.${NC}"
    echo "Please install language data (e.g., pkg install tesseract-lang-eng tesseract-lang-ben)"
    exit 1
fi

# Set default active language
SELECTED_LANGS=$(printf "%s+" "${INSTALLED_LANGS[@]}")
SELECTED_LANGS="${SELECTED_LANGS%+}"

# ============================================================
# LANGUAGE SELECTION MENU
# ============================================================
select_languages_menu() {
    while true; do
        clear
        echo "============================================================"
        echo "                 LANGUAGE SELECTION MENU                    "
        echo "============================================================"
        echo -e "Currently Active Language(s): ${CYAN}${BOLD}${SELECTED_LANGS}${NC}"
        echo "------------------------------------------------------------"
        echo "Available Installed Languages:"
        echo
        local idx=1
        for lang in "${INSTALLED_LANGS[@]}"; do
            echo "  $idx) $lang"
            ((idx++))
        done
        echo
        echo "------------------------------------------------------------"
        echo "  A) Select ALL available languages"
        echo "  0) Back to Main Menu"
        echo "------------------------------------------------------------"
        echo "Selection Examples:"
        echo "  Single language    : 1"
        echo "  Multiple (combined): 1,2 or 1,3"
        echo
        read -r -p "Enter choice [e.g., 1 or 1,2 or A / 0]: " LANG_CHOICE

        case "$LANG_CHOICE" in
            0|b|B)
                return 0
                ;;
            a|A)
                SELECTED_LANGS=$(printf "%s+" "${INSTALLED_LANGS[@]}")
                SELECTED_LANGS="${SELECTED_LANGS%+}"
                echo -e "\n${GREEN}[✓] Selected all languages: $SELECTED_LANGS${NC}"
                sleep 1.2
                return 0
                ;;
            *)
                local VALID=true
                local TEMP_SELECTION=()

                local OLD_IFS="$IFS"
                IFS=','
                read -r -a CHOSEN_INDICES <<< "$LANG_CHOICE"
                IFS="$OLD_IFS"

                for c_idx in "${CHOSEN_INDICES[@]}"; do
                    c_idx=$(echo "$c_idx" | tr -d ' ')
                    if [[ "$c_idx" =~ ^[0-9]+$ ]] && [ "$c_idx" -ge 1 ] && [ "$c_idx" -le "${#INSTALLED_LANGS[@]}" ]; then
                        TEMP_SELECTION+=("${INSTALLED_LANGS[$((c_idx - 1))]}")
                    else
                        VALID=false
                        break
                    fi
                done

                if [ "$VALID" = true ] && [ "${#TEMP_SELECTION[@]}" -gt 0 ]; then
                    # Remove duplicates
                    local OLD_IFS2="$IFS"
                    IFS=$'\n'
                    local UNIQUE_SELECTION=($(printf '%s\n' "${TEMP_SELECTION[@]}" | sort -u))
                    IFS="$OLD_IFS2"

                    SELECTED_LANGS=$(printf "%s+" "${UNIQUE_SELECTION[@]}")
                    SELECTED_LANGS="${SELECTED_LANGS%+}"
                    echo -e "\n${GREEN}[✓] Active language(s) set to: $SELECTED_LANGS${NC}"
                    sleep 1.2
                    return 0
                else
                    echo -e "\n${RED}[ERROR] Invalid input. Please select valid numbers.${NC}"
                    sleep 1.2
                fi
                ;;
        esac
    done
}

# ============================================================
# PROGRESS BAR FUNCTION
# ============================================================
progress_bar() {
    local CURRENT=$1
    local TOTAL=$2
    local LABEL=$3

    [ "$TOTAL" -le 0 ] && TOTAL=1
    local PERCENT=$((CURRENT * 100 / TOTAL))
    local WIDTH=24
    local FILLED=$((PERCENT * WIDTH / 100))
    local EMPTY=$((WIDTH - FILLED))

    local BAR=""
    [ "$FILLED" -gt 0 ] && BAR=$(printf "%${FILLED}s" | tr ' ' '#')
    [ "$EMPTY" -gt 0 ] && BAR="${BAR}$(printf "%${EMPTY}s" | tr ' ' '-')"

    printf "\r%-11s [%s] %3d%% | %d/%d" "$LABEL" "$BAR" "$PERCENT" "$CURRENT" "$TOTAL"
}

# ============================================================
# GET AND SORT PDF LIST SAFELY
# ============================================================
get_pdfs() {
    PDF_LIST=()
    while IFS= read -r -d '' FILE; do
        PDF_LIST+=("$FILE")
    done < <(find "$OCR_ROOT" -maxdepth 1 -type f -iname "*.pdf" -print0 | sort -z)
}

# ============================================================
# PARSE CUSTOM PAGE INPUT
# ============================================================
parse_pages() {
    local INPUT="$1"
    local TOTAL="$2"
    SELECTED_PAGES=()

    INPUT=$(echo "$INPUT" | tr -d ' ')
    [ -z "$INPUT" ] && return 1

    local OLD_IFS="$IFS"
    IFS=','
    read -r -a PARTS <<< "$INPUT"
    IFS="$OLD_IFS"

    for PART in "${PARTS[@]}"; do
        # Range: 1-5
        if [[ "$PART" =~ ^([0-9]+)-([0-9]+)$ ]]; then
            local START="${BASH_REMATCH[1]}"
            local END="${BASH_REMATCH[2]}"

            if [ "$START" -gt "$END" ]; then
                local TEMP="$START"
                START="$END"
                END="$TEMP"
            fi

            if [ "$START" -lt 1 ] || [ "$END" -gt "$TOTAL" ]; then
                return 1
            fi

            for ((P=START; P<=END; P++)); do
                SELECTED_PAGES+=("$P")
            done

        # Single page: 8
        elif [[ "$PART" =~ ^[0-9]+$ ]]; then
            local P="$PART"
            if [ "$P" -lt 1 ] || [ "$P" -gt "$TOTAL" ]; then
                return 1
            fi
            SELECTED_PAGES+=("$P")
        else
            return 1
        fi
    done

    if [ "${#SELECTED_PAGES[@]}" -gt 0 ]; then
        local OLD_IFS2="$IFS"
        IFS=$'\n'
        SELECTED_PAGES=($(printf '%s\n' "${SELECTED_PAGES[@]}" | sort -n -u))
        IFS="$OLD_IFS2"
    fi

    return 0
}

# ============================================================
# PAGE SELECTION WITH BACK OPTION
# ============================================================
select_pages() {
    local PDF="$1"
    local TOTAL
    TOTAL=$(pdfinfo "$PDF" 2>/dev/null | awk '/^Pages:/ {print $2}')

    if [ -z "$TOTAL" ] || [ "$TOTAL" -le 0 ]; then
        echo -e "${RED}[ERROR] Could not detect page count for this PDF.${NC}"
        return 1
    fi

    while true; do
        echo
        echo "------------------------------------------------------------"
        echo -e "Total Pages Detected: ${BOLD}$TOTAL${NC}"
        echo "------------------------------------------------------------"
        echo "1) All Pages (1-$TOTAL)"
        echo "2) Custom Page Range (e.g., 1-5, 8, 12-15)"
        echo "0) Back to Main Menu"
        echo

        read -r -p "Select option [0-2]: " PAGE_OPTION

        case "$PAGE_OPTION" in
            1)
                SELECTED_PAGES=()
                for ((P=1; P<=TOTAL; P++)); do
                    SELECTED_PAGES+=("$P")
                done
                return 0
                ;;
            2)
                while true; do
                    echo
                    echo "Custom range examples:"
                    echo "  Single page : 3"
                    echo "  Range       : 1-5"
                    echo "  Multiple    : 1,3,7"
                    echo "  Mixed       : 1-5,8,12-15"
                    echo "  Type '0' or 'b' to go Back"
                    echo
                    read -r -p "Enter pages: " PAGE_INPUT

                    if [[ "$PAGE_INPUT" =~ ^[0bB]$ ]]; then
                        break
                    fi

                    if parse_pages "$PAGE_INPUT" "$TOTAL"; then
                        echo
                        echo -e "${GREEN}[✓] Selected pages:${NC} ${SELECTED_PAGES[*]}"
                        return 0
                    else
                        echo -e "${RED}[ERROR] Invalid page input. Valid range is 1 to $TOTAL.${NC}"
                    fi
                done
                ;;
            0|b|B)
                return 2
                ;;
            *)
                echo -e "${YELLOW}Please select 0, 1, or 2.${NC}"
                ;;
        esac
    done
}

# ============================================================
# PROCESS SINGLE PDF
# ============================================================
process_pdf() {
    local PDF="$1"
    local AUTO_ALL_PAGES="${2:-false}"

    local BASENAME
    BASENAME=$(basename "$PDF")
    local NAME="${BASENAME%.*}"

    local WORK_DIR="$OCR_ROOT/$NAME"
    local IMAGE_DIR="$WORK_DIR/images"
    local TEXT_DIR="$WORK_DIR/text"
    local MERGED="$WORK_DIR/$NAME.txt"

    CURRENT_TEMP_DIR="$IMAGE_DIR"

    echo
    echo "============================================================"
    echo -e "Processing PDF : ${CYAN}$BASENAME${NC}"
    echo -e "Active OCR Lang: ${YELLOW}$SELECTED_LANGS${NC}"
    echo "============================================================"

    if [ "$AUTO_ALL_PAGES" = true ]; then
        local TOTAL
        TOTAL=$(pdfinfo "$PDF" 2>/dev/null | awk '/^Pages:/ {print $2}')
        if [ -z "$TOTAL" ] || [ "$TOTAL" -le 0 ]; then
            echo -e "${RED}[ERROR] Could not read page count. Skipping...${NC}"
            return 1
        fi
        SELECTED_PAGES=()
        for ((P=1; P<=TOTAL; P++)); do
            SELECTED_PAGES+=("$P")
        done
    else
        select_pages "$PDF"
        local STATUS=$?

        if [ "$STATUS" -eq 2 ]; then
            echo -e "${YELLOW}Cancelled. Returning to main menu...${NC}"
            CURRENT_TEMP_DIR=""
            return 2
        elif [ "$STATUS" -ne 0 ]; then
            CURRENT_TEMP_DIR=""
            return 1
        fi
    fi

    local SELECTED_COUNT="${#SELECTED_PAGES[@]}"
    mkdir -p "$IMAGE_DIR" "$TEXT_DIR"

    # Step 1: PDF to Images
    echo
    echo -e "${CYAN}[1/3] Converting PDF pages to images...${NC}"
    rm -f "$IMAGE_DIR"/*.png 2>/dev/null

    local CONVERTED=0
    for PAGE in "${SELECTED_PAGES[@]}"; do
        CONVERTED=$((CONVERTED + 1))
        local OUTPUT_PREFIX="$IMAGE_DIR/page-$PAGE"

        pdftoppm -png -r 250 -f "$PAGE" -singlefile "$PDF" "$OUTPUT_PREFIX" >/dev/null 2>&1
        progress_bar "$CONVERTED" "$SELECTED_COUNT" "Rendering"
    done
    echo
    echo -e "${GREEN}[✓] Page image conversion complete.${NC}\n"

    # Step 2: OCR
    echo -e "${CYAN}[2/3] Extracting text with Tesseract ($SELECTED_LANGS)...${NC}"
    : > "$MERGED"
    local OCR_DONE=0

    for PAGE in "${SELECTED_PAGES[@]}"; do
        OCR_DONE=$((OCR_DONE + 1))
        local IMAGE="$IMAGE_DIR/page-$PAGE.png"
        local PAGE_TXT="$TEXT_DIR/page-$PAGE.txt"

        if [ ! -f "$IMAGE" ]; then
            continue
        fi

        tesseract "$IMAGE" "${PAGE_TXT%.txt}" -l "$SELECTED_LANGS" --oem 1 --psm 3 >/dev/null 2>&1

        {
            echo "================================================"
            echo "PAGE $PAGE"
            echo "================================================"
            [ -f "$PAGE_TXT" ] && cat "$PAGE_TXT"
            echo -e "\n"
        } >> "$MERGED"

        progress_bar "$OCR_DONE" "$SELECTED_COUNT" "OCR"
        printf " | page-%s" "$PAGE"
    done
    echo
    echo -e "${GREEN}[✓] Text recognition (OCR) complete.${NC}\n"

    # Step 3: Cleanup
    echo -e "${CYAN}[3/3] Cleaning up temporary image files...${NC}"
    rm -rf "$IMAGE_DIR"
    CURRENT_TEMP_DIR=""
    echo -e "${GREEN}[✓] Temporary images removed.${NC}"

    # Summary
    echo
    echo "============================================================"
    echo -e "${GREEN}✓ PDF OCR COMPLETED SUCCESSFULLY${NC}"
    echo "============================================================"
    echo -e "Source File     : $BASENAME"
    echo -e "Language Used   : $SELECTED_LANGS"
    echo -e "Pages Processed : $SELECTED_COUNT"
    echo -e "Merged Text File: ${BOLD}$MERGED${NC}"
    echo -e "Individual Files: ${BOLD}$TEXT_DIR/${NC}"
    echo "============================================================"
}

# ============================================================
# MAIN MENU LOOP
# ============================================================
while true; do
    get_pdfs
    clear

    echo "============================================================"
    echo "                   PDF OCR TOOL (TERMUX)                    "
    echo "============================================================"
    echo -e "Directory    : ${CYAN}$OCR_ROOT${NC}"
    echo -e "Active Lang  : ${GREEN}${BOLD}$SELECTED_LANGS${NC} (Press 'L' to select/change)"
    echo "------------------------------------------------------------"

    TOTAL_FILES="${#PDF_LIST[@]}"

    if [ "$TOTAL_FILES" -eq 0 ]; then
        echo -e "${YELLOW}No PDF files found in the folder.${NC}"
        echo -e "Place your PDF files inside: ${BOLD}$OCR_ROOT${NC}"
        echo
        echo "L) Change OCR Language(s)"
        echo "R) Refresh File List"
        echo "0) Exit Tool"
        echo
        read -r -p "Option [L/R/0]: " EMPTY_CHOICE
        case "$EMPTY_CHOICE" in
            0|q|Q)
                echo -e "\n${GREEN}Goodbye!${NC}\n"
                exit 0
                ;;
            l|L)
                select_languages_menu
                continue
                ;;
            *)
                continue
                ;;
        esac
    fi

    echo "Available PDF Files:"
    echo
    INDEX=1
    for PDF in "${PDF_LIST[@]}"; do
        echo "$INDEX) $(basename "$PDF")"
        INDEX=$((INDEX + 1))
    done

    echo "------------------------------------------------------------"
    echo "A) Convert All PDFs"
    echo "L) Select / Change OCR Language(s)"
    echo "R) Refresh File List"
    echo "0) Exit"
    echo "------------------------------------------------------------"

    read -r -p "Select option [1-$TOTAL_FILES / A / L / 0]: " CHOICE

    case "$CHOICE" in
        0|q|Q)
            echo -e "\n${GREEN}Goodbye!${NC}\n"
            exit 0
            ;;
        l|L)
            select_languages_menu
            ;;
        r|R)
            continue
            ;;
        a|A)
            echo
            echo "Batch Processing Options:"
            echo "1) Automatically convert ALL pages for all PDFs"
            echo "2) Prompt for page selection on each PDF"
            echo "0) Back to Menu"
            echo
            read -r -p "Choose option [0-2]: " BATCH_MODE

            case "$BATCH_MODE" in
                1)
                    for PDF in "${PDF_LIST[@]}"; do
                        process_pdf "$PDF" true
                    done
                    read -r -p "Batch conversion finished. Press [Enter] to return..."
                    ;;
                2)
                    for PDF in "${PDF_LIST[@]}"; do
                        process_pdf "$PDF" false
                        [ $? -eq 2 ] && break
                    done
                    read -r -p "Press [Enter] to return to menu..."
                    ;;
                *)
                    continue
                    ;;
            esac
            ;;
        *)
            if [[ "$CHOICE" =~ ^[0-9]+$ ]] && [ "$CHOICE" -ge 1 ] && [ "$CHOICE" -le "$TOTAL_FILES" ]; then
                SELECTED_PDF="${PDF_LIST[$((CHOICE - 1))]}"
                process_pdf "$SELECTED_PDF" false
                echo
                read -r -p "Press [Enter] to return to menu..."
            else
                echo -e "\n${RED}[ERROR] Invalid selection. Please try again.${NC}"
                sleep 1.2
            fi
            ;;
    esac
done
