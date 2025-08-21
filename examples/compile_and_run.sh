#!/bin/bash

# SHARC ADSP Example Compilation and Simulation Script
# Demonstrates the complete workflow

echo "🎯 SHARC ADSP-21593 Example Workflow"
echo "===================================="

CCES_PATH="/opt/analog/cces/3.0.3"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Check if CCES is available
if [ ! -f "$CCES_PATH/cc21k" ]; then
    echo "❌ CCES not found at $CCES_PATH"
    echo "Run ../setup.sh first"
    exit 1
fi

echo ""
echo "📝 Example 1: Hello World"
cd "$SCRIPT_DIR/hello_world"
echo "Compiling hello_world.c..."
"$CCES_PATH/cc21k" -proc ADSP-21593 -O -o hello_world.dxe hello_world.c
echo "Running simulation..."
"$CCES_PATH/sharc_sim" ADSP-21593 hello_world.dxe

echo ""
echo "📝 Example 2: Audio Processing"
cd "$SCRIPT_DIR/audio_processing"
echo "Compiling audio_filter.c..."
"$CCES_PATH/cc21k" -proc ADSP-21593 -O -loop-simd -fp-associative -o audio_filter.dxe audio_filter.c
echo "Running simulation..."
"$CCES_PATH/sharc_sim" ADSP-21593 audio_filter.dxe

echo ""
echo "✅ All examples completed successfully!"
echo ""
echo "📚 To create your own project:"
echo "1. Write your C code"
echo "2. Compile: $CCES_PATH/cc21k -proc ADSP-21593 -O -o program.dxe source.c"
echo "3. Simulate: $CCES_PATH/sharc_sim ADSP-21593 program.dxe"