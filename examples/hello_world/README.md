# Hello World Example

Basic ADSP-21593 program demonstrating the development workflow.

## Compilation
```bash
/opt/analog/cces/3.0.3/cc21k -proc ADSP-21593 -O -o hello_world.dxe hello_world.c
```

## Simulation
```bash
/opt/analog/cces/3.0.3/sharc_sim ADSP-21593 hello_world.dxe
```

## Expected Output
```
Hello from ADSP-21593!
SHARC+ dual-core processor running
Command-line development workflow active
```