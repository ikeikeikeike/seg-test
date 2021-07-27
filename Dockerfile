# jubatus base image
FROM buildpack-deps:buster

ENV PATH /usr/local/bin:$PATH

ENV LANG C.UTF-8

RUN apt update && apt -y install clang

WORKDIR /opt
COPY ./ ./

RUN echo 'kernel.core_pattern = /tmp/core.%e.%p.%h.%t'        >> /etc/sysctl.conf
RUN echo 'root             -       core            unlimited' >> /etc/security/limits.conf
RUN echo '*                -       core            unlimited' >> /etc/security/limits.conf
RUN mkdir -p /etc/default && echo 'enabled=0' >> /etc/default/apport
RUN ulimit -c unlimited
RUN clang seg.c && ls -alt

ENTRYPOINT ["/bin/sh", "-c"]
CMD ["ulimit -c unlimited && echo '/tmp/core.%e.%p.%h.%t' | tee /proc/sys/kernel/core_pattern && /opt/a.out"]
