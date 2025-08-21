# SHARC ADSP API Reference

## 🎯 **SHARC Development API Guide**

This reference covers essential APIs and programming patterns for SHARC ADSP processors.

---

## 📚 **Standard Headers**

### **Essential Includes**
```c
#include <stdio.h>      // Standard I/O
#include <math.h>       // Math functions
#include <string.h>     // String operations
#include <stdlib.h>     // Standard library
```

### **SHARC-Specific Headers**
```c
#include <processor_include.h>    // Processor-specific definitions
#include <interrupt.h>            // Interrupt handling
#include <cycle_count.h>          // Performance timing
```

---

## 🔢 **Data Types**

### **Standard Types**
```c
int                  // 32-bit signed integer
unsigned int         // 32-bit unsigned integer
float               // 32-bit floating point
double              // 64-bit floating point (limited support)
```

### **SHARC-Optimized Types**
```c
long long           // 64-bit integer
_Complex float      // Complex floating point
pm float           // Program memory float
dm float           // Data memory float
```

---

## 🧮 **Math Functions**

### **Basic Math**
```c
float sinf(float x);           // Sine
float cosf(float x);           // Cosine
float sqrtf(float x);          // Square root
float fabsf(float x);          // Absolute value
float powf(float x, float y);  // Power
float logf(float x);           // Natural logarithm
float expf(float x);           // Exponential
```

### **DSP-Optimized Functions**
```c
float fir_filter(float *coeffs, float *samples, int length);
float iir_filter(float input, float *coeffs, float *delay);
void fft_radix2(float *real, float *imag, int size);
```

---

## 🔄 **Memory Management**

### **Memory Allocation**
```c
#include <stdlib.h>

void* malloc(size_t size);     // Allocate memory
void free(void* ptr);          // Free memory
void* calloc(size_t n, size_t size);  // Allocate and clear
void* realloc(void* ptr, size_t size); // Reallocate
```

### **Memory Sections**
```c
// Place variables in specific memory sections
pm float pm_data[1024];        // Program memory
dm float dm_data[1024];        // Data memory
```

---

## ⚡ **SIMD Operations**

### **Vector Operations**
```c
// SHARC+ supports SIMD operations on vectors
typedef float vector4[4] __attribute__((aligned(16)));

vector4 a = {1.0f, 2.0f, 3.0f, 4.0f};
vector4 b = {5.0f, 6.0f, 7.0f, 8.0f};
vector4 result;

// Vector addition (compiler optimized)
for (int i = 0; i < 4; i++) {
    result[i] = a[i] + b[i];  // May be vectorized
}
```

### **Loop Optimization Hints**
```c
// Use pragma for loop optimization
#pragma loop_count(1024)
#pragma vector_for
for (int i = 0; i < 1024; i++) {
    output[i] = input[i] * gain;
}
```

---

## 🎵 **Audio Processing Patterns**

### **Sample Processing**
```c
void process_audio_sample(float input, float *output) {
    static float delay_line[MAX_DELAY];
    static int delay_index = 0;
    
    // Process sample
    *output = input * 0.8f + delay_line[delay_index] * 0.2f;
    
    // Update delay line
    delay_line[delay_index] = input;
    delay_index = (delay_index + 1) % MAX_DELAY;
}
```

### **Buffer Processing**
```c
void process_audio_buffer(float *input, float *output, int samples) {
    #pragma loop_count(min=64, max=1024)
    #pragma vector_for
    for (int i = 0; i < samples; i++) {
        output[i] = input[i] * gain_factor;
    }
}
```

---

## 🔧 **Performance Optimization**

### **Compiler Optimization Flags**
```bash
# Basic optimization
-O

# Loop SIMD optimization
-loop-simd

# Floating-point associative optimization
-fp-associative

# Combined (recommended)
-O -loop-simd -fp-associative
```

### **Code Optimization Tips**

#### **1. Use Efficient Data Types**
```c
// Preferred
float data[1024];           // 32-bit float
int counter;               // 32-bit int

// Avoid when possible
double precision_data[1024]; // 64-bit (slower)
short small_data[1024];     // 16-bit (may require conversion)
```

#### **2. Align Data for SIMD**
```c
// Align data for vector operations
float __attribute__((aligned(16))) vector_data[1024];
```

