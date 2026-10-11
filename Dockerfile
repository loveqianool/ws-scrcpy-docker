FROM alpine:edge AS builder

RUN apk add --no-cache nodejs npm python3 make g++ git && \
    git clone --depth 1 https://github.com/NetrisTV/ws-scrcpy.git /ws-scrcpy && \
    rm -rf /ws-scrcpy/.git

WORKDIR /ws-scrcpy
RUN npm install --no-fund --no-audit && npm run dist

WORKDIR /ws-scrcpy/dist
RUN npm install --production --no-fund --no-audit


FROM alpine:edge AS runner

LABEL org.opencontainers.image.authors="Vitaly Repin <vitaly.repin@gmail.com>"
LABEL org.opencontainers.image.source="https://github.com/NetrisTV/ws-scrcpy"

RUN apk add --no-cache android-tools nodejs npm && \
    adduser -D -h /ws-scrcpy appuser

COPY --from=builder --chown=appuser:appuser /ws-scrcpy/dist /ws-scrcpy

COPY <<-'SH' /ws-scrcpy/entrypoint.sh
#!/bin/sh
set -e
cd /ws-scrcpy

if [ -n "${host:-}" ]; then
    OLD_IFS="$IFS"
    IFS=,
    for dev in $host; do
        [ -z "$dev" ] && continue
        echo "connect adb device: ${dev}:5555"
        adb connect "${dev}:5555" || true
    done
    IFS="$OLD_IFS"
fi

exec npm start
SH

RUN chmod +x /ws-scrcpy/entrypoint.sh

USER appuser
WORKDIR /ws-scrcpy
CMD ["/ws-scrcpy/entrypoint.sh"]
