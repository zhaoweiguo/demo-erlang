#!/bin/sh
cd `dirname $0`

#must >1024000
#ulimit -n 1024000
# +A 8
exec erl \
-name demo_coap@127.0.0.1 \
-pa ./_build/default/lib/*/ebin \
-config ./config/sys.config \
-s demo_coap \
-setcookie XEXIWPUHUJTYKXFMMTXEweb


