#!/bin/bash
#Creating the TLS Root CA ca.crt and ca.key
#umask 007
#my_hostname=$(hostname) && \
#openssl req -newkey rsa:2048 -new -x509 -days 365 -nodes -out /certificates/ca.crt -keyout /certificates/ca.key -subj "/C=US/O=U.S. Testing/OU=IT/CN=ROOTCA"

#ls -la /
#env 
cp /opt/bitnami/ca-certs/CA.crt /opt/bitnami/certs/CA.crt 


cp /opt/bitnami/ca-certs/CA.key /opt/bitnami/certs/CA.key 

my_hostname=$(hostname) 

my_ip=$(hostname -I) 

echo "*****************"
echo "My ip is: ${my_ip}"
echo "*****************"

cat >/opt/bitnami/certs/openssl.cnf <<EOL

[req]
req_extensions = v3_req
distinguished_name = req_distinguished_name
[req_distinguished_name]
[v3_req]
basicConstraints = CA:FALSE
keyUsage = nonRepudiation, digitalSignature, keyEncipherment 
subjectAltName = @alt_names
[alt_names]
DNS.1 = $HOSTNAME
DNS.2 = $my_hostname
DNS.3 = $MONGODB_ADVERTISED_HOSTNAME
DNS.4 = ${MONGODB_ADVERTISED_HOSTNAME}.mongodb-sharded-bme-headless.dclear-data-dev.svc.cluster.local
DNS.5 = ${MONGODB_SERVICE_NAME}.dclear-data-dev.svc.cluster.local
DNS.6 = localhost
IP.1 = $my_ip
EOL



my_hostname=$(hostname -f) 
export RANDFILE=/opt/bitnami/certs/.rnd && openssl genrsa -out /opt/bitnami/certs/mongo.key 2048


#Create the client/server cert
openssl req -new -key /opt/bitnami/certs/mongo.key -out /opt/bitnami/certs/mongo.csr -subj "/C=ES/O=BME/OU=IT/CN=$HOSTNAME" -config /opt/bitnami/certs/openssl.cnf

#Signing the server cert with the CA cert and key
openssl x509 -req -in /opt/bitnami/certs/mongo.csr -CA /opt/bitnami/certs/CA.crt -CAkey /opt/bitnami/certs/CA.key -CAcreateserial -out /opt/bitnami/certs/mongo.crt -days 3650 -extensions v3_req -extfile /opt/bitnami/certs/openssl.cnf


#rm /opt/bitnami/certs/mongo.csr

#Concatenate to a pem file for use as the client PEM file which can be used for both member and client authentication.
cat /opt/bitnami/certs/mongo.crt /opt/bitnami/certs/mongo.key > /opt/bitnami/certs/mongodb.pem


rm /opt/bitnami/certs/CA.crt /opt/bitnami/certs/CA.key