# Images
FROM --platform=${TARGETPLATFORM:-linux/amd64} ghcr.io/openfaas/of-watchdog:0.9.3 as watchdog
FROM --platform=${TARGETPLATFORM:-linux/amd64} composer:latest AS composer

# Arguments
ARG TARGETPLATFORM
ARG BUILDPLATFORM

# Composer install
ARG COMPOSER_AUTH='{}'
ENV COMPOSER_AUTH=${COMPOSER_AUTH}
COPY ./function/composer.* /app/
RUN echo ${COMPOSER_AUTH} > /tmp/auth.json
RUN [[ -f composer.lock || composer.json ]] && \
    composer install --no-dev --no-cache --no-progress --optimize-autoloader --no-interaction

# Base off from alpine
FROM --platform=${TARGETPLATFORM:-linux/amd64} alpine:latest

# Install PHP8
RUN \
    apk --no-cache add php8 && \
    ln -s /usr/bin/php8 /usr/bin/php

# Copy binaries
COPY --from=watchdog /fwatchdog /usr/bin/fwatchdog

# Creates app user
RUN \
    mkdir -p /app && \
    chmod 777 /tmp && \
    chmod +x /usr/bin/fwatchdog && \
    addgroup -S app && adduser -S -g app app && \
    chown -R app:app /app

# Run the install
WORKDIR /app/function
COPY ./function/install.sh /app/function/
RUN ([[ -f install.sh ]] && sh ./install.sh && rm ./install.sh)

# Import
COPY ./index.php /app/
COPY ./function/src /app/function/src
COPY --from=composer /app/vendor /app/function/vendor

# Entry
WORKDIR /app
USER app

ENV fprocess="php index.php"
ENV mode="http"
ENV upstream_url="http://127.0.0.1:3000"

ENV exec_timeout="10s"
ENV write_timeout="15s"
ENV read_timeout="15s"

ENV prefix_logs="false"

HEALTHCHECK --interval=3s CMD [ -e /tmp/.lock ] || exit 1

CMD ["fwatchdog"]

