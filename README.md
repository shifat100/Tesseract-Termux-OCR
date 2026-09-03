# PDF OCR Text Extractor on Termux

This tutorial sets up Tesseract OCR on Android using Termux and extracts text from PDF files.

It supports multiple languages such as:

- English
- Bengali
- Arabic
- Hindi
- Urdu
- French
- German
- Spanish
- And many other Tesseract-supported languages

---

## 1. Update Termux

```bash
pkg update -y
pkg upgrade -y
```

## 2. Install Required Packages
Install Python, Tesseract OCR, Poppler, and curl:

```bash
pkg install python tesseract poppler curl -y
```

## 3. Give Termux Storage Permission
Run:
```
termux-setup-storage
```
When Android asks for permission, press Allow.

## 4. Check Tesseract
Run:
```
tesseract --version
```
You should see something similar to:
`tesseract 5.5.2`

## 5. Check Installed OCR Languages

Run:
```
tesseract --list-langs
```
For example:

`
List of available languages in "/data/data/com.termux/files/usr/share/tessdata/" :
eng
osd
`
If your language is missing, install the language data manually.

## 6. Create the Tesseract tessdata Folder
Run:
```
mkdir -p $PREFIX/share/tessdata
```
## 7. Install English OCR Data

```
curl -L https://github.com/tesseract-ocr/tessdata_fast/raw/main/eng.traineddata \
-o $PREFIX/share/tessdata/eng.traineddata
```
## 8. Install Bengali OCR Data
```
curl -L https://github.com/tesseract-ocr/tessdata_fast/raw/main/ben.traineddata \
-o $PREFIX/share/tessdata/ben.traineddata
```
## 9. Install Arabic OCR Data
```
curl -L https://github.com/tesseract-ocr/tessdata_fast/raw/main/ara.traineddata \
-o $PREFIX/share/tessdata/ara.traineddata
```
## 10. Install Hindi OCR Data
```
curl -L https://github.com/tesseract-ocr/tessdata_fast/raw/main/hin.traineddata \
-o $PREFIX/share/tessdata/hin.traineddata
```
## 11. Install Urdu OCR Data
```curl -L https://github.com/tesseract-ocr/tessdata_fast/raw/main/urd.traineddata \
-o $PREFIX/share/tessdata/urd.traineddata
```
## 12. Check Languages Again
Run:
```
tesseract --list-langs
```

You should now see something like:
`List of available languages in "/data/data/com.termux/files/usr/share/tessdata/" :
ara
ben
eng
hin
osd
urd`

## 13. Language Codes

Tesseract cannot recognize every language automatically unless the corresponding language data is installed.

