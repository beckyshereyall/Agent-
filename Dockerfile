# Stage 1: Build (This happens on GitHub/Docker Hub, not your 512MB VPS)
FROM rust:1.75-slim AS builder
RUN apt-get update && apt-get install -y pkg-config libssl-dev git
WORKDIR /usr/src/openfang
# Clone the official repo
RUN git clone https://github.com .
RUN cargo build --release

# Stage 2: Tiny Runtime (This is what runs on Railway)
FROM debian:bookworm-slim
RUN apt-get update && apt-get install -y libssl3 ca-certificates && rm -rf /var/lib/apt/lists/*
WORKDIR /app
COPY --from=builder /usr/src/openfang/target/release/openfang /usr/local/bin/openfang

# Create data directory for persistence
RUN mkdir /data
ENV OPENFANG_HOME=/data

EXPOSE 8080
CMD ["openfang", "start", "--port", "8080"]
