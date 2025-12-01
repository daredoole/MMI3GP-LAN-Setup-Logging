#!/bin/ksh
# RNS-850 script with aggressive write access attempts
# 20241130 daredoole; RNS-850 write access debugging

# Try multiple locations for debug logs
for logdir in "/tmp" "/var/tmp" "/dev/shm" "/mnt" "."
do
    if [ -d "$logdir" ] && [ -w "$logdir" ]; then
        DEBUGLOG="$logdir/copie_scr_debug.log"
        echo "=== COPIE_SCR DEBUG $(date) ===" > "$DEBUGLOG" 2>/dev/null
        if [ -f "$DEBUGLOG" ]; then
            break
        fi
    fi
done

echo "Using debug log: $DEBUGLOG" >> "$DEBUGLOG" 2>/dev/null

# Check if this is an RNS system
rns_sdcard=`ls /mnt 2>/dev/null | grep sdcard.*t`
echo "RNS detection: '$rns_sdcard'" >> "$DEBUGLOG" 2>/dev/null

# Try to find SD card location
if [ -n "$rns_sdcard" ]; then
    SDPATH="/mnt/$rns_sdcard"
    echo "Using RNS path: $SDPATH" >> "$DEBUGLOG" 2>/dev/null
elif [ -n "$1" ]; then
    SDPATH="$1" 
    echo "Using parameter path: $SDPATH" >> "$DEBUGLOG" 2>/dev/null
else
    # Try to find any SD-like mount
    SDPATH=`mount | grep -i sd | head -1 | awk '{print $3}'`
    echo "Guessed SD path: $SDPATH" >> "$DEBUGLOG" 2>/dev/null
fi

echo "Final SDPATH: $SDPATH" >> "$DEBUGLOG" 2>/dev/null

# Set up environment
export SDPATH
export PATH="${PATH}:${SDPATH}/bin"
export SDLIB="${SDPATH}/lib"  
export SDVAR="${SDPATH}/var"
export MUVER="RNS850"
export SWTRAIN="RNS850"

echo "Environment set" >> "$DEBUGLOG" 2>/dev/null

# Try VERY hard to get write access
echo "Attempting to get write access..." >> "$DEBUGLOG" 2>/dev/null

# Try multiple remount methods
mount -o rw,remount "$SDPATH" >> "$DEBUGLOG" 2>&1
mount -u "$SDPATH" >> "$DEBUGLOG" 2>&1  
mount -uw "$SDPATH" >> "$DEBUGLOG" 2>&1

# Test if we can write to SD card
touch "${SDPATH}/test_write" >> "$DEBUGLOG" 2>&1
if [ -f "${SDPATH}/test_write" ]; then
    echo "SUCCESS: SD card is writable" >> "$DEBUGLOG" 2>/dev/null
    rm "${SDPATH}/test_write" 2>/dev/null
else
    echo "FAILED: SD card is NOT writable" >> "$DEBUGLOG" 2>/dev/null
    echo "Mount info:" >> "$DEBUGLOG" 2>/dev/null
    mount | grep "$SDPATH" >> "$DEBUGLOG" 2>&1
fi

cd "$SDPATH" >> "$DEBUGLOG" 2>&1
echo "Current dir: $(pwd)" >> "$DEBUGLOG" 2>/dev/null
echo "SD contents:" >> "$DEBUGLOG" 2>/dev/null
ls -la >> "$DEBUGLOG" 2>&1

echo "Executing run.sh..." >> "$DEBUGLOG" 2>/dev/null
exec ksh ./run.sh "$SDPATH"
