# Use official Python 3.10 slim image
FROM python:3.10-slim

# Set environment variable for Chrome version
ARG CHROME_VERSION=112.0.5615.49

# Install dependencies for Chrome and ChromeDriver
RUN apt-get update && apt-get install -y \
    wget \
    unzip \
    gnupg \
    ca-certificates \
    fonts-liberation \
    libatk-bridge2.0-0 \
    libatk1.0-0 \
    libcups2 \
    libdrm2 \
    libxkbcommon0 \
    libxcomposite1 \
    libxdamage1 \
    libxrandr2 \
    libgbm1 \
    libasound2 \
    libpangocairo-1.0-0 \
    libpango-1.0-0 \
    libxcb1 \
    libx11-xcb1 \
    libxshmfence1 \
    libnss3 \
    libxss1 \
    libxtst6 \
    --no-install-recommends && \
    rm -rf /var/lib/apt/lists/*

# Install Google Chrome 112
RUN wget -O /tmp/google-chrome.deb "https://mirror.cs.uchicago.edu/google-chrome/pool/main/g/google-chrome-stable/google-chrome-stable_${CHROME_VERSION}-1_amd64.deb" && \
    apt-get update && apt-get install -y /tmp/google-chrome.deb && \
    rm /tmp/google-chrome.deb && \
    rm -rf /var/lib/apt/lists/*

# Install matching ChromeDriver 112
RUN wget https://chromedriver.storage.googleapis.com/112.0.5615.49/chromedriver_linux64.zip && \
    unzip chromedriver_linux64.zip && \
    mv chromedriver /usr/local/bin/chromedriver && \
    chmod +x /usr/local/bin/chromedriver && \
    rm chromedriver_linux64.zip

# Install Python Selenium 4.9.0
RUN pip install selenium==4.9.0

# Create working directory
WORKDIR /app


# Define environment variables for Chrome
ENV CHROME_VERSION=112.0.5615.49
ENV CHROME_BIN=/usr/local/bin/google-chrome-stable
ENV CHROMEDRIVER_BIN=/usr/local/bin/chromedriver

# Define volumes for external config and data mapping
VOLUME /config
VOLUME /data

# Run your script by default
CMD ["python", "/config/script.py"]
