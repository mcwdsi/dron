#!/bin/sh

grep -o -r --include="*.owl" "DRON_[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]" ./ | cut -d":" -f2 | sort -u | tail -10