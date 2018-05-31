FROM python:3.6-alpine

# version is the same as plantuml.py
LABEL maintainer="DHuan <hd@iamhd.top>" \
      description="This image is mkdocs with plantuml(svg only) support." \
      version="1.2.3" \
      index="official"

# package indexes

# use aliyun alpine mirrors:
# COPY repositories /etc/apk/repositories

# use aliyun pip mirrors:
# COPY pip.conf /etc/pip.conf

# Phrase 1 : Install plantuml

# add a small-size font, else plantuml will fail
RUN apk add --update openjdk8-jre-base openjdk8-jre ttf-droid

# busybox wget can't use `https` by itself, add `curl` instead
RUN apk add curl \
    && mkdir -p /opt \
    && curl -L https://sourceforge.net/projects/plantuml/files/plantuml.jar \
    -o /opt/plantuml.jar \
    && apk del curl

# add plantuml executable
COPY plantuml /usr/local/bin/plantuml
RUN chmod +x /usr/local/bin/plantuml

# clean cache for a smaller image
RUN rm -rf /var/cache/apk/*

# Phrase 2 : Install mkdocs and plantuml-markdown extension

# install `mkdocs`
RUN pip --no-cache-dir install mkdocs-material

# add plugins:
# add plantuml-markdown
COPY plantuml.py /usr/local/lib/python3.6/site-packages/markdown/extensions/

# Ready

# mount point
WORKDIR /docs
VOLUME ["/docs"]

# serve at port 8000

EXPOSE 8000
ENTRYPOINT ["mkdocs"]
CMD ["serve", "--dev-addr=0.0.0.0:8000"]
