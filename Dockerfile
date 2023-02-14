FROM alpine AS builder

RUN apk add --no-cache nodejs npm python3 make g++ git
RUN git clone https://github.com/NetrisTV/ws-scrcpy.git
WORKDIR /ws-scrcpy
RUN npm install
RUN npm run dist
WORKDIR dist
RUN npm install

FROM alpine AS runner
LABEL maintainer="Vitaly Repin <vitaly.repin@gmail.com>"

RUN apk add --no-cache android-tools npm python3
COPY --from=builder /ws-scrcpy/dist /ws-scrcpy

WORKDIR /ws-scrcpy
CMD ["npm", "start"]
