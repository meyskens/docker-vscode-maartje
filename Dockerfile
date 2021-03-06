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
	shellcheck \
	yamllint \
	sshuttle \
	mercurial \
	lsb-release

RUN curl https://bazel.build/bazel-release.pub.gpg | apt-key add - &&\
    echo "deb [arch=amd64] https://storage.googleapis.com/bazel-apt stable jdk1.8" | tee /etc/apt/sources.list.d/bazel.list

RUN apt-get update && apt-get install -y bazel

RUN curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg &&\
    mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg &&\
    echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list

RUN apt-get update && apt-get install -y code

# Install GUI dev
RUN apt-get install -y pkg-config libwebkit2gtk-4.0-dev libgtk-3-dev

# Install sound dev
RUN apt-get install -y libasound2-dev libwebkit2gtk-4.0-dev

#Add some personal stuff
RUN apt-get install -y build-essential unison nano
ENV EDITOR=nano


# Install upstream Git
RUN apt install -y make libssl-dev libghc-zlib-dev libcurl4-gnutls-dev libexpat1-dev gettext unzip
RUN git clone https://github.com/git/git.git -b v2.31.1 &&\
    cd git &&\
    make prefix=/usr/local all &&\
    sudo make prefix=/usr/local install &&\
    cd .. && rm -fr git


# Add the fish shell
RUN apt-get install -y fish
RUN usermod -s /usr/bin/fish user

