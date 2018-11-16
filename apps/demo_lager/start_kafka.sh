#!/bin/sh
cd `dirname $0`

#must >1024000
#ulimit -n 1024000
# +A 8
exec erl \
-name demo_lager@127.0.0.1 \
-pa ./_build/default/lib/*/ebin \
-config ./config/kafka.config \
-s demo_lager \
-setcookie XEXIWPUHUJTYKXFMMTXEweb


