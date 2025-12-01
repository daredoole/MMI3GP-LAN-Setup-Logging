#!/bin/ksh
# Modified DrGER script for RNS-850 compatibility with enhanced debugging
# 20231112 drger; Added MMI3GB
# 20221220 drger; Added MUVER
# 20220103 drger; MMI3G/MMI3GP SD shell script launcher
# 20241130 daredoole; Added RNS-850 support + debugging

# Create immediate debug log - this should always work
echo "=== COPIE_SCR DEBUG START $(date) ===" > /tmp/copie_scr_debug.log 2>&1

# Check if this is an RNS system (dynamic SD card detection)
echo "Checking for RNS system..." >> /tmp/copie_scr_debug.log 2>&1
rns_sdcard=`ls /mnt 2>/dev/null | grep sdcard.*t`
echo "RNS SD card detection result: '$rns_sdcard'" >> /tmp/copie_scr_debug.log 2>&1

# Also try alternative detection methods
echo "Alternative detection methods:" >> /tmp/copie_scr_debug.log 2>&1
echo "ls /mnt output:" >> /tmp/copie_scr_debug.log 2>&1
ls /mnt >> /tmp/copie_scr_debug.log 2>&1
echo "mount output:" >> /tmp/copie_scr_debug.log 2>&1
mount | grep -i sdcard >> /tmp/copie_scr_debug.log 2>&1

if [ -n "$rns_sdcard" ]; then
    # RNS-850 / GPS system detected
    echo "RNS system detected, using dynamic SD card: $rns_sdcard"
    echo "RNS PATH: Using /mnt/$rns_sdcard" >> /tmp/copie_scr_debug.log 2>&1
    export SDPATH=/mnt/$rns_sdcard
    export PATH=${PATH}:${SDPATH}/bin
    export SDLIB=${SDPATH}/lib
    export SDVAR=${SDPATH}/var
    export MUVER="RNS850"
    export SWTRAIN="RNS850"
    
    echo "RNS Environment set:" >> /tmp/copie_scr_debug.log 2>&1
    echo "SDPATH=$SDPATH" >> /tmp/copie_scr_debug.log 2>&1
    echo "SDLIB=$SDLIB" >> /tmp/copie_scr_debug.log 2>&1
    echo "SDVAR=$SDVAR" >> /tmp/copie_scr_debug.log 2>&1
    
    mount -u $SDPATH >> /tmp/copie_scr_debug.log 2>&1
    echo "Remounted $SDPATH for full access" 
    echo "Mount result: $?" >> /tmp/copie_scr_debug.log 2>&1
    
    cd $SDPATH
    echo "Changed to directory: $(pwd)" >> /tmp/copie_scr_debug.log 2>&1
    echo "Contents of SD root:" >> /tmp/copie_scr_debug.log 2>&1
    ls -la >> /tmp/copie_scr_debug.log 2>&1
    
    echo "About to execute: ksh ./run.sh $SDPATH" >> /tmp/copie_scr_debug.log 2>&1
    exec ksh ./run.sh $SDPATH
    
else
    # Try to detect SD card by parameter or other methods
    echo "RNS detection failed, trying MMI3G method with parameter: $1" >> /tmp/copie_scr_debug.log 2>&1
    
    # If no parameter, try to find SD card another way
    if [ -z "$1" ]; then
        echo "No parameter provided, trying to find SD card..." >> /tmp/copie_scr_debug.log 2>&1
        # Look for any mounted SD-like device
        possible_sd=`mount | grep -i sd | head -1 | awk '{print $3}'`
        echo "Found possible SD mount: $possible_sd" >> /tmp/copie_scr_debug.log 2>&1
        if [ -n "$possible_sd" ]; then
            export SDPATH="$possible_sd"
        else
            export SDPATH="/unknown"
        fi
    else
        export SDPATH=$1
    fi
    
    echo "MMI3G PATH: Using $SDPATH" >> /tmp/copie_scr_debug.log 2>&1
    export PATH=${PATH}:${SDPATH}/bin
    export SDLIB=${SDPATH}/lib
    export SDVAR=${SDPATH}/var
    export MUVER="n/a"
    export SWTRAIN="n/a"
    
    if [ -e /etc/pci-3g_9304.cfg ]
    then
     MUVER="MMI3GB"
     echo "Detected MMI3GB" >> /tmp/copie_scr_debug.log 2>&1
    elif [ -e /etc/pci-3g_9308.cfg ]
    then
     MUVER="MMI3GH"
     echo "Detected MMI3GH" >> /tmp/copie_scr_debug.log 2>&1
    elif [ -e /etc/pci-3g_9411.cfg ]
    then
     MUVER="MMI3GP"
     SWTRAIN="$(cat /dev/shmem/sw_trainname.txt)"
     echo "Detected MMI3GP" >> /tmp/copie_scr_debug.log 2>&1
    fi
    
    echo "MMI3G Environment set:" >> /tmp/copie_scr_debug.log 2>&1
    echo "SDPATH=$SDPATH" >> /tmp/copie_scr_debug.log 2>&1
    echo "MUVER=$MUVER" >> /tmp/copie_scr_debug.log 2>&1
    echo "SWTRAIN=$SWTRAIN" >> /tmp/copie_scr_debug.log 2>&1
    
    mount -u $SDPATH >> /tmp/copie_scr_debug.log 2>&1
    cd $SDPATH >> /tmp/copie_scr_debug.log 2>&1
    echo "Changed to directory: $(pwd)" >> /tmp/copie_scr_debug.log 2>&1
    echo "Contents:" >> /tmp/copie_scr_debug.log 2>&1
    ls -la >> /tmp/copie_scr_debug.log 2>&1
    
    echo "About to execute: ksh ./run.sh $SDPATH" >> /tmp/copie_scr_debug.log 2>&1
    exec ksh ./run.sh $SDPATH
fi
