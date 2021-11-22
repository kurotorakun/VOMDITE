#!/bin/bash

echo -e "[ $(date +%H:%m:%S) ] Testing http://${WAN1UPLINKCIDR}.1" | tee ./results_export.log
echo -e "LOOKUP \t\tCONNECT \tPRE-TRANSFER \tSTART-TRANSFER \tTOTAL \t\tCODE \tURL \t\t\tDOCKER ID" | tee -a ./results_export.log
while true
do
  # On template (tpl) file % is duplicated as escape char.
  res=$(curl http://${WAN1UPLINKCIDR}.1 -s -w "%%{time_namelookup} \t%%{time_connect} \t%%{time_pretransfer} \t%%{time_starttransfer} \t%%{time_total} \t%%{http_code} \t%%{url_effective}\n") # No time-out to avoid AWK glitches
  echo $res | awk -v OFS='\t' '{print $15,$16,$17,$18,$19,$20,$21,$6}' | tee -a ./results_export.log
  sleep 1
done
