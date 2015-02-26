#!/bin/bash
# suricata -c config/suricata.yaml -s config/apvera-app.rules -q 0
# suricata -c /etc/suricata/suricata.yaml -q 0
suricata -c config/suricata.collect.data.yaml -q 0

