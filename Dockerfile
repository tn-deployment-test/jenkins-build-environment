FROM ubuntu:18.04

RUN apt-get -qy update \
    && apt-get -qy dist-upgrade \
    && apt-get -qy install \
        curl \
        gnupg2 \
        lsb-release

# Install kubectl
RUN export CLOUD_SDK_REPO="cloud-sdk-$(lsb_release -c -s)" \
    && echo "deb http://packages.cloud.google.com/apt $CLOUD_SDK_REPO main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list \
    && curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - \
    && apt-get -yq update \
    && apt-get -yq install kubectl

RUN rm -rf /var/lib/apt/lists/*

