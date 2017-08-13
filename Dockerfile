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
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash - &&\
    apt-get install -y nodejs
RUN npm install -g eslint babel-eslint

#Install ionic
RUN npm install -g cordova ionic

#Install hugo
RUN wget https://github.com/spf13/hugo/releases/download/v0.21/hugo_0.21_Linux-64bit.deb &&\
    dpkg -i hugo_0.21_Linux-64bit.deb && rm -f /hugo_0.21_Linux-64bit.deb 

#Install Travis CLI
RUN apt-get install -y ruby ruby-dev && \
    gem install travis -v 1.8.8 --no-rdoc --no-ri

#Install PHP
#RUN apt-get -y install php7.0 php-7.0-curl php-7.0-mbstring
#RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" &&\
#    php -r "if (hash_file('SHA384', 'composer-setup.php') === '669656bab3166a7aff8a7506b8cb2d1c292f042046c5a994c43155c0be6190fa0355160742ab2e1c88d40d5be660b410') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"  &&\
#    php composer-setup.  &&\
#    php -r "unlink('composer-setup.php');"  &&\
#    mv composer.phar /usr/local/bin/composer

#Install httpie
RUN apt-get -y install httpie

#Install gcloud
RUN echo "deb http://packages.cloud.google.com/apt cloud-sdk-$(lsb_release -c -s) main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list &&\
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - &&\
    apt-get update && apt-get install -y google-cloud-sdk google-cloud-sdk-app-engine-go

#Install Docker, what??? Why are you looking that way at me?
RUN curl https://get.docker.com | bash

#Install Dep
RUN go get -u github.com/golang/dep/cmd/dep

#Install Heroku
RUN add-apt-repository -y "deb https://cli-assets.heroku.com/branches/stable/apt ./" &&\
    curl -L https://cli-assets.heroku.com/apt/release.key | sudo apt-key add - &&\
    apt-get update && apt-get install -y heroku 
