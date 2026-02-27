FROM lcr.loongnix.cn/library/golang:1.26-alpine

RUN apk add \
    git \ 
    make \
    coreutils \
    bash

ENV PLUGINS_VERSION=''

CMD ["sh", "-c","/workspace/process_version.sh $PLUGINS_VERSION"]
