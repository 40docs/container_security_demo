# Use Alpine as base
FROM alpine:3.12

LABEL maintainer = "ajammes@fortinet.com"

RUN apk update && \
    apk add curl && \
    apk add vim && \
    apk add git
