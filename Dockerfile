#Create a jenkins image with android from one with nodejs npm and meteor available
FROM codetroopers/jenkins-slave-jdk8-android
MAINTAINER Mathias Van de Pol

#install and update
RUN apt-get update -qq && apt-get install -qqy \
    apt-transport-https \
    ca-certificates \
    curl \
    lxc \
    iptables \
    zip \
    python \
    python-pip \
    openjdk-9-jre-headless \
    build-essential \
    && rm -rf /var/lib/apt/lists/* \
    && pip install --upgrade pip \
    && pip install awscli  

# install docker
RUN curl -sSL https://get.docker.com/ | sh
# Install the magic wrapper.
ADD ./wrapdocker /usr/local/bin/wrapdocker
RUN chmod +x /usr/local/bin/wrapdocker

# Define additional metadata for our image.
VOLUME /var/lib/docker
CMD ["wrapdocker"]


ENV JENKINS_REMOTING_VERSION 2.9
ENV DOCKER_COMPOSE_VERSION 1.8.1
ENV KUBERNETES_CTL_VERSION v1.4.0
ENV HOME /home/jenkins

RUN curl --create-dirs -sSLo /usr/share/jenkins/remoting-$JENKINS_REMOTING_VERSION.jar http://repo.jenkins-ci.org/public/org/jenkins-ci/main/remoting/$JENKINS_REMOTING_VERSION/remoting-$JENKINS_REMOTING_VERSION.jar \
    && curl -L https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose \
    && curl -L https://storage.googleapis.com/kubernetes-release/release/${KUBERNETES_CTL_VERSION}/bin/linux/amd64/kubectl > /usr/local/bin/kubectl \
    && chmod +x /usr/local/bin/docker-compose \
    && chmod +x /usr/local/bin/kubectl \
    && chmod 755 /usr/share/jenkins

ADD jenkins-slave /usr/local/bin/jenkins-slave

VOLUME /home/jenkins

ENTRYPOINT ["/usr/local/bin/jenkins-slave"]

#install meteor
RUN curl https://install.meteor.com/ | sh && export PATH=$PATH:$HOME/.meteor

#install android platform
RUN echo y | android update sdk --no-ui --all --filter platform-tools,build-tools-23.0.2,build-tools-23.0.3,android-23

#install node 4
RUN curl -sL https://deb.nodesource.com/setup_4.x | bash && apt-get install -y nodejs