#### **3. Use Const for Read-Only Data**
```c
const float filter_coeffs[64] = { /* coefficients */ };
```

---

## 🎛️ **Interrupt Handling**

### **Basic Interrupt Setup**
```c
#include <interrupt.h>

void timer_interrupt_handler(int sig) {
    // Handle timer interrupt
    process_audio_sample();
}

int main() {
    // Register interrupt handler
    signal(SIG_TMR0, timer_interrupt_handler);
    
    // Enable interrupts
    interrupt(SIG_TMR0, timer_interrupt_handler);
    
    // Main processing loop
    while (1) {
        // Background processing
    }
}
```

---

## 📊 **Performance Monitoring**

### **Cycle Counting**
```c
#include <cycle_count.h>

int main() {
    cycle_t start, end;
    
    start = cycle_count();
    
    // Code to measure
    process_audio();
    
    end = cycle_count();
    
    printf("Processing took %lld cycles\n", end - start);
    return 0;
}
```

---

## 🔍 **Debugging**

### **Printf Debugging**
```c
#include <stdio.h>

// Basic debug output
printf("Debug: value = %f\n", value);

// Formatted output
printf("Sample[%d] = %.4f\n", index, sample_value);

// Hex output for bit analysis
printf("Bit pattern: 0x%08X\n", *(unsigned int*)&float_value);
```

### **Assert Macros**
```c
#include <assert.h>

void process_buffer(float *buffer, int size) {
    assert(buffer != NULL);      // Check valid pointer
    assert(size > 0);           // Check valid size
    assert(size <= MAX_SIZE);   // Check bounds
    
    // Process buffer...
}
```

---

## 🎯 **Common Patterns**

### **Filter Implementation**
```c
typedef struct {
    float *coeffs;
    float *delay_line;
    int length;
    int index;
} fir_filter_t;

float fir_process(fir_filter_t *filter, float input) {
    float output = 0.0f;
    
    // Store input in delay line
    filter->delay_line[filter->index] = input;
    
    // Compute FIR output
    #pragma loop_count(min=8, max=64)
    for (int i = 0; i < filter->length; i++) {
        int delay_idx = (filter->index + i) % filter->length;
        output += filter->coeffs[i] * filter->delay_line[delay_idx];
    }
    
    // Update index
    filter->index = (filter->index + 1) % filter->length;
    
    return output;
}
```

### **Circular Buffer**
```c
typedef struct {
    float *data;
    int size;
    int read_pos;
    int write_pos;
    int count;
} circular_buffer_t;

int buffer_write(circular_buffer_t *buf, float value) {
    if (buf->count >= buf->size) return -1; // Buffer full
    
    buf->data[buf->write_pos] = value;
    buf->write_pos = (buf->write_pos + 1) % buf->size;
    buf->count++;
    
    return 0;
}

float buffer_read(circular_buffer_t *buf) {
    if (buf->count <= 0) return 0.0f; // Buffer empty
    
    float value = buf->data[buf->read_pos];
    buf->read_pos = (buf->read_pos + 1) % buf->size;
    buf->count--;
    
    return value;
}
```

---

## 🚨 **Common Pitfalls**

### **1. Unaligned Memory Access**
```c
// Problem
float *ptr = (float*)(some_address + 1); // Unaligned

// Solution
float *ptr = (float*)((some_address + 3) & ~3); // Align to 4-byte boundary
```

### **2. Integer Overflow**
```c
// Problem
int large_calc = big_number1 * big_number2; // May overflow

// Solution
long long large_calc = (long long)big_number1 * big_number2;
```

### **3. Floating-Point Precision**
```c
// Problem
if (float_value == 0.1f) { /* may never be true */ }

// Solution
if (fabsf(float_value - 0.1f) < 1e-6f) { /* better comparison */ }
```

---

## 📚 **Additional Resources**

- **SHARC+ Programming Reference**: Processor-specific documentation
- **CCES User Guide**: Development environment reference
- **DSP Library Reference**: Optimized function library
- **Application Notes**: Specific implementation guides

---

**Note**: This API reference covers common patterns for ADSP-21593 development. Consult the official SHARC documentation for processor-specific details and advanced features.