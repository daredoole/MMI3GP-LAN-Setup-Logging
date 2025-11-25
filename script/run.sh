#!/bin/ksh

# MMI3GP LAN Setup - Diagnostic Script
# Created by: dpoole
# Date: November 25, 2025
# Purpose: Log contents of DNS/network files for troubleshooting
# Safety: READ-ONLY operations, no system modifications

# Diagnostic script: Only log contents of relevant files, no LAN setup or file modification
# Script startup env from copie_scr.sh
showScreen ${SDLIB}/lansetup-0.png
touch ${SDPATH}/.started
xlogfile=${SDPATH}/run-$(getTime).log
exec > ${xlogfile} 2>&1
echo "[INFO] Diagnostic Test: $(date); Timestamp: $(getTime)"
echo
echo "[INFO] Contents of /etc/dhcp/dhcp-up :"
cat /etc/dhcp/dhcp-up
echo
echo "[INFO] Contents of /etc/resolv.conf :"
cat /etc/resolv.conf
echo
echo "[INFO] Contents of ${SDVAR}/dhcp-down-LAN :"
cat ${SDVAR}/dhcp-down-LAN
echo
echo "[INFO] Contents of ${SDVAR}/dhcp-up-LAN :"
cat ${SDVAR}/dhcp-up-LAN
echo
echo "[INFO] Contents of ${SDVAR}/dnsrdr1.conf-LAN :"
cat ${SDVAR}/dnsrdr1.conf-LAN
echo
echo "[INFO] Contents of ${SDVAR}/dnsrdr2.conf-LAN :"
cat ${SDVAR}/dnsrdr2.conf-LAN
echo
echo "[INFO] Contents of ${SDVAR}/nws.cfg-LAN :"
cat ${SDVAR}/nws.cfg-LAN
echo
echo "[INFO] Contents of ${SDVAR}/nws.cfg-LAN1 :"
cat ${SDVAR}/nws.cfg-LAN1
echo
echo "[INFO] Contents of ${SDVAR}/pf.conf-LAN :"
cat ${SDVAR}/pf.conf-LAN
echo
echo "[INFO] Contents of ${SDVAR}/pf.conf-LAN3 :"
cat ${SDVAR}/pf.conf-LAN3
echo
echo "[INFO] Contents of ${SDVAR}/resolv.conf-FIXEDIP :"
cat ${SDVAR}/resolv.conf-FIXEDIP
echo
echo "[INFO] Contents of ${SDVAR}/start_network.sh-LAN :"
cat ${SDVAR}/start_network.sh-LAN
echo
echo "[INFO] End of diagnostic test."
showScreen ${SDLIB}/lansetup-1.png
rm -f ${SDPATH}/.started
exit 0

