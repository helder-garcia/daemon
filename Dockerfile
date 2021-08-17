FROM ubuntu:20.04

ARG VERSION=develop
ARG DEBIAN_FRONTEND=noninteractive
ENV VERSION=${VERSION}
ENV TZ=Europe/Moscow
ENV TINI_VERSION v0.19.0

LABEL Name=node Version=0.0.1
LABEL maintainer="Helder Garcia <helder.garcia@gmail.com>"
LABEL source="https://github.com/quan-projects/quan-node"
LABEL version="${VERSION}"

ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini-static /tini-static

COPY ./docker-entrypoint.sh /usr/bin

RUN apt-get update \
&& apt-get -y install apt-utils net-tools dnsutils iputils-ping vim git build-essential cmake libboost-all-dev gcc-9 g++-9 python3-pip
RUN mkdir /quan \
&& git config --global http.sslverify false \
&& git clone --branch ${VERSION} --single-branch https://github.com/quan-projects/quan-node.git ${HOME}/daemon \
&& mkdir ${HOME}/daemon/build \
&& cd ${HOME}/daemon/build \
&& cmake .. \
&& make -j2 \
&& apt-get -y purge git build-essential cmake \
&& apt-get -y autoremove --purge \
&& cp src/q1v-node /usr/bin/. \
&& rm -fR ${HOME}/daemon \
&& chmod +x /tini-static \
&& chmod +x /usr/bin/docker-entrypoint.sh \
&& ln -s /usr/bin/docker-entrypoint.sh /docker-entrypoint.sh

WORKDIR /

ENTRYPOINT ["/tini-static", "--"]

CMD ["docker-entrypoint.sh"]

