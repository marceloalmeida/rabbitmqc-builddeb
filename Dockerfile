FROM debian:jessie-backports

MAINTAINER Marcelo Almeida <marcelo.almeida@jumia.com>

WORKDIR "/root"

ENV DEBIAN_FRONTEND noninteractive
ENV VERSION 0.7.1

# INSTALL BUILDER DEPENDENCIES
RUN apt-get update && apt-get install -y --no-install-recommends \
  apt-utils \
  build-essential \
  ca-certificates \
  checkinstall \
  lsb-release \
  libc6-dev \
  libssl-dev \
  make \
  pkg-config \
  wget

COPY src /src

# CREATE PACKAGE
RUN wget https://github.com/alanxz/rabbitmq-c/releases/download/v$VERSION/rabbitmq-c-$VERSION.tar.gz ;\
  tar -zxvf rabbitmq-c-$VERSION.tar.gz ;\
  cd rabbitmq-c-$VERSION ;\
  cp -r /src/* /root/rabbitmq-c-$VERSION/. ;\
  ./configure --prefix=/usr ;\
  checkinstall --install=no --pkgname='librabbitmq1' --pkgversion='$VERSION-aig' --pkggroup='libs' --pkgsource='https://github.com/alanxz/rabbitmq-c' --maintainer='Marcelo Almeida \<marcelo.almeida@jumia.com\>' --requires='libc6 \(\>= 2.14\), libssl1.0.0 \(\>= 1.0.0\)' --strip=no --stripso=no --addso=yes

VOLUME ["/pkg"]
