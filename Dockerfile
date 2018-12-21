FROM meyskens/desktop-base:gtkdev

RUN apt-get update && apt-get install -y \
        curl \
	apt-transport-https \
	gpg \
	git \
    	sudo \
	direnv \
	jq \
	xxd \
	shellcheck

RUN curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg &&\
    mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg &&\
    echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list

RUN apt-get update && apt-get install -y code

# Install GUI dev
RUN apt-get install -y pkg-config libwebkit2gtk-4.0-dev libgtk-3-dev

#Add some personal stuff
RUN apt-get install -y build-essential unison nano
ENV EDITOR=nano

# Add the fish shell
RUN apt-get install -y fish
RUN usermod -s /usr/bin/fish user

#Install golang
RUN apt-get update && apt-get install -y wget tar git
RUN wget -O -  "https://golang.org/dl/go1.11.linux-amd64.tar.gz" | tar xzC /usr/local
RUN cp /usr/local/go/bin/* /usr/local/bin

ENV GOPATH /home/user/go
ENV GOROOT /usr/local/go
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH
ENV arduinoversion=1.8.5

#Install node.js
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash - &&\
    apt-get install -y nodejs
RUN sudo npm install -g eslint babel-eslint http-server babel-cli webpack nodemon yarn

#Install ionic
RUN npm install -g cordova ionic

#Install hugo
RUN wget https://github.com/gohugoio/hugo/releases/download/v0.51/hugo_0.51_Linux-64bit.deb &&\
    dpkg -i hugo_0.51_Linux-64bit.deb  && rm -f /hugo_0.51_Linux-64bit.deb 

#Install Travis CLI
RUN apt-get install -y ruby ruby-dev && \
    gem install travis -v 1.8.8 --no-rdoc --no-ri

#Install PHP
RUN apt-get -y install php7.0 php7.0-curl php7.0-mbstring

#Install httpie
RUN apt-get -y install httpie

#Install gcloud
RUN echo "deb http://packages.cloud.google.com/apt cloud-sdk-$(lsb_release -c -s) main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list &&\
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - &&\
    apt-get update && apt-get install -y google-cloud-sdk google-cloud-sdk-app-engine-go
RUN ln -s /usr/bin/gcloud /usr/local/bin/gcloud

#Install Docker, what??? Why are you looking that way at me?
RUN curl https://get.docker.com | bash
RUN apt-get -y install docker-compose

#Install Dep
RUN go get -u github.com/golang/dep/cmd/dep

#Install Heroku
RUN apt-get install -y software-properties-common && add-apt-repository -y "deb https://cli-assets.heroku.com/branches/stable/apt ./" &&\
    curl -L https://cli-assets.heroku.com/apt/release.key | sudo apt-key add - &&\
    apt-get update && apt-get install -y heroku 


# Install arduino cli
RUN wget -O arduino.tar.xz https://downloads.arduino.cc/arduino-${arduinoversion}-linux64.tar.xz && tar -xJf arduino.tar.xz && rm -f arduino.tar.xz

RUN mv arduino-${arduinoversion} /usr/local/share/arduino/ && /usr/local/share/arduino/install.sh && ln -s /usr/local/share/arduino/arduino /usr/local/bin/arduino 

# Install Kubernetes
RUN curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - && \
    echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" >/etc/apt/sources.list.d/kubernetes.list && \
    apt-get update && \
    apt-get install -y kubectl

# Install Helm
RUN wget https://storage.googleapis.com/kubernetes-helm/helm-v2.9.1-linux-amd64.tar.gz && \
    tar xzf helm-v2.9.1-linux-amd64.tar.gz && \
    mv linux-amd64/helm /usr/local/bin/ && \
    rm -f helm-v2.9.1-linux-amd64.tar.gz &&\
    rm -fr linux-amd64
    
# Install etcd
RUN wget https://github.com/etcd-io/etcd/releases/download/v3.3.8/etcd-v3.3.8-linux-amd64.tar.gz && \
    tar xzf etcd-v3.3.8-linux-amd64.tar.gz && \
    mv etcd-v3.3.8-linux-amd64/etcdctl /usr/local/bin/ && \
    mv etcd-v3.3.8-linux-amd64/etcd /usr/local/bin/ && \
    rm -f etcd-v3.3.8-linux-amd64.tar.gz &&\
    rm -fr etcd-v3.3.8-linux-amd64
    
# Install ffmpeg

RUN apt-get install -y ffmpeg

# Install terraform

RUN wget https://releases.hashicorp.com/terraform/0.11.11/terraform_0.11.11_linux_amd64.zip &&\
    unzip terraform_0.11.11_linux_amd64.zip &&\
    mv terraform /usr/local/bin/ &&\
    rm terraform_0.11.11_linux_amd64.zip
    
# Install ansible
RUN echo "deb http://ppa.launchpad.net/ansible/ansible/ubuntu trusty main">>/etc/apt/sources.list
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 93C4A3FD7BB9C367 &&\
    apt-get update && apt-get install -y ansible

# Install pip
RUN apt-get install -y python-pip

# Add user to docker

RUN usermod -aG docker user

CMD sudo -u user code --verbose
