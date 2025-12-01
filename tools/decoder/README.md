# DrGER copie_scr.sh Decoder Tools

Tools and documentation for decrypting/encrypting DrGER's copie_scr.sh files used in Audi/VW MMI systems.

## ✅ **DECODING SUCCESS - ALGORITHM FULLY SOLVED!**

**Status: 100% Working!** We have successfully decoded DrGER's complete copie_scr.sh script.

## Files

- **`copie_scr_decoder.exe`** - Official compiled decoder (Windows, 125KB)  
- **`copie_scr_decoder.c`** - C source code for the decoder algorithm
- **`copie_scr_DECODED_EXAMPLE.sh`** - ✅ **COMPLETE working decoded script**
- **`complete_decode.sh`** - ✅ **Latest complete decode (verified in WSL)**
- **`copie_scr_decoder_linux`** - Compiled Linux version for WSL testing

## Complete Decoded Script

The decoded copie_scr.sh is a sophisticated launcher that:
- **Detects MMI variant** (MMI3GB, MMI3GH, or MMI3GP)
- **Sets environment variables** for SD path, libraries, binaries
- **Mounts SD card** and executes the main run.sh script
- **100% syntactically valid** (verified with bash -n)

### Full Script Content:
```bash
#!/bin/ksh
# 20231112 drger; Added MMI3GB
# 20221220 drger; Added MUVER
# 20220103 drger; MMI3G/MMI3GP SD shell script launcher
export SDPATH=$1
export PATH=${PATH}:${SDPATH}/bin
export SDLIB=${SDPATH}/lib
export SDVAR=${SDPATH}/var
export MUVER="n/a"
export SWTRAIN="n/a"
if [ -e /etc/pci-3g_9304.cfg ]
then
 MUVER="MMI3GB"
elif [ -e /etc/pci-3g_9308.cfg ]
then
 MUVER="MMI3GH"
elif [ -e /etc/pci-3g_9411.cfg ]
then
 MUVER="MMI3GP"
 SWTRAIN="$(cat /dev/shmem/sw_trainname.txt)"
fi
mount -u $SDPATH
cd $SDPATH
exec ksh ./run.sh $SDPATH
```

## Key Findings

### Hardware Detection Logic
The script checks for specific config files to determine MMI variant:
- **`/etc/pci-3g_9304.cfg`** → MMI3GB
- **`/etc/pci-3g_9308.cfg`** → MMI3GH  
- **`/etc/pci-3g_9411.cfg`** → MMI3GP

### RNS-850 Compatibility Issue
**This may explain why scripts don't work on RNS-850!** The script looks for MMI3G config files that likely don't exist on RNS-850 hardware.

## Usage

### Compile on Unix/Linux:
```bash
gcc -o copie_scr_decoder copie_scr_decoder.c
```

### Decrypt an encoded file:
```bash
# Unix/Linux  
./copie_scr_decoder < encoded_file.sh > decoded_file.txt

# Windows (PowerShell - in this directory)
cmd /c "copie_scr_decoder.exe < encoded_file.sh > decoded_file.txt"
```

### Encrypt a plain text file:
```bash
# Unix/Linux  
./copie_scr_decoder < plain_script.txt > encoded_file.sh

# Windows (PowerShell - in this directory)
cmd /c "copie_scr_decoder.exe < plain_script.txt > encoded_file.sh"
```

## Algorithm Details

The copie_scr.sh files use a **custom PRNG-based XOR cipher**:

- **Initial seed:** `0x001be3ac`
- **Method:** Each byte is XORed with output from a custom PRNG
- **Encryption/Decryption:** Same algorithm (XOR is reversible)

### PRNG Algorithm:
```c
unsigned int prng_rand() {
    unsigned int r1, r3, r0;
    r0 = seed;
    r1 = (seed >> 1) | (seed << 31);
    r3 = ((r1 >> 16) & 0xFF) + r1;
    r1 = ((r3 >> 8) & 0xFF) << 16;
    r3 -= r1;
    seed = r3;
    return r0;
}
```

## ✅ Successfully Reverse Engineered

This decoder was successfully reverse-engineered by analyzing:
1. DrGER's forum posts and documentation
2. The original C source code from GitHub
3. Extensive testing and validation

The algorithm works perfectly for encoding/decoding valid copie_scr.sh files.

## Credits

- **DrGER** - Original encoding algorithm and MMI development
- **megusta1337** - C source code implementation on GitHub
- **Audizine Forum Community** - Documentation and sharing
- **daredoole** - Reverse engineering and PowerShell implementation

## References

- [DrGER's Forum Post](https://www.audizine.com/forum/showthread.php/946917-New-and-Improved-Encoded-copie_scr-sh-Script)
- [GitHub Repository](https://github.com/megusta1337/Copie_scr_Decoder)
