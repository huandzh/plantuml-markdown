FROM python:3.7-alpine

# version is the same as plantuml.py
LABEL maintainer="DHuan <hd@iamhd.top>" \
      description="This image is mkdocs with plantuml support." \
      version="3.1.2" \
      index="official"

# package indexes

# use aliyun alpine mirrors:
# COPY repositories /etc/apk/repositories

# use aliyun pip mirrors:
# COPY pip.conf /etc/pip.conf

# Phrase 1 : Install plantuml

# add a small-size font, else plantuml will fail
RUN apk add --update openjdk8-jre-base openjdk8-jre ttf-droid graphviz

# busybox wget can't use `https` by itself, add `curl` instead
# RUN apk add curl \
#     && mkdir -p /opt \
#     && curl -L https://sourceforge.net/projects/plantuml/files/plantuml.jar \
#     -o /opt/plantuml.jar \
#     && apk del curl
COPY plantuml.jar /opt/plantuml.jar

# add plantuml executable
COPY plantuml /usr/local/bin/plantuml
RUN chmod +x /usr/local/bin/plantuml

# clean cache for a smaller image
RUN rm -rf /var/cache/apk/*

# Phrase 2 : Install mkdocs and plantuml-markdown extension

# install `mkdocs` and plantuml-markdown
RUN pip --no-cache-dir install mkdocs plantuml-markdown

# Ready

# mount point
WORKDIR /docs
VOLUME ["/docs"]

# serve at port 8000

EXPOSE 8000
ENTRYPOINT ["mkdocs"]
CMD ["serve", "--dev-addr=0.0.0.0:8000"]
