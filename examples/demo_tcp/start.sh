#!/bin/sh
cd `dirname $0`

#must >1024000
#ulimit -n 1024000
# +A 8
exec erl \
-name demo_tcp@127.0.0.1 \
-pa ./_build/default/lib/*/ebin \
-config ./config/sys.config \
-s reloader \
-s demo_tcp \
-setcookie XEXIWPUHUJTYKXFMMTXEweb


