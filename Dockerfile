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
RUN wget https://storage.googleapis.com/golang/go1.8.3.linux-amd64.tar.gz &&\
    tar -C /usr/local -xzf go* && rm -f go*

ENV GOPATH /home/user/go
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH

#Install node.js
RUN curl -sL https://deb.nodesource.com/setup_6.x | bash - &&\
    apt-get install -y nodejs

#Install hugo
RUN wget https://github.com/spf13/hugo/releases/download/v0.21/hugo_0.21_Linux-64bit.deb &&\
    dpkg -i hugo_0.21_Linux-64bit.deb && rm -f /hugo_0.21_Linux-64bit.deb 

#Install Travis CLI
RUN apt-get install -y ruby ruby-dev && \
    gem install travis -v 1.8.8 --no-rdoc --no-ri
