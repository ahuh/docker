FROM docker:27.1.1 AS git-bash

# Set env var dedicated to build-time only (for availability during docker BUILD phase)
# - HTTP proxy settings
# - apk arguments (skip TLS validation with Zscaler)

ARG http_proxy
ARG https_proxy
ARG HTTP_PROXY
ARG HTTPS_PROXY
ARG APK_ARG_KEY
ARG APK_ARG_VALUE

RUN apk add --no-cache ${APK_ARG_KEY} ${APK_ARG_VALUE} git bash