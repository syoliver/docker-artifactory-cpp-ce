FROM ubuntu:18.10

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update
RUN apt-get install --yes \
    wget \
    openjdk-8-jre \
    net-tools \
    unzip \
  && rm --recursive --force /var/lib/apt/lists/*

ENV VERSION=6.8.7
ENV ARTIFACTORY_HOME=/opt/artifactory-pro-current

RUN wget --quiet -O /tmp/jfrog-artifactory-cpp-ce-${VERSION}.zip "https://bintray.com/jfrog/artifactory/download_file?file_path=jfrog-artifactory-cpp-ce-${VERSION}.zip"
RUN unzip /tmp/jfrog-artifactory-cpp-ce-${VERSION}.zip -d /opt && \
    ln -s /opt/artifactory-cpp-ce-${VERSION} ${ARTIFACTORY_HOME} && \
    rm /tmp/jfrog-artifactory-cpp-ce-${VERSION}.zip
RUN mv "${ARTIFACTORY_HOME}/etc" "${ARTIFACTORY_HOME}/etc.defaults"

VOLUME ${ARTIFACTORY_HOME}/etc
VOLUME ${ARTIFACTORY_HOME}/data
VOLUME ${ARTIFACTORY_HOME}/logs
VOLUME ${ARTIFACTORY_HOME}/backup

EXPOSE 8040

COPY start.sh /start.sh
RUN chmod +x /start.sh
ENTRYPOINT ["/start.sh"]
