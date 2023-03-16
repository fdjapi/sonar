FROM fresh as build 
ARG ALPINE_VERSION
ARG JAVA_VERSION  
ARG SONARQUBE_VERSION
LABEL org.opencontainers.images.authors="fdjapi@gmail.com"
LABEL ALPINE_VERSION=${ALPINE_VERSION}
LABEL JAVA_VERSION=${JAVA_VERSION}
LABEL SONARQUBE_VERSION=${SONARQUBE_VERSION}
RUN echo "http://dl-cdn.alpinelinux.org/alpine/v${ALPINE_VERSION}/main > /etc/apk/repositories"
RUN echo "http://dl-cdn.alpinelinux.org/alpine/v${ALPINE_VERSION}/community >> /etc/apk/repositories"
RUN apk update
RUN apk add openjdk${JAVA_VERSION}
ADD https://binaries.sonarsource.com/commercialDistribution/sonarqube-enterprise-${SONARQUBE_VERSION}.zip  /opt/sonarqube-enterprise-${SONARQUBE_VERSION}.zip
RUN apk add unzip
RUN unzip /opt/sonarqube-enterprise-${SONARQUBE_VERSION}.zip -d /opt/
RUN apk del unzip
RUN rm -f /opt/sonarqube-enterprise-${SONARQUBE_VERSION}
FROM build
ENV SONARQUBE_HOME=/opt/sonarqube-${SONARQUBE_VERSION}
ADD sonar.properties  ${SONARQUBE_HOME}/conf/sonar.properties
ENV SONAR_HOST_URL=
ENV SONAR_JDBC_URL=
ENV SONAR_JDBC_USERNAME=
ENV SONAR_JDBC_PASSWORD=
ENV SONAR_SECURITY_REALM=
ENV SONAR_SECURITY_SAVEPASSWORD=
ENV SONAR_TYPESCRIPT_LCOV_REPORTPATHS=
ENTRYPOINT ["${SONARQUBE_HOME}/bin/linux-x86-64/sonar.sh", "start"]
