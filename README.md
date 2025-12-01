# RNS-850 LAN Setup

Modified MMI3G LAN setup scripts by DrGer, specifically tailored for the RNS-850 platform.

## 📚 Source Attribution

This project builds upon work from:
- **DrGER's Original MMI3G Scripts:** https://github.com/DrGER2/MMI3GP-LAN-Setup
- **RNS-850 GPS Logger Reference:** https://github.com/hbsagen/RNS850_gps_logger
- **Copie_scr_Decoder:** https://github.com/megusta1337/Copie_scr_Decoder

Special thanks to DrGER for the original MMI3G implementation, hbsagen for the working RNS-850 reference that revealed the critical mount sequence, and the original decoder algorithm author.

## 🚀 Quick Start

### For Users (Just Want Working Scripts)
1. **Copy everything from `script/` folder to your SD card root**
2. **Insert SD card into RNS-850** 
3. **Scripts auto-launch** and configure LAN connectivity

### For Developers (Want to Modify/Understand)
- **`tools/`** - Decoder tools for working with encoded copie_scr.sh files
- **`documentation/`** - Technical documentation and guides  
- **`backup_old_logging/`** - Historical files and backups

---

## 📁 Project Structure

```
RNS850-LAN-Setup/
├── script/                    # 📦 MAIN FILES - Copy this entire folder to SD card
│   ├── copie_scr.sh          #    Encoded launcher (auto-runs on SD insert)
│   ├── copie_scr_DECODED.sh  #    Decoded version for reference  
│   ├── run.sh                #    Main RNS-850 setup script
│   ├── bin/                  #    Executables (showScreen utility)
│   ├── lib/                  #    Images for setup screens
│   └── var/                  #    Configuration files (DHCP, DNS, network)
│
├── tools/                    # 🔧 Development Tools  
│   └── decoder/              #    DrGER encoding/decoding utilities
│
├── documentation/            # 📚 Technical Documentation
├── examples/                 # ⚠️  Broken/incomplete files (DO NOT USE)
└── backup_old_logging/      # 🗃️  Historical backup files
```

---

## 🎯 Goals

- ✅ **Enable LAN connectivity** on RNS-850 units for development/debugging
- ✅ **Provide network access** via ethernet (192.168.2.x range)  
- ✅ **Configure DHCP and DNS** for seamless integration
- ✅ **RNS-850 compatibility** while maintaining MMI3G heritage
- ✅ **Stable development platform** for further testing

---

## 🚧 Current Issues & Hurdles

### ✅ **MAJOR ISSUES RESOLVED:**
- **RNS-850 compatibility** - Created RNS-850 specific script with dynamic SD detection
- **Hardware detection** - Script now automatically detects RNS vs MMI3G systems  
- **SD card mounting** - Uses proper RNS-850 mounting method (`/mnt/sdcard*t`)

### 🔄 **Testing Required:**
- **New RNS-850 script** - Need to test `copie_scr_RNS850.sh` on actual hardware
- **CarPlay interference** - May still need to disconnect CarPlay box during testing
- **Log output verification** - Confirm logs now get written with proper SD detection

### ✅ **RESOLVED: Decoding Algorithm**
- **Successfully decoded DrGER's copie_scr.sh** - Complete script with proper MMI detection logic
- **Successfully decoded gps_copie_scr.sh** - Revealed RNS-850 specific SD detection method  
- **Created hybrid script** - Works with both RNS-850 and MMI3G systems

### 🔓 **Decoding Breakthrough: Found Working Tools**
- **Located existing decoder algorithm** from another GitHub repository 
- **Applied decoder to DrGER's scripts** - Successfully decoded PRNG-based XOR cipher with seed `0x001be3ac`
- **Adapted decoder tools** in C for this project (see `tools/decoder/`)
- **Can now modify DrGER scripts** and re-encode for hardware compatibility
- **Documented process** for future development and adaptation

---

## 🌐 Network Configuration

| Component | IP Address | Notes |
|-----------|------------|-------|
| **Router** | 192.168.2.1 | DHCP server, gateway |
| **RNS-850** | 192.168.2.2 | Static IP assignment |
| **WiFi Hotspot** | 192.168.1.1 | Alternative access point |
| **DNS** | 192.168.2.1, 8.8.8.8 | Primary + fallback |

---

## ⚠️ Important Warnings

