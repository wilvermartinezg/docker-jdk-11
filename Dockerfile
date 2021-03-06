FROM ubuntu:18.04

ADD files/apache-maven-3.6.0-bin.tar.gz /opt/maven
ADD files/jdk-11.0.1_linux-x64_bin.tar.gz /opt/java
ADD files/javafx-sdk-11.0.2.tar.gz /opt/javafx

ENV JDK_VERSION="jdk-11.0.1"
ENV MAVEN_VERSION="apache-maven-3.6.0"
ENV JAVA_FX_VERSION="javafx-sdk-11.0.2"
ENV JAVA_HOME="/opt/java/${JDK_VERSION}" \
    MAVEN_HOME="/opt/maven/${MAVEN_VERSION}" \
    JAVA_FX_HOME="/opt/javafx/${JAVA_FX_VERSION}" \
    HOME="/home/developer" \
    PATH="${PATH}:/home/developer:/opt/java/${JDK_VERSION}/bin:/opt/maven/${MAVEN_VERSION}/bin:/opt/javafx/${JAVA_FX_VERSION}/lib"

RUN apt-get update \
    && apt install -y curl wget \
    && apt-get install -y sudo software-properties-common \
    && apt-get install -y git \
    && apt-get install -y nano

RUN echo 'Creating user: developer' \
    && mkdir -p /home/developer \
    && echo "developer:x:1000:1000:Developer,,,:/home/developer:/bin/bash" >> /etc/passwd \
    && echo "developer:x:1000:" >> /etc/group \
    && sudo echo "developer ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/developer \
    && sudo chmod 0440 /etc/sudoers.d/developer \
    && sudo chown developer:developer -R /home/developer \
	&& sudo chown root:root /usr/bin/sudo \
	&& chmod 4755 /usr/bin/sudo

RUN sudo chown developer:developer -R /home/developer

RUN sudo update-alternatives --install "/usr/bin/java" "java" "/opt/java/$JDK_VERSION/bin/java" 1 \
	&& sudo update-alternatives --install "/usr/bin/javac" "javac" "/opt/java/$JDK_VERSION/bin/javac" 1 \
	&& sudo update-alternatives --set java /opt/java/$JDK_VERSION/bin/java

#&& sudo update-alternatives --install "/usr/bin/javaws" "javaws" "/opt/java/$JDK_VERSION/bin/javaws" 1 \

USER developer
WORKDIR /home/developer

