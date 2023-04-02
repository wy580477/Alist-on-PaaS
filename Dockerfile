FROM alpine

COPY ./content /workdir/

RUN apk add --no-cache curl runit bash tzdata \
    && chmod +x /workdir/service/*/run \
    && sh /workdir/install.sh \
    && rm /workdir/install.sh \
    && ln -s /workdir/service/* /etc/service/

ENV PORT=3000
ENV TZ=UTC

EXPOSE 3000

ENTRYPOINT ["runsvdir", "/etc/service"]
