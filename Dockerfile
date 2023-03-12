FROM alpine:3.14 AS builder

RUN apk add --no-cache nodejs npm python3 make g++ git
RUN git clone https://github.com/NetrisTV/ws-scrcpy.git
WORKDIR /ws-scrcpy
RUN npm install
RUN npm run dist
WORKDIR dist
RUN npm install

FROM alpine:3.14 AS runner
LABEL maintainer="Vitaly Repin <vitaly.repin@gmail.com>"

RUN apk add --no-cache android-tools npm

COPY --from=builder /ws-scrcpy/dist /ws-scrcpy
COPY start.sh /ws-scrcpy/start.sh

WORKDIR /ws-scrcpy

CMD ["sh", "start.sh"]
