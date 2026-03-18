# Use a minimal runtime image
FROM debian:bookworm-slim

# Install basics (needed for API calls and downloading the binary)
RUN apt-get update && apt-get install -y \
    ca-certificates \
    curl \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Download the latest pre-compiled Linux binary (Fast & Zero RAM used for building)
RUN curl -L https://github.com -o openfang \
    && chmod +x openfang \
    && mv openfang /usr/local/bin/

# Persistent data directory
RUN mkdir /data
ENV OPENFANG_HOME=/data

# Start the engine
EXPOSE 8080
CMD ["openfang", "start", "--port", "8080"]
