#
# CGM Remote Monitor Dockerfile
#
# https://github.com/dhermanns/rpi-nightscout
#

# Pull base image.
FROM arm32v7/node:10-stretch

# install git and npm
RUN apt-get update && apt-get install -y software-properties-common python g++ make git

# Upgrade
RUN apt-get upgrade -y

# create node user
#RUN useradd --system -ms /bin/bash node && \
#    cd && cp -R .bashrc .profile /home/node && \
RUN mkdir /home/node/app && \
    chown -R node:node /home/node

USER node
ENV HOME /home/node
WORKDIR /home/node/app

# install the application
RUN git clone https://github.com/nightscout/cgm-remote-monitor.git . && \
    git checkout tags/13.0.1 && \
    npm install

EXPOSE 1337
CMD ["node", "server.js"]
