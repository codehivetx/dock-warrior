FROM ubuntu:22.10 AS build
MAINTAINER srl295
LABEL org.opencontainers.image.source = "https://github.com/codehivetx/dock-warrior"

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

# Now, the runner
FROM ubuntu:22.10 AS run
RUN apt-get update
RUN DEBIAN_FRONTEND="noninteractive" apt-get install -y python3 tzdata
ENV TZ="America/New_York"
COPY --from=build /opt /opt
VOLUME /config /data
ENV TASKRC=/config/task/taskrc
ENV TASKDATA=/data/task
ENV TIMEWARRIORDB=/data/timew
ENV PATH=/opt/bin:${HOME}/bin:/usr/local/bin:/usr/bin:/bin

# TODO MOVE UP
USER root
RUN DEBIAN_FRONTEND="noninteractive" apt-get install -y python3 python3-pip
RUN DEBIAN_FRONTEND="noninteractive" apt-get install -y curl

# TODO: version
ARG BUGWARRIOR_VERSION=develop
RUN (mkdir bugwarrior && cd bugwarrior && curl -L https://github.com/ralphbean/bugwarrior/tarball/${BUGWARRIOR_VERSION} | tar xfpz - --strip-components=1 )
# TODO: install in build env
RUN (cd bugwarrior && python3 setup.py install)
RUN rm -rf /bugwarrior
ENV XDG_CONFIG_HOME=/config
env BUGWARRIORRC=/config/bugwarrior/bugwarriorrc