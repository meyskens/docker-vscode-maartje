FROM meyskens/vscode:latest

#Add some personal stuff

RUN apt-get install -y build-essential

# Add the fish shell
RUN apt-get install -y wget
RUN wget -nv http://download.opensuse.org/repositories/shells:fish:release:2/Debian_8.0/Release.key -O Release.key &&\
    apt-key add - < Release.key &&\
    apt-get update &&\
    apt-get install -y fish &&\
    chsh -s /usr/bin/fish user 

#Install golang
RUN echo "deb http://ppa.launchpad.net/longsleep/golang-backports/ubuntu xenial main" >>/etc/apt/sources.list && \
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 52B59B1571A79DBC054901C0F6BC817356A3D45E  && \
    apt-get update && apt-get install -y golang-1.8 && \
    ln -s /usr/lib/go-1.8/bin/* /usr/bin/

ENV GOPATH /home/user/go
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH

#Install node.js
RUN curl -sL https://deb.nodesource.com/setup_6.x | bash - &&\
    apt-get install -y nodejs
RUN npm install -g eslint

#Install hugo
RUN wget https://github.com/spf13/hugo/releases/download/v0.21/hugo_0.21_Linux-64bit.deb &&\
    dpkg -i hugo_0.21_Linux-64bit.deb && rm -f /hugo_0.21_Linux-64bit.deb 

#Install Travis CLI
RUN apt-get install -y ruby ruby-dev && \
    gem install travis -v 1.8.8 --no-rdoc --no-ri
