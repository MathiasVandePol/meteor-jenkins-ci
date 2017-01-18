#Create a jenkins image with android from one with nodejs npm and meteor available
FROM codetroopers/jenkins-slave-jdk8-android:23-23.0.2
MAINTAINER Mathias Van de Pol

#install and update
RUN apt-get update -qq && apt-get install -qqy \
    curl \
    build-essential \
    
#install meteor
RUN curl https://install.meteor.com/ | sh && export PATH=$PATH:$HOME/.meteor

#install android platform
RUN echo y | android update sdk --no-ui --all --filter platform-tools,build-tools-23.0.2,build-tools-23.0.3,android-23

#install node 4
RUN curl -sL https://deb.nodesource.com/setup_4.x | bash && apt-get install -y nodejs
