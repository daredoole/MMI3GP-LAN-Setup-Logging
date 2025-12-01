#!/bin/ksh
# Modified DrGER script for RNS-850 compatibility
# 20231112 drger; Added MMI3GB
# 20221220 drger; Added MUVER
# 20220103 drger; MMI3G/MMI3GP SD shell script launcher
# 20241130 daredoole; Added RNS-850 support

# Check if this is an RNS system (dynamic SD card detection)
rns_sdcard=`ls /mnt 2>/dev/null | grep sdcard.*t`

if [ -n "$rns_sdcard" ]; then
    # RNS-850 / GPS system detected
    echo "RNS system detected, using dynamic SD card: $rns_sdcard"
    export SDPATH=/mnt/$rns_sdcard
    export PATH=${PATH}:${SDPATH}/bin
    export SDLIB=${SDPATH}/lib
    export SDVAR=${SDPATH}/var
    export MUVER="RNS850"
    export SWTRAIN="RNS850"
    
    mount -u $SDPATH
    echo "Remounted $SDPATH for full access"
    cd $SDPATH
    exec ksh ./run.sh $SDPATH
    
else
    # Original MMI3G system logic
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
fi
