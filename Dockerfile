FROM golang:1.20-alpine AS builder
ENV GO111MODULE=on
RUN apk --update upgrade \
    && apk --no-cache --no-progress add git ca-certificates libcap \
    && update-ca-certificates
WORKDIR /app
ADD . .
RUN go mod download
RUN go mod verify
RUN mkdir /loaderio
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -ldflags="-w -s" -o /loaderio/loaderio ./cmd
RUN cp -r static /loaderio
RUN addgroup -S -g 10101 appuser
RUN adduser -S -D -u 10101 -s /sbin/nologin -h /appuser -G appuser appuser
RUN chown -R appuser:appuser /loaderio/loaderio
RUN setcap 'cap_net_bind_service=+ep' /loaderio/loaderio

FROM scratch
EXPOSE 80
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt
COPY --from=builder /etc/group /etc/passwd /etc/
COPY --from=builder /loaderio /
USER appuser
ENTRYPOINT ["/loaderio"]

# cap_net_bind_service çalışması için app klasör içinde olmalı, klasör kopyalanmalı.
# https://medium.com/elbstack/docker-go-and-privileged-ports-d6354db472c3
