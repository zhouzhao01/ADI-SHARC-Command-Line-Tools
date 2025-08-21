# SHARC ADSP-21593 Quick Reference

## 🚀 **Essential Commands**

### **Compile & Run**
```bash
# Compile
/opt/analog/cces/3.0.3/cc21k -proc ADSP-21593 -O -loop-simd -fp-associative -o program.dxe source.c

# Simulate
/opt/analog/cces/3.0.3/sharc_sim ADSP-21593 program.dxe
```

### **Check Toolkit**
```bash
ls /opt/analog/cces/3.0.3/cc21k
```

### **Help**
```bash
/opt/analog/cces/3.0.3/sharc_sim --help
/opt/analog/cces/3.0.3/chipfactory --help
```

## 🔧 **Troubleshooting**
- **Setup Location**: `/home/ubuntu/sharc_audio_test/`
- **Full Guide**: `SHARC_DEVELOPMENT_GUIDE.md`
- **Toolkit Path**: `/opt/analog/cces/3.0.3/`

## 💡 **One-liner Test**
```bash
echo -e '#include <stdio.h>\nint main(){printf("Hello ADSP-21593!\\n");return 0;}' > test.c && /opt/analog/cces/3.0.3/cc21k -proc ADSP-21593 -O -o test.dxe test.c && /opt/analog/cces/3.0.3/sharc_sim ADSP-21593 test.dxe
```