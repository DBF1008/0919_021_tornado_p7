#!/bin/sh
# Manual test script for the request middleware / request_id features.
#
# Covers the four modified modules:
#   tornado/web.py       - Application request_middleware, X-Request-ID header
#   tornado/routing.py   - Rule-level middleware override / nested inheritance
#   tornado/httputil.py  - HTTPServerRequest.request_id
#   tornado/log.py       - RequestIdLogFilter (access_log/app_log/gen_log)
#
# Usage:
#   ./test.sh            run the unit tests for the affected modules
#   ./test.sh --all      run the entire tornado test suite
#
# Note: web/routing HTTP-level tests bind local ports; run them outside
# restricted sandboxes.

cd $(dirname $0)

if [ "$1" = "--all" ]; then
    exec python -m tornado.test.runtests
fi

set -e

echo "== httputil_test (request_id) =="
python -m tornado.test.runtests tornado.test.httputil_test

echo "== log_test (RequestIdLogFilter) =="
python -m tornado.test.runtests tornado.test.log_test

echo "== routing_test (Rule middleware) =="
python -m tornado.test.runtests tornado.test.routing_test

echo "== web_test (request_middleware, X-Request-ID) =="
python -m tornado.test.runtests tornado.test.web_test

echo "== httpserver_test / http1connection_test (request id generation) =="
python -m tornado.test.runtests tornado.test.httpserver_test
python -m tornado.test.runtests tornado.test.http1connection_test

echo "ALL TEST MODULES PASSED"
