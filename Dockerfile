FROM ubuntu:latest

# Install necessary packages
RUN apt-get update && apt-get install -y \
    curl \
    gnupg \
    software-properties-common

# Add Node.js 20 repository and install Node.js
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs

# Add Google Chrome repository and install Google Chrome
RUN curl -fsSL https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - && \
    sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list' && \
    apt-get update && \
    apt-get install -y google-chrome-stable

# Create and change to the app directory
WORKDIR /usr/src/app


# Copy the bash script
COPY script.sh /usr/src/app/

# Make the bash script executable
RUN chmod +x /usr/src/app/script.sh

# Expose the port the app runs on
EXPOSE 3000

# Define environment variable
ENV PORT 3000

# Run the bash script
CMD ["/usr/src/app/script.sh"]