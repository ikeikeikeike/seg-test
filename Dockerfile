# jubatus base image
FROM buildpack-deps:buster

ENV PATH /usr/local/bin:$PATH

ENV LANG C.UTF-8

RUN apt update && apt -y install clang

WORKDIR /opt
COPY ./ ./

RUN echo 'kernel.core_pattern = /tmp/core.%e.%p.%h.%t' >> /etc/sysctl.conf
RUN echo 'root             -       core            unlimited' >> /etc/security/limits.conf
RUN echo '*                -       core            unlimited' >> /etc/security/limits.conf
RUN mkdir -p /etc/default && echo 'enabled=0' >> /etc/default/apport

RUN clang seg.c && ls -alt

CMD ["/opt/a.out"]
