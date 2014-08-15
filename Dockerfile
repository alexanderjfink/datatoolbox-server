############################################################
# Dockerfile to build data science toolbox server container
# Based on Ubuntu
############################################################

# Set base image
FROM ubuntu

# File author/maintainer
MAINTAINER Alexander Fink <alexanderjfink@gmail.com>

RUN echo deb http://archive.ubuntu.com/ubuntu precise main universe multiverse > /etc/apt/sources.list

################## BEGIN INSTALLATION ######################
# Install Nginx.
RUN \
  apt-get install -y python-software-properties && \
  add-apt-repository ppa:nginx/stable && \
  apt-get update && \
  apt-get install -y git && \
  apt-get update && \
  apt-get install -y nginx && \
  echo "\ndaemon off;" >> /etc/nginx/nginx.conf && \
  chown -R www-data:www-data /var/lib/nginx

##################### INSTALLATION END #####################

#### SETUP NGINX ####
# Define mountable directories.
VOLUME ["/data", "/etc/nginx/sites-enabled", "/etc/nginx/conf.d", "/var/log/nginx"]

# Define working directory.
WORKDIR /etc/nginx

# Define default command.
CMD ["nginx"]

# Expose ports.
EXPOSE 80 443

#### CSV FINGERPRINT ####
# Install CSV Fingerprint
RUN git clone https://github.com/setosa/csv-fingerprint.git /www-data/csv-fingerprint
