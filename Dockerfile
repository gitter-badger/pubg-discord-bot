FROM python:3.6-alpine

LABEL megacat-studio, https://github.com/megacat-studio/pubg-discord-bot

# Add project source
WORKDIR /usr/src/pubg-discord-bot
COPY . ./

# Install dependencies
RUN apk update \
    && apk add --no-cache \
    ca-certificates \
    ffmpeg \
    opus \
    python3 \
    libsodium-dev \
    \
    # Install build dependencies
    && apk add --no-cache --virtual .build-deps \
    gcc \
    git \
    libffi-dev \
    make \
    musl-dev \
    python3-dev \
    \
    # Install pip dependencies
    && pip3 install --no-cache-dir -r requirements.txt \
    && pip3 install --upgrade --force-reinstall --version websockets==4.0.1 \
    \
    # Clean up build dependencies
    && apk del .build-deps

# Create volume for mapping the config
VOLUME /usr/src/pubg-discord-bot/config

ENV APP_ENV=docker

ENTRYPOINT ["python3", "dockerentry.py"]