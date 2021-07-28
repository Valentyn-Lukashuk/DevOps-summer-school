FROM debian
RUN apt update
RUN apt install apache2 -yqq
COPY index.html /var/www/html
CMD apachectl -D FOREGROUND
