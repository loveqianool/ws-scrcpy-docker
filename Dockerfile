FROM alpine:edge AS builder

RUN apk add --no-cache nodejs npm python3 make g++ git
RUN git clone https://github.com/NetrisTV/ws-scrcpy.git
WORKDIR /ws-scrcpy
RUN npm install
RUN npm run dist
WORKDIR dist
RUN npm install

FROM alpine:edge AS runner
LABEL maintainer="Vitaly Repin <vitaly.repin@gmail.com>"

RUN apk add --no-cache android-tools npm

COPY --from=builder /ws-scrcpy/dist /ws-scrcpy

RUN cat > /ws-scrcpy/z.sh <<'EOT'
#!/bin/sh
cd /ws-scrcpy

for i in $(echo $host | sed "s/,/ /g")
do
    adb connect $i:5555
done

npm start

EOT

WORKDIR /ws-scrcpy

CMD ["sh", "/ws-scrcpy/z.sh"]
