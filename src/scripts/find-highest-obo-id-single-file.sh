#!/bin/sh

grep -o "DRON_[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]" $1 | cut -d":" -f2 | sort -u | tail -10
