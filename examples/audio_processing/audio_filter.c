#include <stdio.h>
#include <math.h>

#define SAMPLES 1024
#define GAIN 0.75f
#define CUTOFF_FREQ 0.1f
#define PI 3.14159265359f

float input_buffer[SAMPLES];
float output_buffer[SAMPLES];

// Simple low-pass filter coefficient
float alpha = 0.1f;
float prev_output = 0.0f;

void generate_test_signal() {
    printf("Generating test audio signal...\n");
    for (int i = 0; i < SAMPLES; i++) {
        // Generate mixed frequency signal
        input_buffer[i] = sinf(2.0f * PI * i * 0.05f) +  // Low freq
                         0.5f * sinf(2.0f * PI * i * 0.3f); // High freq
    }
}

void apply_lowpass_filter() {
    printf("Applying low-pass filter...\n");
    for (int i = 0; i < SAMPLES; i++) {
        // Simple IIR low-pass filter
        output_buffer[i] = alpha * input_buffer[i] + (1.0f - alpha) * prev_output;
        prev_output = output_buffer[i];
        
        // Apply gain
        output_buffer[i] *= GAIN;
    }
}

void analyze_signal() {
    float input_rms = 0.0f;
    float output_rms = 0.0f;
    
    for (int i = 0; i < SAMPLES; i++) {
        input_rms += input_buffer[i] * input_buffer[i];
        output_rms += output_buffer[i] * output_buffer[i];
    }
    
    input_rms = sqrtf(input_rms / SAMPLES);
    output_rms = sqrtf(output_rms / SAMPLES);
    
    printf("Signal Analysis:\n");
    printf("  Input RMS:  %.4f\n", input_rms);
    printf("  Output RMS: %.4f\n", output_rms);
    printf("  Gain:       %.4f\n", output_rms / input_rms);
}

int main() {
    printf("ADSP-21593 Audio Processing Demo\n");
    printf("================================\n");
    
    generate_test_signal();
    apply_lowpass_filter();
    analyze_signal();
    
    printf("\nSample values:\n");
    printf("  Input[0]:   %.4f -> Output[0]:   %.4f\n", input_buffer[0], output_buffer[0]);
    printf("  Input[100]: %.4f -> Output[100]: %.4f\n", input_buffer[100], output_buffer[100]);
    printf("  Input[500]: %.4f -> Output[500]: %.4f\n", input_buffer[500], output_buffer[500]);
    
    printf("\nAudio processing completed successfully!\n");
    return 0;
}