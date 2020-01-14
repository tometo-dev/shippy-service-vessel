FROM golang:alpine as builder
RUN apk update && apk upgrade && apk add --no-cache git
RUN apk add --no-cache gcc musl-dev linux-headers
WORKDIR /app
ENV GO111MODULE=on
COPY . .
RUN go mod download
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o shippy-service-vessel

FROM alpine:latest
RUN apk --no-cache add ca-certificates
WORKDIR /app
COPY --from=builder /app/shippy-service-vessel .
CMD ["./shippy-service-vessel"]