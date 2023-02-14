FROM alpine

RUN apk add --no-cache nodejs npm python3 make g++ git android-tools
RUN git clone https://github.com/NetrisTV/ws-scrcpy.git
WORKDIR /ws-scrcpy
RUN npm install
RUN npm run dist
WORKDIR dist
RUN npm install

EXPOSE 8000

CMD ["npm", "start"]
