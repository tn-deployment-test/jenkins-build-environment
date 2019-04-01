FROM ubuntu:18.04

RUN apt-get -qy update \
    && apt-get -qy dist-upgrade \
    && apt-get -qy install \
        build-essential \
        curl \
        git \
        gnupg2 \
        lsb-release \
        make

# Install kubectl
RUN export CLOUD_SDK_REPO="cloud-sdk-$(lsb_release -c -s)" \
    && echo "deb http://packages.cloud.google.com/apt $CLOUD_SDK_REPO main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list \
    && curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - \
    && apt-get -qy update \
    && apt-get -qy install kubectl

ARG GO_ARCHIVE_NAME=go1.12.1.linux-amd64.tar.gz
ARG GO_SHA256=2a3fdabf665496a0db5f41ec6af7a9b15a49fbe71a85a50ca38b1f13a103aeec

# Install golang
RUN curl -o $GO_ARCHIVE_NAME https://dl.google.com/go/$GO_ARCHIVE_NAME \
    && echo "$GO_SHA256 *$GO_ARCHIVE_NAME" > SHA256SUMS \
    && sha256sum -c SHA256SUMS \
    && rm SHA256SUMS \
    && tar -C /usr/local -xf $GO_ARCHIVE_NAME \
    && rm $GO_ARCHIVE_NAME

ENV PATH /usr/local/go/bin:$PATH

# install dep
RUN export GOPATH=/usr/local/go \
    && curl https://raw.githubusercontent.com/golang/dep/master/install.sh | sh

# for go test's cache
RUN mkdir -m 777 /.cache

RUN rm -rf /var/lib/apt/lists/*

