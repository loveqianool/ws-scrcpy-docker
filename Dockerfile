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

COPY --from=builder /ws-scrcpy/dist /ws-scrcpy
COPY --from=builder /ws-scrcpy/node_modules /ws-scrcpy/node_modules
RUN apk add --no-cache android-tools npm
RUN apk add --update \
          python3 \
          make \
          g++ && cd /ws-scrcpy/node_modules/node-pty && yarn run install

EXPOSE 8000

WORKDIR /ws-scrcpy
CMD ["npm", "start"]
