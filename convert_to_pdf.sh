#!/bin/bash

# Flutter E-Commerce eBook PDF Converter
# This script converts the markdown eBook to PDF format

echo "Flutter E-Commerce eBook PDF Converter"
echo "======================================="
echo ""

# Check if markdown file exists
if [ ! -f "Flutter_ECommerce_Development_Guide.md" ]; then
    echo "Error: Flutter_ECommerce_Development_Guide.md not found!"
    exit 1
fi

echo "Found markdown file: Flutter_ECommerce_Development_Guide.md"
echo ""

# Method 1: Using pandoc (recommended)
if command -v pandoc &> /dev/null; then
    echo "Converting using pandoc..."
    pandoc Flutter_ECommerce_Development_Guide.md \
        -o Flutter_ECommerce_Development_Guide.pdf \
        --pdf-engine=xelatex \
        -V geometry:margin=1in \
        -V fontsize=11pt \
        --toc \
        --toc-depth=2
    
    if [ $? -eq 0 ]; then
        echo "✅ PDF created successfully using pandoc!"
        ls -lh Flutter_ECommerce_Development_Guide.pdf
        exit 0
    fi
fi

# Method 2: Using wkhtmltopdf
if command -v wkhtmltopdf &> /dev/null; then
    echo "Converting using wkhtmltopdf..."
    
    # First convert markdown to HTML
    if command -v markdown &> /dev/null; then
        markdown Flutter_ECommerce_Development_Guide.md > temp.html
    else
        # Create simple HTML wrapper
        echo '<!DOCTYPE html><html><head><meta charset="UTF-8"><style>
        body { font-family: Arial, sans-serif; line-height: 1.6; max-width: 900px; margin: 0 auto; padding: 20px; }
        h1 { color: #2c3e50; border-bottom: 3px solid #3498db; }
        h2 { color: #34495e; border-bottom: 2px solid #ecf0f1; margin-top: 30px; }
        code { background-color: #f4f4f4; padding: 2px 6px; border-radius: 3px; }
        pre { background-color: #f4f4f4; padding: 15px; border-radius: 5px; overflow-x: auto; }
        table { border-collapse: collapse; width: 100%; margin: 20px 0; }
        th, td { border: 1px solid #ddd; padding: 12px; text-align: left; }
        th { background-color: #3498db; color: white; }
        </style></head><body><pre>' > temp.html
        cat Flutter_ECommerce_Development_Guide.md >> temp.html
        echo '</pre></body></html>' >> temp.html
    fi
    
    wkhtmltopdf temp.html Flutter_ECommerce_Development_Guide.pdf
    rm -f temp.html
    
    if [ $? -eq 0 ]; then
        echo "✅ PDF created successfully using wkhtmltopdf!"
        ls -lh Flutter_ECommerce_Development_Guide.pdf
        exit 0
    fi
fi

# Method 3: Installation instructions
echo ""
echo "⚠️  No PDF conversion tool found!"
echo ""
echo "Please install one of the following tools:"
echo ""
echo "Option 1 - Pandoc (Recommended):"
echo "  sudo apt-get install pandoc texlive-xelatex"
echo "  or visit: https://pandoc.org/installing.html"
echo ""
echo "Option 2 - wkhtmltopdf:"
echo "  sudo apt-get install wkhtmltopdf"
echo ""
echo "Option 3 - Online Conversion:"
echo "  1. Visit: https://www.markdowntopdf.com/"
echo "  2. Upload: Flutter_ECommerce_Development_Guide.md"
echo "  3. Download the generated PDF"
echo ""
echo "Option 4 - VS Code Extension:"
echo "  1. Install 'Markdown PDF' extension in VS Code"
echo "  2. Open Flutter_ECommerce_Development_Guide.md"
echo "  3. Right-click and select 'Markdown PDF: Export (pdf)'"
echo ""
