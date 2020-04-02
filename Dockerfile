FROM circleci/node:10

#RUN useradd -m circleci
USER circleci

RUN sudo apt-get update && sudo apt-get install raptor2-utils dos2unix vim emacs

WORKDIR /app
ADD . /app

RUN sudo npm set unsafe-perm true
RUN sudo npm install
RUN sudo npm install jsonld

RUN mkdir ~/.npm-global && \
    npm config set prefix '~/.npm-global'  && \
    export PATH=~/.npm-global/bin:$PATH  && \ 
    echo $PATH  && \
    npm install -g https://github.com/bertvannuffelen/jsonld-cli && \
    npm install -g https://github.com/semanticarts/shacl-validator

ENV PATH="~/.npm-global/bin:${PATH}"
