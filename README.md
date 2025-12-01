# RNS-850 LAN Setup
This repository contains a modified version of the MMI3G LAN setup scripts by DrGer, specifically tailored for the RNS-850 platform.

## Goals
- **Enable LAN connectivity** on RNS-850 units for development and debugging
- **Provide network access** through ethernet connection (192.168.2.x range)
- **Configure DHCP and DNS** services for seamless network integration
- **Maintain compatibility** with RNS-850 hardware limitations and requirements
- **Create stable platform** for further development and testing

## Current Hurdles
- **Script execution incomplete**: Process doesn't fully complete on test hardware
- **Missing log output**: No logs are written to SD card for troubleshooting
- **Network initialization**: DHCP and DNS services may not start properly
- **File permissions**: Potential issues with script execution permissions
- **Hardware differences**: RNS-850 specific quirks compared to MMI3G platform

## Purpose
- This version is **not compatible** with MMI3G or other hardware
- All network, DHCP, and DNS settings are adjusted for RNS-850 requirements
- Configuration uses 192.168.2.x IP range instead of standard ranges

## Usage
- Ensure your device is an RNS-850 before using these scripts
- All configuration files use Unix (LF) line endings for hardware compatibility
- Run `./run.sh` to start the setup process

## Troubleshooting
- Check SD card for log files in `/tmp` directory
- Verify network interface is detected properly
- Ensure scripts have execute permissions
- Monitor DHCP service status during setup

## Support
If you encounter issues, please open an issue in this repository or contact daredoole.
