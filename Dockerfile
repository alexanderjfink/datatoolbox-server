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
# Install Nginx and Git
RUN \
  apt-get install -y python-software-properties && \
  add-apt-repository ppa:nginx/stable && \
  apt-get update && \
  apt-get install -y git && \
  apt-get update && \
  apt-get install -y nginx && \
  echo "\ndaemon off;" >> /etc/nginx/nginx.conf && \
  chown -R www-data:www-data /var/lib/nginx


#### SET UP PYTHON NLTK  ####
#### http://nltk.org/    ####

#install the pip python package manager
RUN \
  apt-get install -y python-pip vim git-core screen unzip libyaml-dev wget

#install the python package distribute, a prerequisite of nltk

RUN \
  pip install distribute && \
  pip install nltk

#download all the data packages for nltk
RUN python -m nltk.downloader all

#### Python Port of Stanford NLP libraries         ####
#### https://bitbucket.org/torotoki/corenlp-python ####

# install prerequisites
RUN pip install pexpect unidecode jsonrpclib

# clone the repository and download datafiles
RUN git clone https://bitbucket.org/torotoki/corenlp-python.git
RUN wget http://nlp.stanford.edu/software/stanford-corenlp-full-2013-06-20.zip
RUN unzip stanford-corenlp-full-2013-06-20.zip

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y -q r-base r-base-dev gdebi-core libapparmor1 supervisor sudo libcurl4-openssl-dev
RUN update-locale
RUN (wget http://download2.rstudio.org/rstudio-server-0.98.978-amd64.deb && gdebi -n rstudio-server-0.98.978-amd64.deb)
RUN rm /rstudio-server-0.98.978-amd64.deb
RUN (adduser --disabled-password --gecos "" guest && echo "guest:guest"|chpasswd)
RUN mkdir -p /var/log/supervisor
ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# install python scikit
RUN apt-get install -y build-essential python-dev python-numpy python-setuptools python-scipy libatlas-dev libatlas-base-dev python-matplotlib
RUN pip install -U scikit-learn

# install ipython notebook
# http://ipython.org/notebook.html
# to run it ipython notebook
RUN apt-get install ipython-notebook

##################### INSTALLATION END #####################

#### SETUP NGINX ####
# Define mountable directories.
VOLUME ["/data", "/etc/nginx/sites-enabled", "/etc/nginx/conf.d", "/var/log/nginx"]

# Define working directory.
WORKDIR /etc/nginx

# Define default command.
CMD ["nginx"]

# Expose ports for nginx
EXPOSE 80 443

# Expose ports for RStudio Server
EXPOSE 8787 22
# CMD ["/usr/bin/supervisord"]


#### CSV FINGERPRINT ####
# Install CSV Fingerprint
RUN git clone https://github.com/setosa/csv-fingerprint.git /usr/share/nginx/html/csv-fingerprint