* `afr` = Afrikaans
* `amh` = Amharic
* `ara` = Arabic
* `asm` = Assamese
* `aze` = Azerbaijani
* `aze_cyrl` = Azerbaijani - Cyrillic
* `bel` = Belarusian
* `ben` = Bengali
* `bod` = Tibetan
* `bos` = Bosnian
* `bre` = Breton
* `bul` = Bulgarian
* `cat` = Catalan / Valencian
* `ceb` = Cebuano
* `ces` = Czech
* `chi_sim` = Chinese - Simplified
* `chi_sim_vert` = Chinese - Simplified - Vertical
* `chi_tra` = Chinese - Traditional
* `chi_tra_vert` = Chinese - Traditional - Vertical
* `chr` = Cherokee
* `cos` = Corsican
* `cym` = Welsh
* `dan` = Danish
* `deu` = German
* `deu_latf` = German Fraktur
* `div` = Dhivehi
* `dzo` = Dzongkha
* `ell` = Greek (Modern)
* `eng` = English
* `enm` = English - Middle English
* `epo` = Esperanto
* `equ` = Math / Equation Detection
* `est` = Estonian
* `eus` = Basque
* `fao` = Faroese
* `fas` = Persian / Farsi
* `fil` = Filipino
* `fin` = Finnish
* `fra` = French
* `frk` = German Fraktur
* `frm` = French - Middle French
* `fry` = West Frisian
* `gla` = Scottish Gaelic
* `gle` = Irish
* `glg` = Galician
* `grc` = Ancient Greek
* `guj` = Gujarati
* `hat` = Haitian / Haitian Creole
* `heb` = Hebrew
* `hin` = Hindi
* `hrv` = Croatian
* `hun` = Hungarian
* `hye` = Armenian
* `iku` = Inuktitut
* `ind` = Indonesian
* `isl` = Icelandic
* `ita` = Italian
* `ita_old` = Italian - Old
* `jav` = Javanese
* `jpn` = Japanese
* `jpn_vert` = Japanese - Vertical
* `kan` = Kannada
* `kat` = Georgian
* `kat_old` = Georgian - Old
* `kaz` = Kazakh
* `khm` = Khmer / Central Khmer
* `kir` = Kyrgyz
* `kmr` = Kurdish - Kurmanji
* `kor` = Korean
* `kor_vert` = Korean - Vertical
* `lao` = Lao
* `lat` = Latin
* `lav` = Latvian
* `lit` = Lithuanian
* `ltz` = Luxembourgish
* `mal` = Malayalam
* `mar` = Marathi
* `mkd` = Macedonian
* `mlt` = Maltese
* `mon` = Mongolian
* `mri` = Maori
* `msa` = Malay
* `mya` = Burmese
* `nep` = Nepali
* `nld` = Dutch / Flemish
* `nor` = Norwegian
* `oci` = Occitan
* `ori` = Oriya / Odia
* `osd` = Orientation and Script Detection
* `pan` = Punjabi / Panjabi
* `pol` = Polish
* `por` = Portuguese
* `pus` = Pashto / Pushto
* `que` = Quechua
* `ron` = Romanian / Moldavian / Moldovan
* `rus` = Russian
* `san` = Sanskrit
* `sin` = Sinhala / Sinhalese
* `slk` = Slovak
* `slv` = Slovenian
* `snd` = Sindhi
* `spa` = Spanish / Castilian
* `spa_old` = Spanish - Old
* `sqi` = Albanian
* `srp` = Serbian
* `srp_latn` = Serbian - Latin
* `sun` = Sundanese
* `swa` = Swahili
* `swe` = Swedish
* `syr` = Syriac
* `tam` = Tamil
* `tat` = Tatar
* `tel` = Telugu
* `tgk` = Tajik
* `tgl` = Tagalog
* `tha` = Thai
* `tir` = Tigrinya
* `ton` = Tongan
* `tur` = Turkish
* `uig` = Uyghur / Uighur
* `ukr` = Ukrainian
* `urd` = Urdu
* `uzb` = Uzbek
* `uzb_cyrl` = Uzbek - Cyrillic
* `vie` = Vietnamese
* `yid` = Yiddish
* `yor` = Yoruba


## 14. Put Your PDF Files Inside the OCR Folder
Your folder should look like this:
```
.
├── internal/ocr/
│   ├── book.pdf
│   ├── document.pdf
│   └── bangla.pdf
```

You can change the path in `ocr.sh` script 
```
OCR_ROOT="YOUR_FOLDER_PATH"
```

## 15. Create the OCR Script
Run:
```bash
nano ocr.sh
```

Paste the following script:

