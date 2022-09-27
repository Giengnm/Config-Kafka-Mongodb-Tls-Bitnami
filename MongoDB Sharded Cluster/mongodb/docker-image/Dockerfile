FROM bitnami/mongodb-sharded:6.0.1-debian-11-r8

USER root

COPY ./entrypoint.sh /entrypoint.sh
COPY ./mongodb.conf /opt/bitnami/mongodb/conf/mongodb.conf
COPY ./mongos.conf /opt/bitnami/mongodb/conf/mongos.conf
COPY ./cert_setup.sh /cert_setup.sh

RUN chmod 777 /entrypoint.sh /opt/bitnami/mongodb/conf/mongodb.conf /opt/bitnami/mongodb/conf/mongos.conf /cert_setup.sh