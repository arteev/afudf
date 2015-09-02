#!/usr/bin/env bash

cat "$(dirname $0)/../src/common/verafudf.inc" \
  | tr -d \' | tr -d ' ' | tr -d '\t'

# end.

