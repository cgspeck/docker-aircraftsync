FROM alpine:latest

RUN apk add --no-cache --update subversion curl bash shadow


WORKDIR /app
ADD . /app

VOLUME ["/dist"]
ENV URL="http://svn.code.sf.net/p/flightgear/fgaddon/branches/release-2018.3/Aircraft/"
ENV PUID=1000
ENV PGID=1000

ENTRYPOINT ["./entrypoint.sh"]
