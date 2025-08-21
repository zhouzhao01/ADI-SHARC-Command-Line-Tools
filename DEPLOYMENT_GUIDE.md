# SHARC ADSP Workflow Deployment Guide

## 🚀 **Quick Deployment to New Machine**

### **Method 1: Git Repository (Recommended)**
```bash
# On source machine (create repository)
cd ~/sharc-adsp-workflow
git init
git add .
git commit -m "Initial SHARC ADSP workflow"
git remote add origin <your-github-repo-url>
git push -u origin main

# On target machine (deploy)
git clone <your-github-repo-url>
cd sharc-adsp-workflow
./setup.sh
./verify.sh
```

### **Method 2: Direct Transfer**
```bash
# Create portable package
cd ~
tar -czf sharc-adsp-workflow.tar.gz sharc-adsp-workflow/

# Transfer to new machine (via scp, rsync, etc.)
scp sharc-adsp-workflow.tar.gz user@target-machine:~

# On target machine
tar -xzf sharc-adsp-workflow.tar.gz
cd sharc-adsp-workflow
./setup.sh
./verify.sh
```

## 📋 **Prerequisites for Target Machine**

### **Required**
- Ubuntu Linux (18.04+ recommended)
- CCES 3.0.3 installed at `/opt/analog/cces/3.0.3/`
- Basic development tools (`build-essential`)

### **Optional but Recommended**
- Git (for repository method)
- Text editor (vim, nano, or IDE)

## 🔧 **Installation Process**

### **Step 1: Extract/Clone**
Get the workflow onto the target machine using one of the methods above.

### **Step 2: Run Setup**
```bash
cd sharc-adsp-workflow
./setup.sh
```

**What setup.sh does**:
- ✅ Detects CCES installation
- ✅ Installs sharc_sim wrapper to `/opt/analog/cces/3.0.3/`
- ✅ Creates convenience symlinks in `~/.local/bin`
- ✅ Copies documentation to `~/.sharc-workflow`
- ✅ Adds tools to PATH

### **Step 3: Verify Installation**
```bash
./verify.sh
```

**What verify.sh does**:
- ✅ Tests compiler functionality
- ✅ Tests simulation workflow
- ✅ Verifies all supported processors
- ✅ Runs performance benchmarks
- ✅ Tests complete development workflow

### **Step 4: Test Examples**
```bash
./examples/compile_and_run.sh
```

## 🎯 **What Gets Installed**

### **Tools Added**
- **`/opt/analog/cces/3.0.3/sharc_sim`** - Wrapper script for easy simulation
- **`~/.local/bin/cc21k`** - Symlink to compiler
- **`~/.local/bin/sharc_sim`** - Symlink to wrapper
- **`~/.local/bin/chipfactory`** - Symlink to simulator

### **Documentation Added**
- **`~/.sharc-workflow/DEVELOPMENT_GUIDE.md`** - Complete development guide
- **`~/.sharc-workflow/QUICK_REFERENCE.md`** - Command reference
- **`~/.sharc-workflow/API_REFERENCE.md`** - Programming API guide

### **Environment Changes**
- **`~/.bashrc`** - Adds `~/.local/bin` to PATH (if not already there)

## 🔍 **Troubleshooting Deployment**

### **CCES Not Found**
```bash
# Check if CCES is installed
ls /opt/analog/cces/3.0.3/cc21k

# If not found, install CCES first or update paths in scripts
```

### **Permission Issues**
```bash
# If setup.sh fails with permission errors
sudo ./setup.sh

# Or manually copy files
sudo cp tools/sharc_sim /opt/analog/cces/3.0.3/
sudo chmod +x /opt/analog/cces/3.0.3/sharc_sim
```

### **Path Issues**
```bash
# Manually add to PATH
echo 'export PATH="/opt/analog/cces/3.0.3:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

### **Verification Failures**
```bash
# Check individual components
/opt/analog/cces/3.0.3/cc21k --version
/opt/analog/cces/3.0.3/chipfactory --help
/opt/analog/cces/3.0.3/sharc_sim --help
```

## 📦 **Repository Structure**

```
sharc-adsp-workflow/
├── README.md                    # Main documentation
├── DEPLOYMENT_GUIDE.md          # This file
├── setup.sh                     # Installation script
├── verify.sh                    # Verification script
├── .gitignore                   # Git ignore patterns
├── tools/
│   └── sharc_sim               # Wrapper script
├── docs/
│   ├── DEVELOPMENT_GUIDE.md    # Complete development guide
│   ├── QUICK_REFERENCE.md      # Command cheat sheet
│   └── API_REFERENCE.md        # Programming reference
├── examples/
│   ├── compile_and_run.sh      # Example runner
│   ├── hello_world/
│   │   ├── hello_world.c
│   │   └── README.md
│   └── audio_processing/
│       ├── audio_filter.c
│       └── README.md
└── scripts/                     # Future utility scripts
```

## 🎯 **For Coding Agents**

After deployment, coding agents can:

1. **Check availability**: `./verify.sh`
2. **Access documentation**: `docs/` or `~/.sharc-workflow/`
3. **Use workflow**: See `docs/QUICK_REFERENCE.md`
4. **Run examples**: `./examples/compile_and_run.sh`

### **Essential Agent Commands**
```bash
# Check if workflow is available
test -f /opt/analog/cces/3.0.3/sharc_sim && echo "✅ Available" || echo "❌ Not available"

# Compile and simulate
/opt/analog/cces/3.0.3/cc21k -proc ADSP-21593 -O -o program.dxe source.c
/opt/analog/cces/3.0.3/sharc_sim ADSP-21593 program.dxe

# Quick test
echo -e '#include <stdio.h>\nint main(){printf("Hello!\\n");return 0;}' > test.c && /opt/analog/cces/3.0.3/cc21k -proc ADSP-21593 -O -o test.dxe test.c && /opt/analog/cces/3.0.3/sharc_sim ADSP-21593 test.dxe
```

## 🔄 **Updating the Workflow**

### **Adding New Features**
1. Modify files in the repository
2. Test with `./verify.sh`
3. Commit changes
4. Deploy to target machines

### **Version Management**
```bash
# Tag releases
git tag -a v1.1.0 -m "Added new processor support"
git push origin v1.1.0

# Deploy specific version
git clone -b v1.1.0 <repo-url>
```

## 📊 **Deployment Checklist**

### **Pre-Deployment**
- [ ] CCES 3.0.3 installed on target machine
- [ ] Target machine has Ubuntu Linux
- [ ] Network access for git clone (if using git method)

### **Post-Deployment**
- [ ] `./setup.sh` completed successfully
- [ ] `./verify.sh` passes all tests
- [ ] `./examples/compile_and_run.sh` works
- [ ] Coding agent can access documentation
- [ ] Development workflow operational

---

**Result**: Self-contained, portable SHARC ADSP development environment ready for any Ubuntu machine with CCES 3.0.3!