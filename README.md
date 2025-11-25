# MMI3GP LAN Setup Diag

LAN hotspot retrofit script for Audi RNS-850/MMI3G systems.

## Purpose
Diagnostic script to troubleshoot DNS/network configuration issues during LAN setup.

## Usage
Run `script/run.sh` from SD card to log current network configuration files.

## Files
- `script/run.sh` - Main diagnostic script (read-only)
- `script/var/` - LAN configuration templates
- Log output saved to SD card with timestamp

## Safety
Script only reads files, makes no system modifications.
