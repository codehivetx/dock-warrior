FROM ubuntu:22.10 AS build
MAINTAINER srl295

USER root

# From taskwarrior's build
RUN apt-get update
RUN DEBIAN_FRONTEND="noninteractive" apt-get install -y build-essential cmake git uuid-dev libgnutls28-dev faketime locales python3
# Additional
RUN DEBIAN_FRONTEND="noninteractive" apt-get install -y curl
# Setup language environment
RUN locale-gen en_US.UTF-8
ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV HOME /home/build
ENV OPT /opt
RUN useradd -c "Build user" -d $HOME -m build
RUN mkdir ${OPT} ; chown build ${OPT}
USER build
WORKDIR /home/build

# Fetch and build taskwarrior
ARG TASK_VERSION=2.6.2
RUN (mkdir task ; cd task ; curl -L https://github.com/GothenburgBitFactory/taskwarrior/releases/download/v${TASK_VERSION}/task-${TASK_VERSION}.tar.gz | tar xfpz - --strip-components=1)
RUN (cd task && cmake -DCMAKE_INSTALL_PREFIX=${OPT} -DCMAKE_BULD_TYPE=release . && make -j2 all install )

ARG TIMEW_VERSION=1.4.3
RUN (mkdir timew ; cd timew ; curl -L https://github.com/GothenburgBitFactory/timewarrior/releases/download/v${TIMEW_VERSION}/timew-${TIMEW_VERSION}.tar.gz | tar xfpz - --strip-components=1)
RUN (cd timew && cmake -DCMAKE_INSTALL_PREFIX=${OPT} -DCMAKE_BULD_TYPE=release . && make -j2 all install )

FROM ubuntu:22.10 AS run
COPY --from=build /opt /opt
VOLUME /config /data
ENV TASKRC=/config/task/taskrc
ENV TASKDATA=/data/task
