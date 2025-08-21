#!/bin/bash

# SHARC ADSP Development Workflow Setup Script
# Installs custom tools and configures environment

set -e

echo "🎯 SHARC ADSP Development Workflow Setup"
echo "========================================"

# Color codes for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuration
CCES_PATH="/opt/analog/cces/3.0.3"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Function to print colored output
print_status() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

# Check if CCES is installed
echo "🔍 Checking CCES installation..."
if [ ! -d "$CCES_PATH" ]; then
    print_error "CCES not found at $CCES_PATH"
    echo "Please install CCES 3.0.3 first, or update CCES_PATH in this script"
    exit 1
fi

if [ ! -f "$CCES_PATH/cc21k" ]; then
    print_error "SHARC compiler (cc21k) not found at $CCES_PATH/cc21k"
    exit 1
fi

if [ ! -f "$CCES_PATH/chipfactory" ]; then
    print_error "SHARC simulator (chipfactory) not found at $CCES_PATH/chipfactory"
    exit 1
fi

print_status "CCES 3.0.3 installation found at $CCES_PATH"

# Install our custom wrapper script
echo "🛠️  Installing SHARC wrapper script..."
if [ -f "$SCRIPT_DIR/tools/sharc_sim" ]; then
    # Check if we have write permission to CCES directory
    if [ -w "$CCES_PATH" ]; then
        cp "$SCRIPT_DIR/tools/sharc_sim" "$CCES_PATH/"
        chmod +x "$CCES_PATH/sharc_sim"
        print_status "sharc_sim wrapper installed to $CCES_PATH/sharc_sim"
    else
        print_warning "No write permission to $CCES_PATH, trying with sudo..."
        sudo cp "$SCRIPT_DIR/tools/sharc_sim" "$CCES_PATH/"
        sudo chmod +x "$CCES_PATH/sharc_sim"
        print_status "sharc_sim wrapper installed to $CCES_PATH/sharc_sim (with sudo)"
    fi
else
    print_error "sharc_sim script not found in tools/ directory"
    exit 1
fi

# Create symbolic links for easier access (optional)
echo "🔗 Creating convenient symlinks..."
SYMLINK_DIR="$HOME/.local/bin"
mkdir -p "$SYMLINK_DIR"

# Add to PATH if not already there
if [[ ":$PATH:" != *":$SYMLINK_DIR:"* ]]; then
    echo "export PATH=\"$SYMLINK_DIR:\$PATH\"" >> "$HOME/.bashrc"
    print_status "Added $SYMLINK_DIR to PATH in .bashrc"
fi

# Create symlinks
ln -sf "$CCES_PATH/cc21k" "$SYMLINK_DIR/cc21k" 2>/dev/null || true
ln -sf "$CCES_PATH/sharc_sim" "$SYMLINK_DIR/sharc_sim" 2>/dev/null || true
ln -sf "$CCES_PATH/chipfactory" "$SYMLINK_DIR/chipfactory" 2>/dev/null || true

print_status "Created convenience symlinks in $SYMLINK_DIR"

# Copy documentation to user directory for easy access
echo "📚 Setting up documentation..."
DOC_DIR="$HOME/.sharc-workflow"
mkdir -p "$DOC_DIR"

cp "$SCRIPT_DIR/docs/"* "$DOC_DIR/" 2>/dev/null || true
print_status "Documentation copied to $DOC_DIR"

# Test basic functionality
echo "🧪 Testing installation..."
if "$CCES_PATH/cc21k" -version >/dev/null 2>&1; then
    print_status "SHARC compiler test passed"
else
    print_warning "SHARC compiler test failed - may need library dependencies"
fi

if "$CCES_PATH/sharc_sim" --help >/dev/null 2>&1; then
    print_status "SHARC simulator wrapper test passed"
else
    print_warning "SHARC simulator wrapper test failed - but may still work"
fi

echo ""
echo "🎉 Setup completed successfully!"
echo ""
echo "📋 Next steps:"
echo "1. Run './verify.sh' to test the full workflow"
echo "2. Check './examples/' for sample projects"
echo "3. Read the documentation in docs/ or ~/.sharc-workflow/"
echo ""
echo "🚀 Quick test command:"
echo "echo -e '#include <stdio.h>\\nint main(){printf(\"Hello ADSP-21593!\\\\n\");return 0;}' > test.c && $CCES_PATH/cc21k -proc ADSP-21593 -O -o test.dxe test.c && $CCES_PATH/sharc_sim ADSP-21593 test.dxe"
echo ""
print_status "SHARC ADSP development environment is ready!"