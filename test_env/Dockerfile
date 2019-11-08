FROM debian:buster

RUN apt-get update && \
    apt-get install -yqq --no-install-recommends npm nodejs redis-server nginx curl procps && \
    apt-get clean && \
    rm -r /var/lib/apt/lists/*

COPY nginx-redis-app-conf /etc/nginx/sites-available

ARG LISTEN_PORT=80
RUN ln -s /etc/nginx/sites-available/nginx-redis-app-conf /etc/nginx/sites-enabled && \
    rm /etc/nginx/sites-enabled/default && \
    sed -i "s|listen 80;|listen $LISTEN_PORT;|g" /etc/nginx/sites-available/nginx-redis-app-conf

EXPOSE $LISTEN_PORT
EXPOSE 80
EXPOSE 81
EXPOSE 8080
EXPOSE 8081

CMD service redis-server start && \
    nginx -g "daemon off;"
