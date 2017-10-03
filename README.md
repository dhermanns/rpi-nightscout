# rpi-nightscout
CGM Remote Monitor aka [Nightscout](http://www.nightscout.info) for the Raspberry Pi 1/2/3.
This images offers a node.js webserver containing the Nightscout Application Version 0.9.2.

This image uses the rpi-mongo image to run a mongo database on the Raspberry Pi:
https://hub.docker.com/r/dhermanns/rpi-mongo

# Github Repo
The image is created by using the Github Repository located here:
https://github.com/dhermanns/rpi-nightscout

# Usage
## Install Hypriot OS on your Raspberry
First of all, you need a Raspberry Pi 1,2 or 3. Install an operating system that supports
the docker runtime. E.g. follow the instructions to install the nice hypriot os:
http://blog.hypriot.com/getting-started-with-docker-on-your-arm-device/

## Install Docker-Compose
Afterwards you should have a running Raspberry which is able to start Docker Container.
What we additionally need is the docker-compose component. Using this tool we are able to fire up
all that is needed to start Nightscout plus Mongo with just two command lines.

The steps needed to install docker-compose are documented here:
http://blog.hypriot.com/post/docker-compose-nodejs-haproxy

The short story is - simply execute this command:
```
$ sudo su -
$ curl -L https://github.com/hypriot/compose/releases/download/1.2.0-raspbian/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
```

## Checkout this repository to your Raspberry Pi
Clone this repository to your Raspberry. Execute
```
git clone https://github.com/dhermanns/rpi-nightscout
```
The above git-repository contains the Docker file to create a docker image and a
docker-compose script to launch rpi-nightscout referencing the
necessary rpi-mongo database image.

## Modify your API Key
It is recommended that you add your own API Key. This key has to be entered into your Uploader Application.
If you are using a Medtronic Pump, than you are using [this](https://github.com/arbox0/MedtronicUploader) application.
You can edit your API Key by using e.g. nano editor
```
cd rpi-nightscout
nano docker-compose.yml
```
Remember that you have to provide a secret key that has to have at least 12 characters!

## Modify your Nightscout Settings
To modify your nightscout configuration, you can simply modify the environment settings in your docker-compose.yml file.
E.g. to modify the default alarm ranges change the values of BG_HIGH, BG_LOW, etc.:
```
nightscout:
  image: dhermanns/rpi-nightscout:0.9.2
  environment:
    TZ: Europe/Berlin
    MONGO_CONNECTION: mongodb://mongo:27017/nightscout
    API_SECRET: nightscout2000
    BG_HIGH: 220
    BG_LOW: 60
    BG_TARGET_TOP: 180
    BG_TARGET_BOTTOM: 80
```

## Fire-up the Nightscout Application
After cloning you are ready to start the Nightscout Application using docker compose
```
docker-compose up -d
```

## Access your Nightscout Application
Now you should be able to connect to your Nightscout Application by entering
```
http://<name-of-my-raspberry>:1337
```
in your Webbrowser.

## Optional: Direct access to the mongo database
If you would like direct access to the mongo database, you will have to open up the mongo db port to be accessible from outside the docker container. You can easily do this by modifying the `docker-compose.yml`:
```
mongo:
  image: dhermanns/rpi-mongo:2.6.4
  ports:
    - "27017:27017"
    - "27018:27018"
    - "27019:27019"
    - "28017:28017"
  command: "/opt/mongodb/bin/mongod"
  restart: always
```

This way you should be able to use other tools that would like direct access.

## Configure your Uploader
To upload your CGM Data to your Nightscout system, this image is designed to use the REST-API Upload
only! The internal Mongo Port is not exposed by default.

So let your Uploader point to the REST API located here:
```
<mysecretapikey>@http://<name-of-my-raspberry>:1337/api/v1/
```
And enter your Secret API Key that you have configured in your docker-compose.yml file.

!!!**WARNING** - the format is not documented on the arbox0 site and the format documented for the dexcom version of the uploader differs from the format above. But what's working for me with the arbox0 uploader is exactly the format above!!!

Congratulations - you should have a complete Nightscout System to monitor your diabetes data
based on your local Raspi!

## Activate HTTPS
If you would like to use e.g. the MyBG Apple Watch App, you will have to activate HTTPS for the nightscout cgm remote monitor.
To do this, first create a private key and a certification request for your node-server:
```
openssl req -nodes -newkey rsa:2048 -keyout server.key -out server.csr
```
Afterwards grab a free SSL-Certificate e.g. from this Certification Agency:
```
https://buy.wosign.com/free/
```
Download your server certificate and use the certificates contained in "for Other Server.zip".
Create a certification chain in one file:
```
cat 3_user_my-server-domain.de.crt 2_issuer_Intermediate.crt 1_cross_Intermediate.crt > serverchain.crt
```
If you don't create the chain of trust in this way, your browser will complain about your certificate and the iOS and Apple Watch Apps won't work!

Then configure your docker-compose.yml and activate node to use your newly created certificates:
```
nightscout:
  image: dhermanns/rpi-nightscout:0.9.2
  environment:
    SSL_KEY: /var/opt/ssl/server.key
    SSL_CERT: /var/opt/ssl/serverchain.crt
```
I don't needed to add anything to the SSL_CA environment value. Take care that you change the URL in the uploader to HTTPS. Change the URL in all other devices e.g. Watches or Smartphones.

License
---------------

[agpl-3]: http://www.gnu.org/licenses/agpl-3.0.txt

    cgm-remote-monitor - web app to broadcast cgm readings
    Copyright (C) 2015 The Nightscout Foundation, http://www.nightscoutfoundation.org.

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU Affero General Public License as published
    by the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU Affero General Public License for more details.

    You should have received a copy of the GNU Affero General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
