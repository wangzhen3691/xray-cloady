# Stage 1: official Xray image (binary only, no shell)
FROM ghcr.io/xtls/xray-core:1.8.21 AS xray

# Stage 2: minimal Alpine runtime
FROM alpine:latest
RUN apk add --no-cache ca-certificates
COPY --from=xray /usr/local/bin/xray /usr/local/bin/xray
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
EXPOSE 3000
ENTRYPOINT ["/entrypoint.sh"]
