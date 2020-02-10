#!/bin/bash

openssl genrsa -out server.pass.key 2048
openssl rsa -in server.pass.key -out server.key
rm server.pass.key
openssl req -new -key server.key -out server.csr \
    -subj "/C=FI/ST=FI/L=FI/O=OrgName/OU=IT Department/CN=hawkbit"
openssl x509 -req -days 365 -in server.csr -signkey server.key -out server.crt
openssl pkcs12 -export -in server.crt -inkey server.key \
               -out hawkbit.p12 -name hawkbit \
               -CAfile cafile.crt -caname root
keytool -importkeystore \
        -deststorepass password -destkeypass password -destkeystore hawkbit.keystore \
        -srckeystore hawkbit.p12 -srcstoretype PKCS12 -srcstorepass password \
        -alias hawkbit 
        
