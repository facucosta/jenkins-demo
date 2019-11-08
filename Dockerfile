FROM debian:buster

RUN useradd testuser -m

RUN apt-get update && \
    apt-get install -yqq --no-install-recommends npm nodejs redis-server nginx curl && \
    apt-get clean && \
    rm -r /var/lib/apt/lists/*

USER testuser
RUN mkdir /home/testuser/redis-app

USER root
WORKDIR /home/testuser/redis-app
RUN apt-get update && \
    apt-get install -yqq --no-install-recommends npm && \
    su testuser -c "npm install express body-parser redis" && \
    apt-get purge -yqq npm && \
    apt-get autoremove -yqq && \
    apt-get clean && \
    rm -r /var/lib/apt/lists/*

USER root
COPY env_config/nginx-redis-app-conf /etc/nginx/sites-available

ARG LISTEN_PORT=80
RUN ln -s /etc/nginx/sites-available/nginx-redis-app-conf /etc/nginx/sites-enabled && \
    rm /etc/nginx/sites-enabled/default && \
    sed -i "s|listen 80;|listen $LISTEN_PORT;|g" /etc/nginx/sites-available/nginx-redis-app-conf

COPY --chown=testuser:testuser application/index.js /home/testuser/redis-app/index.js

EXPOSE $LISTEN_PORT

USER root
WORKDIR /home/testuser/redis-app
CMD service nginx start && \
    service redis-server start && \
    su testuser -c "nodejs ./index.js"
