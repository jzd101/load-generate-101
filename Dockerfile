FROM ubuntu:20.04

# Avoid interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Install stress-ng and basic tools
RUN apt-get update && \
    apt-get install -y stress-ng coreutils && \
    rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy the chaos script
COPY chaos_loader.sh .

# Ensure script is executable
RUN chmod +x chaos_loader.sh

# Run the script
CMD ["./chaos_loader.sh"]
