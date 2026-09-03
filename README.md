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
If ben or ara is missing, install the language data manually.
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

## 13. Create the OCR Folder
Create a folder named ocr in your current Termux directory:
``
mkdir -p ./ocr
``
Check it:
`ls`
You should have:
ocr
## 14. Put Your PDF Files Inside the OCR Folder
Your folder should look like this:
```
.
├── ocr/
│   ├── book.pdf
│   ├── document.pdf
│   └── bangla.pdf
```
## 15. Create the OCR Script
Run:
```bash
nano ocr.sh
```
