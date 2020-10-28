# Copyright ETSI 2017
# See: https://forge.etsi.org/etsi-forge-copyright-statement.txt

FROM alpine:3.10.0

RUN env
RUN apk update
RUN apk add bash
RUN apk add nodejs
RUN apk add nodejs-npm
RUN apk add asciidoctor
RUN apk add openjdk8
RUN apk add ca-certificates wget && update-ca-certificates 
RUN apk add openssl
RUN gem install rdoc --pre || gem install rdoc --pre
RUN gem install asciidoctor-pdf-cjk
RUN wget https://forge.etsi.org/swagger2markup-cli-1.3.2.jar
RUN npm config set proxy $http_proxy
RUN npm install -g swagger-cli
RUN npm install -g json-refs
RUN npm install -g yamljs

ADD validate-in-docker.sh /validate-in-docker.sh
RUN chmod +x /validate-in-docker.sh

ADD swg2mrkup /bin/swg2mrkup
RUN chmod +x /bin/swg2mrkup

ADD oas2pdf /bin/oas2pdf
RUN chmod +x /bin/oas2pdf

ENTRYPOINT ["/validate-in-docker.sh"]

