#!/usr/bin/env bash
# validate_links.sh — check all external hrefs and internal anchors in index.html

EXIT_CODE=0

echo "=== Checking external links ==="
URLS=$(grep -oE 'href="https?://[^"]*"' index.html | grep -oE 'https?://[^"]*')

if [ -z "$URLS" ]; then
  echo "No external links found."
else
  for URL in $URLS; do
    STATUS=$(curl -o /dev/null -s -w "%{http_code}" --max-time 10 -L "$URL")
    if [ "$STATUS" -ge 200 ] && [ "$STATUS" -lt 400 ]; then
      echo "OK   [$STATUS]  $URL"
    else
      echo "FAIL [$STATUS]  $URL"
      EXIT_CODE=1
    fi
  done
fi

echo ""
echo "=== Checking internal anchor links ==="
ANCHORS=$(grep -oE 'href="#[^"]*"' index.html | grep -oE '#[^"]*' | sort -u)

for ANCHOR in $ANCHORS; do
  ID="${ANCHOR#'#'}"
  if grep -q "id=\"$ID\"" index.html; then
    echo "OK   $ANCHOR -> id=\"$ID\" found"
  else
    echo "FAIL $ANCHOR -> id=\"$ID\" not found in index.html"
    EXIT_CODE=1
  fi
done

echo ""
if [ "$EXIT_CODE" -eq 0 ]; then
  echo "All links passed."
else
  echo "One or more links failed."
fi

exit $EXIT_CODE
