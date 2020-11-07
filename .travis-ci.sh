#!/bin/bash

set -e # halt script on error

HTMLPROOFER_OPTIONS="./_site --internal-domains=https://yips.yearn.finance --check-html --check-opengraph --report-missing-names --log-level=:debug --assume-extension --empty-alt-ignore --timeframe=6w --url-ignore=/YIPS/yip-1"

if [[ $TASK = 'htmlproofer' ]]; then
  bundle exec jekyll doctor
  bundle exec jekyll build
  bundle exec htmlproofer $HTMLPROOFER_OPTIONS --disable-external

  # Validate GH Pages DNS setup
  bundle exec github-pages health-check
elif [[ $TASK = 'htmlproofer-external' ]]; then
  bundle exec jekyll doctor
  bundle exec jekyll build
  bundle exec htmlproofer $HTMLPROOFER_OPTIONS --external_only
elif [[ $TASK = 'yip-validator' ]]; then
  BAD_FILES="$(ls YIPS | egrep -v "yip-[0-9]+.md")" || true
  if [[ ! -z $BAD_FILES ]]; then
    echo "Files found with invalid names:"
    echo $BAD_FILES
    exit 1
  fi

  FILES="$(ls YIPS/*.md | egrep "yip-[0-9]+.md")"
  bundle exec yip_validator $FILES
elif [[ $TASK = 'codespell' ]]; then
  codespell -q4 -I .codespell-whitelist yip-X.md YIPS/
fi
