# Stage 1: official Xray image (binary only, no shell)
# NOTE: in ghcr.io/xtls/xray-core:1.8.21 the binary lives at /usr/bin/xray
# (see XTLS/Xray-core v1.8.21 .github/docker/Dockerfile)
FROM ghcr.io/xtls/xray-core:1.8.21 AS xray

# Stage 2: minimal Alpine runtime
FROM alpine:latest
RUN apk add --no-cache ca-certificates
COPY --from=xray /usr/bin/xray /usr/local/bin/xray
COPY config.json /etc/xray/config.json
EXPOSE 3000
# Inject the UUID env var into the config at container start, then run xray.
# (No separate shell script file: avoids shebang/CRLF startup failures.)
ENTRYPOINT ["sh", "-c", "sed -i \"s/__UUID__/${UUID:?UUID env var is required}/\" /etc/xray/config.json && exec /usr/local/bin/xray run -config /etc/xray/config.json"]