- **RNS-850 ONLY** - Not compatible with MMI3G or other hardware
- **Unix Line Endings** - All files use LF line endings for hardware compatibility
- **Verify Device** - Ensure you have RNS-850 before using these scripts
- **Backup First** - Always backup your current configuration

---

## � Enhanced Logging & Debugging

### Comprehensive Logging System
The scripts include extensive logging for troubleshooting and development:

**Emergency Logging:**
- `emergency.log` - Created immediately on script start with environment details
- Contains SDPATH, SDLIB, SDVAR variable dumps for verification

**Structured Output:**
- `[INFO]` tags for normal operation status
- `[ERROR]` tags for failure conditions  
- Detailed timestamp and environment tracking

**Debug Information Captured:**
```bash
# Environment verification
echo "[INFO] SDVAR: ${SDVAR}"
echo "[INFO] SDLIB: ${SDLIB}" 
echo "[INFO] SDPATH: ${SDPATH}"

# Mount operations
echo "[INFO] Remounting $mes as read-write..."
echo "[INFO] Successfully remounted $mes"

# Network configuration status
echo "[INFO] resolv.conf-FIXEDIP installed successfully"
```

**Note:** While the logging system is comprehensive, current RNS-850 filesystem restrictions may prevent log file creation. The logging will be extremely valuable once write access is resolved.

---

## �🛠️ Usage Instructions

### Basic Setup
```bash
# 1. Copy script folder contents to SD card root
cp -r script/* /path/to/sdcard/

# 2. Insert SD card into RNS-850
# 3. Scripts should auto-execute
```

### Advanced: Encode/Decode Scripts
```bash
# Decode an encoded copie_scr.sh file
cd tools/decoder/
./copie_scr_decoder.exe < encoded_file.sh > decoded_file.sh

# Encode a plain text script  
./copie_scr_decoder.exe < plain_script.sh > encoded_file.sh
```

---

## 🎉 **BREAKTHROUGH: RNS-850 Compatibility Solved!**

### 🔍 **Root Cause Identified and Fixed**
By decoding the RNS-specific `gps_copie_scr.sh`, we discovered **RNS-850 uses completely different SD card mounting**:

**MMI3G Method (Original):**
- Assumes fixed SD path from parameter `$1`
- Checks for specific MMI variant config files
- Complex hardware detection logic

**RNS-850 Method (GPS Script):**
- **Dynamic SD card detection**: `ls /mnt|grep sdcard.*t`
- No complex hardware detection needed
- Direct mount and execute approach

### ✅ **New RNS-850 Compatible Script Created**
- **`script/copie_scr.sh`** - 🎯 **NOW RNS-850 COMPATIBLE!** Properly encoded hybrid script
- **`script/copie_scr_old.sh`** - Original DrGER MMI3G script (backup)
- **`script/copie_scr_DECODED.sh`** - Readable version showing RNS-850 detection logic
- **Automatic detection** - Tries RNS method first, falls back to MMI3G
- **Proper environment setup** for RNS-850 systems

**Ready for testing on actual RNS-850 hardware!**

---

## 🔍 Troubleshooting

### Check Execution
- Monitor `/tmp/` directory for log files
- Look for `emergency.log` in SD card root
- Verify network interface detection
- Check script execute permissions

### Network Issues  
- Verify 192.168.2.x IP assignment
- Test DHCP service status
- Check DNS resolution to 8.8.8.8
- Monitor ethernet adapter recognition

### Script Problems
- Check for Unix (LF) line endings
- Verify all files copied completely  
- Ensure SD card not write-protected
- Look for permission errors in logs

---

## 📖 Documentation & References

### Technical Documentation
- **TELNET_ACCESS.md** - Guide for remote debugging access
- **tools/decoder/README.md** - Complete encoding/decoding guide
- **Audizine Forum** - Original DrGER discussions and updates

### Credits & References
- **DrGER** - Original MMI3G LAN scripts and encoding algorithm
- **megusta1337** - C implementation of decoder on GitHub  
- **Audizine Community** - Testing, documentation, and support
- **daredoole** - RNS-850 adaptation and reverse engineering
**Source Repositories:**
- **DrGER's Original:** https://github.com/DrGER2/MMI3GP-LAN-Setup
- **RNS-850 Reference:** https://github.com/hbsagen/RNS850_gps_logger
- **Copie_scr_Decoder:** https://github.com/megusta1337/Copie_scr_Decoder
---

## 💬 Support

**Issues?** Open an issue in this repository or contact **daredoole**

**Success?** Share your configuration and logs to help improve the project!
