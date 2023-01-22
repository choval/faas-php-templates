# Images
FROM --platform=${TARGETPLATFORM:-linux/amd64} ghcr.io/openfaas/classic-watchdog:latest as watchdog
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
FROM --platform=${TARGETPLATFORM:-linux/amd64} alpine:3.16

# Install PHP8
RUN \
    apk --no-cache add php8 && \
    (ls /usr/bin/php || ln -s /usr/bin/php8 /usr/bin/php)

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
EXPOSE 8080
HEALTHCHECK --interval=3s CMD [ -e /tmp/.lock ] || exit 1
CMD ["fwatchdog"]

