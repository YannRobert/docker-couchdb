FROM tutum/curl:trusty
MAINTAINER FENG, HONGLIN <hfeng@tutum.co>

RUN apt-get update -q && apt-get install software-properties-common -y && add-apt-repository ppa:couchdb/stable -y

#install CouchDB
RUN apt-get update && \
    apt-get install -y couchdb pwgen && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir /var/run/couchdb
RUN sed -i -r 's/;bind_address = 127.0.0.1/bind_address = 0.0.0.0/' /etc/couchdb/local.ini

ADD create_couchdb_admin_user.sh /create_couchdb_admin_user.sh
ADD run.sh /run.sh
RUN chmod 755 /*.sh

VOLUME ["/var/lib/couchdb"]

EXPOSE 5984
CMD ["/run.sh"]
