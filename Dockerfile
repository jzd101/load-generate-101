FROM ubuntu:20.04

# Avoid interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Install stress-ng and basic tools
RUN apt-get update && \
    apt-get install -y stress-ng coreutils dos2unix && \
    rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy the chaos script
COPY chaos_loader.sh .

# Convert line endings and ensure script is executable
RUN dos2unix chaos_loader.sh && \
    chmod +x chaos_loader.sh

# Run the script
CMD ["/bin/bash", "./chaos_loader.sh"]
