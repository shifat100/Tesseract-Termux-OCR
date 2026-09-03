
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

