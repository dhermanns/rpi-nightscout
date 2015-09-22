# rpi-nightscout
CGM Remote Monitor aka [Nightscout](http://www.nightscout.info) for the Raspberry Pi 1/2.
This images offers a node.js webserver containing the Nightscout Application Version 0.8.0.

This image uses the rpi-mongo image to run a mongo database on the Raspberry Pi:
https://hub.docker.com/r/dhermanns/rpi-mongo

# Github Repo
The image is created by using the Github Repository located here:
https://github.com/dhermanns/rpi-nightscout

# Usage
## Install Hypriot OS on your Raspberry
First of all, you need a Raspberry Pie 1 or 2. Install an operation system that supports
the docker runtime. E.g. follow the instructions to install the nice hypriot os:
http://blog.hypriot.com/getting-started-with-docker-on-your-arm-device/

## Install Docker-Compose
Afterwards you should have a running Raspberry which is able to start Docker Container.
What we need more is the docker-compose component. Using this tool we are able to fire up
all that is need to start Nightscout with just two command lines.

The steps needed to install docker-compose are documented here:
http://blog.hypriot.com/post/docker-compose-nodejs-haproxy

The short story is - simply execute this command:
```
$ sudo sh -c "curl -L https://github.com/hypriot/compose/releases/download/1.1.0-raspbian/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose; chmod +x /usr/local/bin/docker-compose"
```

## Checkout this repository to your Raspberry Pi
Clone this repository to your Raspberry. Execute
```
git clone https://github.com/dhermanns/rpi-nightscout
```
The above git-repository contains the Docker file to create a docker image and a
docker-compose script to startup rpi-nightscout referencing the
necessary rpi-mongo database image.

## Modify your API Key
It is recommended that you add your own API Key. This key has to be entered into your Uploader Application.
If you are using a Medtronic Pump, than you are using [this](https://github.com/arbox0/MedtronicUploader) application.
You can edit your API Key by using e.g. nano editor
```
nano docker-compose.yml
```
Remember that you have to provide a secret key that has to have at least 12 characters!

## Fire-up the Nightscout Application
After cloning you are ready to startup the Nightscout Application using docker compose
```
cd rpi-nightscout
docker-compose up
```

## Access your Nightscout Application
Now you should be able to connect to your Nightscout Application by entering
```
http://<name-of-my-raspberry>:1337
```
in your Webbrowser.

## Configure your Uploader
To upload your CGM Data to your Nightscout system, this image is designed to use the REST-API Upload
only! The internal Mongo Port is not exposed by default.

So let your Uploader point to the REST API located here:
```
http://<name-of-my-raspberry>:1337/api/v1/
```
And enter your Secret API Key that you have configured in your docker-compose.yml file.

Congratulations - you should have a complete Nightscout System to monitor your diabetes data
based on your local Raspi!

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
