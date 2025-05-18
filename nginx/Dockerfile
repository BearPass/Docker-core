FROM nginx:alpine

RUN rm /etc/nginx/conf.d/default.conf

COPY init.sh /docker-entrypoint.d/
RUN chmod +x /docker-entrypoint.d/init.sh
