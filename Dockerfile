FROM tutum/curl:trusty
MAINTAINER FENG, HONGLIN <hfeng@tutum.co>

RUN apt-get update -q && apt-get install software-properties-common -y && add-apt-repository ppa:couchdb/stable -y

#install CouchDB
RUN apt-get update && \
    apt-get install -y couchdb pwgen logrotate supervisor && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir /var/run/couchdb

# download and install binaries
ADD ./install_nginx_binaries.sh /src/install_nginx_binaries.sh
RUN /src/install_nginx_binaries.sh

# configure
ADD ./config/nginx /src/etc/nginx
ADD ./setup_nginx_proxy.sh /src/setup_nginx_proxy.sh
RUN /src/setup_nginx_proxy.sh
RUN rm -r /src/etc/nginx
RUN rm /src/setup_nginx_proxy.sh

ADD ./config/couchdb /src/etc/couchdb
RUN cp /src/etc/couchdb/local.ini /etc/couchdb

RUN rm -rf /etc/supervisor
ADD ./config/supervisor /etc/supervisor

VOLUME ["/var/lib/couchdb", "/secret"]

EXPOSE 80
CMD ["/usr/bin/supervisord"]
