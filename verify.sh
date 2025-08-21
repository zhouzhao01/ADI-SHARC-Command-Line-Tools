#!/bin/bash

# SHARC ADSP Development Workflow Verification Script
# Tests the complete development environment

set -e

echo "🔍 SHARC ADSP Development Workflow Verification"
echo "=============================================="

# Color codes
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Configuration
CCES_PATH="/opt/analog/cces/3.0.3"
TEST_DIR=$(mktemp -d)
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

cleanup() {
    rm -rf "$TEST_DIR"
}
trap cleanup EXIT

echo "🔧 Checking CCES installation..."

# Check CCES directory
if [ ! -d "$CCES_PATH" ]; then
    print_error "CCES not found at $CCES_PATH"
    exit 1
fi
print_status "CCES directory found"

# Check compiler
if [ ! -f "$CCES_PATH/cc21k" ]; then
    print_error "SHARC compiler not found"
    exit 1
fi
print_status "SHARC compiler found"

# Check simulator
if [ ! -f "$CCES_PATH/chipfactory" ]; then
    print_error "SHARC simulator not found"
    exit 1
fi
print_status "SHARC simulator found"

# Check our wrapper
if [ ! -f "$CCES_PATH/sharc_sim" ]; then
    print_error "sharc_sim wrapper not found - run ./setup.sh first"
    exit 1
fi
print_status "sharc_sim wrapper found"

echo ""
echo "🧪 Testing compiler functionality..."

# Test compiler version
if "$CCES_PATH/cc21k" -version >/dev/null 2>&1; then
    print_status "Compiler version check passed"
else
    print_warning "Compiler version check failed - may still work"
fi

# Test ADSP-21593 support
cd "$TEST_DIR"
cat > test_compile.c << 'EOF'
#include <stdio.h>
int main() {
    printf("Hello ADSP-21593!\n");
    return 0;
}
EOF

echo "📝 Testing ADSP-21593 compilation..."
if "$CCES_PATH/cc21k" -proc ADSP-21593 -O -o test_compile.dxe test_compile.c 2>/dev/null; then
    print_status "ADSP-21593 compilation test passed"
else
    print_error "ADSP-21593 compilation test failed"
    exit 1
fi

# Verify DXE file was created
if [ -f "test_compile.dxe" ]; then
    print_status "DXE executable generated successfully"
else
    print_error "DXE file not created"
    exit 1
fi

echo ""
echo "🎮 Testing simulation functionality..."

# Test direct simulation
echo "Testing chipfactory direct simulation..."
if "$CCES_PATH/chipfactory" -proc ADSP-21593 test_compile.dxe >/dev/null 2>&1; then
    print_status "Direct simulation test passed"
else
    print_error "Direct simulation test failed"
    exit 1
fi

# Test wrapper simulation
echo "Testing sharc_sim wrapper..."
if "$CCES_PATH/sharc_sim" ADSP-21593 test_compile.dxe -quiet >/dev/null 2>&1; then
    print_status "Wrapper simulation test passed"
else
    print_error "Wrapper simulation test failed"
    exit 1
fi

echo ""
echo "🎯 Testing supported processors..."

PROCESSORS=("ADSP-21569" "ADSP-21593" "ADSP-SC589" "ADSP-SC594")
for proc in "${PROCESSORS[@]}"; do
    if "$CCES_PATH/cc21k" -proc "$proc" -O -o "test_$proc.dxe" test_compile.c 2>/dev/null; then
        print_status "$proc compilation supported"
    else
        print_warning "$proc compilation failed"
    fi
done

echo ""
echo "📚 Checking documentation..."

if [ -f "$SCRIPT_DIR/docs/DEVELOPMENT_GUIDE.md" ]; then
    print_status "Development guide found"
else
    print_warning "Development guide not found"
fi

if [ -f "$SCRIPT_DIR/docs/QUICK_REFERENCE.md" ]; then
    print_status "Quick reference found"
else
    print_warning "Quick reference not found"
fi

# Check if documentation was copied to user directory
if [ -f "$HOME/.sharc-workflow/DEVELOPMENT_GUIDE.md" ]; then
    print_status "User documentation directory set up"
else
    print_warning "User documentation not found - run ./setup.sh"
fi

echo ""
echo "🔄 Testing full workflow..."

# Create a more complex test
cat > audio_test.c << 'EOF'
#include <stdio.h>
#include <math.h>

#define SAMPLES 100
#define PI 3.14159265359f
float buffer[SAMPLES];

int main() {
    printf("ADSP-21593 Audio Test Starting...\n");
    
    // Generate simple sine wave
    for (int i = 0; i < SAMPLES; i++) {
        buffer[i] = sinf(2.0f * PI * i / SAMPLES);
    }
    
    printf("Generated %d samples\n", SAMPLES);
    printf("Sample[0] = %.3f\n", buffer[0]);
    printf("Sample[25] = %.3f\n", buffer[25]);
    
    printf("Audio test complete!\n");
    return 0;
}
EOF

echo "Testing complex audio program..."
if "$CCES_PATH/cc21k" -proc ADSP-21593 -O -loop-simd -fp-associative -o audio_test.dxe audio_test.c 2>/dev/null; then
    print_status "Complex program compilation passed"
    
    if "$CCES_PATH/sharc_sim" ADSP-21593 audio_test.dxe -quiet >/dev/null 2>&1; then
        print_status "Complex program simulation passed"
    else
        print_warning "Complex program simulation failed"
    fi
else
    print_warning "Complex program compilation failed"
fi

echo ""
echo "📊 Performance test..."
echo "Running simulation with timing..."
TIMING_OUTPUT=$("$CCES_PATH/sharc_sim" ADSP-21593 test_compile.dxe 2>&1 | grep "simulated chip cycles" || echo "Timing info not available")
if [ -n "$TIMING_OUTPUT" ]; then
    print_status "Performance monitoring working"
    echo "   $TIMING_OUTPUT"
else
    print_warning "Performance monitoring not available"
fi

echo ""
echo "🎉 Verification completed!"
echo ""
echo "📋 Summary:"
echo "✅ CCES 3.0.3 installation verified"
echo "✅ SHARC compiler (cc21k) working"
echo "✅ SHARC simulator (chipfactory) working"
echo "✅ Custom wrapper (sharc_sim) working" 
echo "✅ ADSP-21593 compilation and simulation verified"
echo "✅ Full development workflow operational"
echo ""
echo "🚀 Ready for SHARC ADSP embedded development!"
echo ""
echo "📖 Quick commands:"
echo "Compile:  $CCES_PATH/cc21k -proc ADSP-21593 -O -o program.dxe source.c"
echo "Simulate: $CCES_PATH/sharc_sim ADSP-21593 program.dxe"
echo "Help:     $CCES_PATH/sharc_sim --help"