```bash
#!/data/data/com.termux/files/usr/bin/bash

# ============================================================
# PDF OCR TOOL FOR TERMUX
#
# Storage Directory:
# /storage/emulated/0/ocr/
#
# Features:
# 1. Main navigation menu with Back and Exit options
# 2. Individual PDF OCR or Batch "Convert All" processing
# 3. All pages / Custom range selection (e.g. 1-5, 1,6,8, 1-5,8,12-15)
# 4. Multi-language OCR support (auto-detects installed models)
# 5. Live progress bar for both conversion and OCR stages
# 6. Automatic cleanup of temporary image files & graceful exit handling
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
    echo
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
# DETECT OCR LANGUAGES
# ============================================================
LANGS=$(tesseract --list-langs 2>/dev/null | grep -Ev "(List of available|^osd$|:)" | paste -sd+ -)

if [ -z "$LANGS" ]; then
    echo
    echo -e "${RED}[ERROR] No Tesseract language traineddata found.${NC}"
    echo "Install a language model (e.g., pkg install tesseract-lang-eng tesseract-lang-ben)"
    exit 1
fi

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

    # Strip all spaces
    INPUT=$(echo "$INPUT" | tr -d ' ')
    [ -z "$INPUT" ] && return 1

    local OLD_IFS="$IFS"
    IFS=','
    read -r -a PARTS <<< "$INPUT"
    IFS="$OLD_IFS"

    for PART in "${PARTS[@]}"; do
        # Page range format (e.g. 1-5)
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

        # Single page format (e.g. 8)
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

    # Remove duplicates and sort numerically
    if [ "${#SELECTED_PAGES[@]}" -gt 0 ]; then
        local OLD_IFS="$IFS"
        IFS=$'\n'
        SELECTED_PAGES=($(printf '%s\n' "${SELECTED_PAGES[@]}" | sort -n -u))
        IFS="$OLD_IFS"
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
                return 2  # Signal back to menu
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
    echo -e "Processing PDF: ${CYAN}$BASENAME${NC}"
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
    echo -e "${CYAN}[2/3] Extracting text via OCR...${NC}"
    : > "$MERGED"
    local OCR_DONE=0

    for PAGE in "${SELECTED_PAGES[@]}"; do
        OCR_DONE=$((OCR_DONE + 1))
        local IMAGE="$IMAGE_DIR/page-$PAGE.png"
        local PAGE_TXT="$TEXT_DIR/page-$PAGE.txt"

        if [ ! -f "$IMAGE" ]; then
            continue
        fi

        tesseract "$IMAGE" "${PAGE_TXT%.txt}" -l "$LANGS" --oem 1 --psm 3 >/dev/null 2>&1

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

    # Step 3: Cleanup temporary images
    echo -e "${CYAN}[3/3] Cleaning up temporary image files...${NC}"
    rm -rf "$IMAGE_DIR"
    CURRENT_TEMP_DIR=""
    echo -e "${GREEN}[✓] Temporary images removed.${NC}"

    # Summary
    echo
    echo "============================================================"
    echo -e "${GREEN}✓ PDF OCR COMPLETED SUCCESSFULLY${NC}"
    echo "============================================================"
    echo -e "Source File   : $BASENAME"
    echo -e "Pages Processed : $SELECTED_COUNT"
    echo -e "Merged Text   : ${BOLD}$MERGED${NC}"
    echo -e "Page Text Dir : ${BOLD}$TEXT_DIR/${NC}"
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
    echo -e "Directory : ${CYAN}$OCR_ROOT${NC}"
    echo -e "Languages : ${CYAN}$LANGS${NC}"
    echo "------------------------------------------------------------"

    TOTAL_FILES="${#PDF_LIST[@]}"

    if [ "$TOTAL_FILES" -eq 0 ]; then
        echo -e "${YELLOW}No PDF files found in the folder.${NC}"
        echo -e "Place your PDF files inside: ${BOLD}$OCR_ROOT${NC}"
        echo
        echo "R) Refresh File List"
        echo "0) Exit Tool"
        echo
        read -r -p "Option [R/0]: " EMPTY_CHOICE
        case "$EMPTY_CHOICE" in
            0|q|Q)
                echo -e "\n${GREEN}Goodbye!${NC}\n"
                exit 0
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
    echo "R) Refresh File List"
    echo "0) Exit"
    echo "------------------------------------------------------------"

    read -r -p "Select PDF [1-$TOTAL_FILES / A / 0]: " CHOICE

    case "$CHOICE" in
        0|q|Q)
            echo -e "\n${GREEN}Goodbye!${NC}\n"
            exit 0
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
```

## 16. Save the Script
In nano:
```bash
CTRL + X
Y
ENTER
```
## 17. Make the Script Executable
Run:
```bash
chmod +x ocr.sh
```
## 18. Run the OCR Script
Run:
```bash
./ocr.sh
```

[![Tesseract OCR](Screenshot%202026-09-03-07-27-15-328%20com.termux.jpg)](https://shifat100.xtgem.com)
