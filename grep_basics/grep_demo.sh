#!/usr/bin/env bash
# HY-280 — grep demonstrations on customers.csv
# Run: bash grep_demo.sh
# Put customers.csv in the same directory as this script.
# Uses macOS-compatible grep (ERE); no GNU-only options.

set -u
cd "$(dirname "$0")" || exit 1
if [ ! -f customers.csv ]; then
  echo "Missing customers.csv. Put it alongside grep_demo.sh." >&2
  exit 1
fi

step=0
show() {
  step=$((step + 1))
  printf '\n\033[1;36m[%02d] %s\033[0m\n' "$step" "$1"
  printf '\033[0;33m$ %s\033[0m\n' "$2"
}

show 'All CSV records (excluding header)' 'tail -n +2 customers.csv'
tail -n +2 customers.csv

show 'Find Greek customers: country is field 6' "grep -E '^([^,]*,){5}GR,' customers.csv"
grep -E '^([^,]*,){5}GR,' customers.csv

show 'Find US customers' "grep -E '^([^,]*,){5}US,' customers.csv"
grep -E '^([^,]*,){5}US,' customers.csv

show 'PAID customers (status at end of line)' "grep -E ',PAID$' customers.csv"
grep -E ',PAID$' customers.csv

show 'Customers whose status is DUE or HOLD' "grep -E ',(DUE|HOLD)$' customers.csv"
grep -E ',(DUE|HOLD)$' customers.csv

show 'Greek customers with syntactically correct 5-digit postal codes' "grep -E '^([^,]*,){4}[0-9]{5},GR,' customers.csv"
grep -E '^([^,]*,){4}[0-9]{5},GR,' customers.csv

show 'US customers with ZIP or ZIP+4' "grep -E ',[0-9]{5}(-[0-9]{4})?,US,' customers.csv"
grep -E ',[0-9]{5}(-[0-9]{4})?,US,' customers.csv

show 'Malformed email example: double @' "grep -nE '@@' customers.csv"
grep -nE '@@' customers.csv

show 'Emails with a plausible simple email pattern (not full validation)' "grep -E ',[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,},' customers.csv"
grep -E ',[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,},' customers.csv

show 'Rows without a plausible email field (data only)' "tail -n +2 customers.csv | grep -Ev '^([^,]*,){2}[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,},'"
tail -n +2 customers.csv | grep -Ev '^([^,]*,){2}[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,},'

show 'Greek-style mobile phone with optional +30 prefix' "grep -E ',(\\+30[ -]?)?69[0-9]{8},' customers.csv"
grep -E ',(\+30[ -]?)?69[0-9]{8},' customers.csv

show 'Malformed GR postal code: NOT five digits (data only)' "tail -n +2 customers.csv | grep -E '^([^,]*,){5}GR,' | grep -Ev '^([^,]*,){4}[0-9]{5},GR,'"
tail -n +2 customers.csv | grep -E '^([^,]*,){5}GR,' | grep -Ev '^([^,]*,){4}[0-9]{5},GR,'

show 'Find example.com email domains (literal dot)' "grep -E ',[^,]+@example\\.com,' customers.csv"
grep -E ',[^,]+@example\.com,' customers.csv

show 'Case-insensitive name search for maria' "grep -iE '^([0-9]+,)maria,' customers.csv"
grep -iE '^([0-9]+,)maria,' customers.csv

show 'Extract just the email field using grep -oE' "tail -n +2 customers.csv | grep -oE '^[^,]*,[^,]*,[^,]*' | grep -oE '[^,]+$'"
tail -n +2 customers.csv | grep -oE '^[^,]*,[^,]*,[^,]*' | grep -oE '[^,]+$'

show 'Count paid records (count matching lines)' "grep -cE ',PAID$' customers.csv"
grep -cE ',PAID$' customers.csv

show 'How many Greek customers? (grep -c)' "grep -cE '^([^,]*,){5}GR,' customers.csv"
grep -cE '^([^,]*,){5}GR,' customers.csv

show 'Show row numbers for the US records' "grep -nE '^([^,]*,){5}US,' customers.csv"
grep -nE '^([^,]*,){5}US,' customers.csv

show 'Find data rows with any empty CSV field (none expected)' "tail -n +2 customers.csv | grep -nE ',,|^,|,$' || echo '(no matches)'"
tail -n +2 customers.csv | grep -nE ',,|^,|,$' || echo '(no matches)'

printf '\n\033[1;32mFinished %d grep demonstrations.\033[0m\n' "$step"