#Install golang
RUN apt-get update && apt-get install -y wget tar git
RUN wget -O -  "https://golang.org/dl/go1.16.linux-amd64.tar.gz" | tar xzC /usr/local
RUN cp /usr/local/go/bin/* /usr/local/bin

ENV GOPATH /home/user/go
ENV GOROOT /usr/local/go
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH
ENV arduinoversion=1.8.5

#Install node.js
RUN curl -sL https://deb.nodesource.com/setup_15.x | bash - &&\
    apt-get install -y nodejs
RUN sudo npm install -g eslint babel-eslint http-server babel-cli webpack nodemon yarn

#Install ionic
RUN npm install -g cordova ionic

#Install vue
RUN npm install -g @vue/cli

#Install twilio
RUN npm install -g twilio-cli

#Install ZOHO Widget SDK
RUN npm install -g zoho-extension-toolkit
#Install hugo
RUN wget https://github.com/gohugoio/hugo/releases/download/v0.51/hugo_0.51_Linux-64bit.deb &&\
    dpkg -i hugo_0.51_Linux-64bit.deb  && rm -f /hugo_0.51_Linux-64bit.deb 

# Install GitHub CLI
RUN wget https://github.com/cli/cli/releases/download/v1.2.1/gh_1.2.1_linux_amd64.deb &&\
    dpkg -i gh_1.2.1_linux_amd64.deb && rm -f gh_1.2.1_linux_amd64.deb 


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

# Install OpenShift
RUN wget https://github.com/openshift/origin/releases/download/v3.11.0/openshift-origin-client-tools-v3.11.0-0cbc58b-linux-64bit.tar.gz && \
    tar xzf openshift-origin-client-tools-v3.11.0-0cbc58b-linux-64bit.tar.gz && \
    mv openshift-origin-client-tools-v3.11.0-0cbc58b-linux-64bit/oc /usr/local/bin/ && \
    rm -f openshift-origin-client-tools-v3.11.0-0cbc58b-linux-64bit.tar.gz &&\
    rm -fr openshift-origin-client-tools-v3.11.0-0cbc58b-linux-64bit

# Install Helm3
RUN wget https://get.helm.sh/helm-v3.0.2-linux-amd64.tar.gz && \
    tar xzf helm-v3.0.2-linux-amd64.tar.gz && \
    mv linux-amd64/helm /usr/local/bin/helm && \
    rm -f helm-v3.0.2-linux-amd64.tar.gz&&\
    rm -fr linux-amd64

ENV CT_VERSION=2.3.3
RUN mkdir /ct && cd /ct && \ 
    curl -Lo chart-testing_${CT_VERSION}_linux_amd64.tar.gz https://github.com/helm/chart-testing/releases/download/v${CT_VERSION}/chart-testing_${CT_VERSION}_linux_amd64.tar.gz  && \
    tar xzf chart-testing_${CT_VERSION}_linux_amd64.tar.gz  && \
    chmod +x ct && sudo mv ct /usr/local/bin/  && \
    mv etc /etc/ct && \
    cd / && rm -fr /ct

# Install kind
RUN curl -Lo ./kind https://github.com/kubernetes-sigs/kind/releases/download/v0.7.0/kind-linux-amd64 && \ 
    chmod +x ./kind && \
    mv ./kind /usr/bin/kind

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
    
RUN wget https://releases.hashicorp.com/terraform/0.14.7/terraform_0.14.7_linux_amd64.zip &&\
    unzip terraform_0.14.7_linux_amd64.zip &&\
    mv terraform /usr/local/bin/tf014 &&\
    rm terraform_0.14.7_linux_amd64.zip
    
RUN wget https://releases.hashicorp.com/terraform/0.13.6/terraform_0.13.6_linux_amd64.zip &&\
    unzip terraform_0.13.6_linux_amd64.zip &&\
    mv terraform /usr/local/bin/terraform &&\
    rm terraform_0.13.6_linux_amd64.zip
    
# Install packer
RUN wget https://releases.hashicorp.com/packer/1.4.3/packer_1.4.3_linux_amd64.zip &&\
    unzip packer_1.4.3_linux_amd64.zip &&\
    mv packer /usr/local/bin/ &&\
    rm packer_1.4.3_linux_amd64.zip

# Install pip
RUN apt-get install -y python-pip  python3-pip
 
# Install ansible
RUN pip3 install ansible==2.7

# Install AWS CLI
RUN pip3 install awscli

# Install protoc
RUN PROTOC_ZIP=protoc-3.6.1-linux-x86_64.zip &&\
    curl -OL https://github.com/google/protobuf/releases/download/v3.6.1/$PROTOC_ZIP  &&\
    unzip -o $PROTOC_ZIP -d /usr/local bin/protoc  &&\
    rm -f $PROTOC_ZIP
    
RUN wget https://github.com/prometheus/prometheus/releases/download/v2.11.1/prometheus-2.11.1.linux-amd64.tar.gz &&\
    tar xzf prometheus-2.11.1.linux-amd64.tar.gz &&\
    mv prometheus-2.11.1.linux-amd64/promtool /usr/local/bin/promtool &&\
    rm -fr prometheus-2.11.1.linux-amd64 &&\
    rm prometheus-2.11.1.linux-amd64.tar.gz
    
RUN wget https://github.com/github/hub/releases/download/v2.12.3/hub-linux-amd64-2.12.3.tgz &&\
    tar xzf hub-linux-amd64-2.12.3.tgz  &&\
    hub-linux-amd64-2.12.3/install &&\
    rm -fr hub-linux-amd64-2.12.3 &&\
    rm hub-linux-amd64-2.12.3.tgz 

# Install operator sdk
ENV OPRATOR_SDK_VERSION=v0.10.0
RUN curl -OJL https://github.com/operator-framework/operator-sdk/releases/download/${OPRATOR_SDK_VERSION}/operator-sdk-${OPRATOR_SDK_VERSION}-x86_64-linux-gnu
RUN chmod +x operator-sdk-${OPRATOR_SDK_VERSION}-x86_64-linux-gnu && sudo mkdir -p /usr/local/bin/ && sudo cp operator-sdk-${OPRATOR_SDK_VERSION}-x86_64-linux-gnu /usr/local/bin/operator-sdk && rm operator-sdk-${OPRATOR_SDK_VERSION}-x86_64-linux-gnu

# Install doctl
RUN wget https://github.com/digitalocean/doctl/releases/download/v1.31.2/doctl-1.31.2-linux-amd64.tar.gz &&\
    tar xzf doctl-1.31.2-linux-amd64.tar.gz  &&\
    mv doctl /usr/local/bin/  &&\
    chmod +x /usr/local/bin/doctl  &&\
    rm doctl-1.31.2-linux-amd64.tar.gz
    
# Install thomas-bot deps
RUN apt-get install -y libsox-dev libsdl2-dev portaudio19-dev libopusfile-dev libopus-dev

# Add cert-manager CLI
RUN curl -L -o kubectl-cert-manager.tar.gz https://github.com/jetstack/cert-manager/releases/download/v1.0.1/kubectl-cert_manager-linux-amd64.tar.gz &&\
    tar xzf kubectl-cert-manager.tar.gz &&\
    mv kubectl-cert_manager /usr/local/bin &&\
    rm -f kubectl-cert-manager.tar.gz

# Add Azure CLI
RUN curl -sL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | tee /etc/apt/trusted.gpg.d/microsoft.gpg > /dev/null
RUN echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/azure-cli.list
RUN apt-get update && apt-get install -y azure-cli

# Add golangci-lint
RUN curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s -- -b /usr/local/bin v1.38.0

# Add user to docker
RUN usermod -aG docker user

USER user

CMD user code --verbose
