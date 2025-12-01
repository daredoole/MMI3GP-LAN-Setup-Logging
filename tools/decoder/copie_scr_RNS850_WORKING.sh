#!/bin/ksh
# RNS-850 copie_scr.sh based on working hbsagen GPS logger
# Adapted from: https://github.com/hbsagen/RNS850_gps_logger

# Find SD card the RNS-850 way
sdcard=`ls /mnt|grep sdcard.*t`
echo Using card $sdcard

# Set paths like working RNS-850 script  
dstPath=/mnt/$sdcard
SDPath=/mnt/$sdcard

# Critical RNS-850 mount sequence
mount -u $dstPath
echo remounted for full access

# THIS IS THE KEY: Mount efs-system with write access
mount -uw /mnt/efs-system

# Set environment variables for DrGER's run.sh compatibility
export SDPATH=$SDPath
export PATH=${PATH}:${SDPATH}/bin
export SDLIB=${SDPATH}/lib
export SDVAR=${SDPATH}/var  
export MUVER="RNS850"
export SWTRAIN="RNS850"

# Create emergency log (should work now with efs-system write access)
echo "EMERGENCY LOG START: $(date)" > ${SDPATH}/emergency.log 2>&1
echo "SDPATH=${SDPATH}" >> ${SDPATH}/emergency.log 2>&1
echo "Using RNS-850 mount sequence" >> ${SDPATH}/emergency.log 2>&1
echo "sdcard=$sdcard" >> ${SDPATH}/emergency.log 2>&1

cd $dstPath
exec ksh ./run.sh $SDPATH
