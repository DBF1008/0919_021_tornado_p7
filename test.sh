#!/bin/sh
# Manual test script for the request-middleware / request-id changes.
#
# Runs the unit tests covering the four touched modules:
#   - tornado/web.py             (Application.request_middleware, X-Request-ID)
#   - tornado/routing.py         (Rule/RuleRouter middleware overrides)
#   - tornado/httputil.py        (HTTPServerRequest.request_id)
#   - tornado/log.py             (RequestIdFilter)
#   - tornado/http1connection.py (request_id generation in start_serving)
#
# Usage:
#   ./test.sh           # run the new feature tests plus related modules
#   ./test.sh --all     # run the full tornado test suite
#
# Note: tests based on AsyncHTTPTestCase need to bind a localhost port;
# in sandboxes that forbid bind(2) they will fail with PermissionError.

cd $(dirname $0)

if [ "$1" = "--all" ]; then
    exec python -m tornado.test.runtests
fi

set -e

echo "== new feature unit tests =="
python -m unittest -v \
    tornado.test.web_test.RequestMiddlewareTest \
    tornado.test.web_test.RequestIdHeaderTest \
    tornado.test.routing_test.RuleMiddlewareTest \
    tornado.test.httputil_test.RequestIdTest \
    tornado.test.log_test.RequestIdFilterTest

echo "== full test modules for touched areas =="
python -m tornado.test.runtests \
    tornado.test.web_test \
    tornado.test.routing_test \
    tornado.test.httputil_test \
    tornado.test.log_test \
    tornado.test.httpserver_test \
    tornado.test.http1connection_test
