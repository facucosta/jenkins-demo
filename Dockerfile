FROM debian:buster

RUN useradd testuser -m

RUN apt-get update && \
    apt-get install -yqq --no-install-recommends npm nodejs redis-server nginx npm curl procps && \
    apt-get clean && \
    rm -r /var/lib/apt/lists/*

COPY env_config/nginx-redis-app-conf /etc/nginx/sites-available

ARG LISTEN_PORT=80
RUN ln -s /etc/nginx/sites-available/nginx-redis-app-conf /etc/nginx/sites-enabled && \
    rm /etc/nginx/sites-enabled/default && \
    sed -i "s|listen 80;|listen $LISTEN_PORT;|g" /etc/nginx/sites-available/nginx-redis-app-conf

EXPOSE $LISTEN_PORT

USER root
WORKDIR /home/testuser/redis-app
CMD service redis-server start && \
    nginx -g "daemon off;"
