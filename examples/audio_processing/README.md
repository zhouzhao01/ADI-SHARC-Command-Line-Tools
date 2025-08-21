# Audio Processing Example

Advanced ADSP-21593 audio processing demonstration with optimizations.

## Features
- Signal generation
- Low-pass filtering
- RMS analysis
- SIMD optimizations
- Floating-point associative operations

## Compilation
```bash
/opt/analog/cces/3.0.3/cc21k -proc ADSP-21593 -O -loop-simd -fp-associative -o audio_filter.dxe audio_filter.c
```

## Simulation
```bash
/opt/analog/cces/3.0.3/sharc_sim ADSP-21593 audio_filter.dxe
```

## Expected Output
```
ADSP-21593 Audio Processing Demo
================================
Generating test audio signal...
Applying low-pass filter...
Signal Analysis:
  Input RMS:  [value]
  Output RMS: [value]
  Gain:       [value]

Sample values:
  Input[0]:   [value] -> Output[0]:   [value]
  Input[100]: [value] -> Output[100]: [value]
  Input[500]: [value] -> Output[500]: [value]

Audio processing completed successfully!
```

## Optimization Notes
- Uses `-loop-simd` for SIMD loop optimization
- Uses `-fp-associative` for floating-point optimizations
- Demonstrates typical audio DSP operations