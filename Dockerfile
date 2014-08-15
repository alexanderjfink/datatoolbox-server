############################################################
# Dockerfile to build data science toolbox server container
# Based on Ubuntu
############################################################

# Set base image
FROM ubuntu

# File author/maintainer
MAINTAINER Alexander Fink <alexanderjfink@gmail.com>

RUN apt-get update

################## BEGIN INSTALLATION ######################
# Install Nginx.
RUN \
  add-apt-repository -y ppa:nginx/stable && \
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
EXPOSE 80
EXPOSE 443

#### CSV FINGERPRINT ####
# Install CSV Fingerprint
ADD http://github.com/vicapow/csv-fingerprint /www-data