#!/bin/bash

# MarkSnip Chrome Extension Build Script
# Creates a distributable ZIP file for Chrome Web Store upload

set -e

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SRC_DIR="$PROJECT_ROOT/src"
DIST_DIR="$PROJECT_ROOT/dist"
ZIP_FILE="$DIST_DIR/marksnip-extension.zip"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}🔨 Building MarkSnip Chrome Extension...${NC}"

# Check if src directory exists
if [ ! -d "$SRC_DIR" ]; then
    echo -e "${RED}❌ Error: src directory not found at $SRC_DIR${NC}"
    exit 1
fi

# Check if manifest.json exists
if [ ! -f "$SRC_DIR/manifest.json" ]; then
    echo -e "${RED}❌ Error: manifest.json not found in src directory${NC}"
    exit 1
fi

# Create dist directory if it doesn't exist
if [ ! -d "$DIST_DIR" ]; then
    echo -e "${YELLOW}📁 Creating dist directory...${NC}"
    mkdir -p "$DIST_DIR"
fi

# Remove existing ZIP if it exists
if [ -f "$ZIP_FILE" ]; then
    echo -e "${YELLOW}🗑️  Removing old ZIP file...${NC}"
    rm "$ZIP_FILE"
fi

# Create the ZIP file
echo -e "${YELLOW}📦 Creating extension package...${NC}"
cd "$SRC_DIR"

# Create ZIP excluding unnecessary files and directories
zip -r "$ZIP_FILE" . \
    -x "node_modules/*" \
    ".git/*" \
    ".gitignore" \
    "*.test.js" \
    "*.spec.js" \
    "tests/*" \
    "tests/**/*" \
    ".DS_Store" \
    "*.log" \
    ".env" \
    ".env.local" \
    "package-lock.json" \
    "yarn.lock" \
    ".eslintrc*" \
    ".prettierrc*" \
    "jest.config.js" \
    "tsconfig.json" \
    "*.md" > /dev/null 2>&1

# Get file size
SIZE=$(du -h "$ZIP_FILE" | cut -f1)

echo -e "${GREEN}✅ Extension package created successfully!${NC}"
echo -e "${GREEN}📍 Location: $ZIP_FILE${NC}"
echo -e "${GREEN}📊 Size: $SIZE${NC}"
echo ""
echo -e "${YELLOW}📋 Next steps:${NC}"
echo "1. Visit: https://chrome.google.com/webstore/developer/dashboard"
echo "2. Click 'New Item' and upload: $ZIP_FILE"
echo "3. Fill in required metadata (description, screenshots, icons, etc.)"
echo "4. Submit for review"
echo ""
echo -e "${YELLOW}🧪 To test locally:${NC}"
echo "1. Open: chrome://extensions/"
echo "2. Enable 'Developer Mode'"
echo "3. Click 'Load unpacked' and select the 'src' folder"