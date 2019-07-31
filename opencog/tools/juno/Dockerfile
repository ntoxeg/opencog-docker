# For creating images with gui tools for opencogopment, and dependencies installed
# Steps:
# 1. docker build -t singnet/opencog-dev:juno .
# 2. docker create --name opencog-dev-juno -p 17001:17001 -p 5000:5000
#       -e DISPLAY=$DISPLAY -v /tmp/.X11-unix/:/tmp/.X11-unix/:ro -it
#       -w /opencog
#       -it singnet/opencog-dev:juno
# 3. docker start -i opencog-dev-juno
# 4. atom

FROM ubuntu:18.04

# Install non-system project dependencies
# RUN  /tmp/octool -al ; ccache -C

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update ; apt-get -y upgrade ; apt-get -y autoclean
RUN apt-get install -y tzdata

# Base tools
RUN apt-get -y install maven tmux telnet netcat-openbsd byobu \
                       wget curl vim git unzip sudo apt-utils

RUN curl -L http://raw.github.com/singnet/ocpkg/master/ocpkg -o /usr/local/bin/octool && \
    chmod +x /usr/local/bin/octool

# Create and switch user. The user is privileged, with no password
# required.  That is, you can use sudo.
RUN adduser --disabled-password --gecos "opencog developer USER" opencog
RUN adduser opencog sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

ADD https://julialang-s3.julialang.org/bin/linux/x64/1.1/julia-1.1.1-linux-x86_64.tar.gz julia.tar.gz
RUN tar xf julia.tar.gz -C /home/opencog
RUN wget -L https://atom.io/download/deb -O atom.deb
RUN apt install -y ./atom.deb

# Workspace configuration
ADD atom-startup-script.sh /home/opencog/
RUN mkdir /projects
USER opencog
RUN apm install uber-juno
# Install dependencies explicitly, so that they are not installed on every Atom start.
RUN apm install language-julia
RUN apm install indent-detective
RUN apm install ink
RUN apm install julia-client
RUN apm install latex-completions
RUN apm install tool-bar
ADD config.cson /home/opencog/.atom/
ENV PATH "/home/opencog/julia-1.1.1/bin:$PATH"

# Ported from https://hub.docker.com/r/opencog/vqa/dockerfile
USER root

RUN rm /bin/sh && ln -s /bin/bash /bin/sh  # TODO: is this doable via `chsh`?

RUN apt-get -y install openjdk-11-jdk

# GCC and basic build tools
RUN apt-get -y install gcc g++ make swig ant

# Wordnet
RUN apt-get -y install wordnet wordnet-dev wordnet-sense-index

RUN mkdir /usr/local/share/java

# build tools
RUN apt install -y libboost-python-dev \
                   libblas-dev \
                   libboost-thread-dev \
                   libboost-filesystem-dev \
                   libboost-system-dev
RUN apt install -y cmake \
                   libboost-program-options-dev \
                   libboost-regex-dev \
                   libiberty-dev \
                   protobuf-compiler \
                   uuid-dev

RUN apt install -y wget bzip2 ca-certificates \
    libglib2.0-0 libxext6 libsm6 libxrender1 libjsoncpp-dev

# Punch out ports
## plain-text-server.sh port
EXPOSE 3333
## opencog-server.sh port
EXPOSE 4444
## link-grammar-server.sh port
EXPOSE 9000

USER opencog
RUN sudo chown -R opencog:opencog /home/opencog
WORKDIR /home/opencog

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8
ENV PATH /opt/conda/bin:$PATH
RUN wget --quiet https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/anaconda.sh && \
    /bin/bash ~/anaconda.sh -b && \
    rm ~/anaconda.sh

RUN /home/opencog/miniconda3/bin/conda create -y --name opencog-dev python=3.6 && \
    source /home/opencog/miniconda3/bin/activate opencog-dev && \
    echo 'opencv==3.1.0' >> $(dirname $(which python))/../conda-meta/pinned && \
    conda install -y opencv \
                     bokeh \
                     ca-certificates \
                     certifi \
                     cffi \
                     click \
                     cloudpickle \
                     cudatoolkit \
                     cudnn \
                     cycler \
                     cython \
                     cytoolz \
                     decorator \
                     distributed \
                     expat \
                     fontconfig \
                     freetype \
                     gflags \
                     glib \
                     glog \
                     h5py \
                     hdf5 \
                     heapdict \
                     icu \
                     imageio \
                     intel-openmp \
                     jbig \
                     jpeg \
                     leveldb \
                     libedit \
                     libffi \
                     libgcc \
                     libgcc-ng \
                     libgfortran-ng \
                     libiconv \
                     libpng \
                     libstdcxx-ng \
                     libtiff \
                     libxcb \
                     libxml2 \
                     lmdb \
                     locket \
                     markupsafe \
                     matplotlib \
                     mkl \
                     msgpack-python \
                     nccl \
                     ncurses \
                     networkx \
                     ninja \
                     numpy \
                     openssl \
                     packaging \
                     pandas \
                     partd \
                     pcre \
                     pillow \
                     pip \
                     python \
                     python-dateutil \
                     pytorch \
                     jupyterlab && \
                     conda install -y -c conda-forge jpype1 && \
                     pip install easydict gym

ENV JAVA_HOME /usr/lib/jvm/java-1.11.0-openjdk-amd64
RUN echo "export JAVA_HOME=/usr/lib/jvm/java-1.11.0-openjdk-amd64" >> /home/opencog/.profile

RUN mkdir /home/opencog/src
RUN source /home/opencog/miniconda3/bin/activate opencog-dev && \
    conda uninstall -y pyzmq && \
    octool -rdgsca -l default -j10 && \
    octool -o -j10
# OpenCog has to be installed after LinkGrammar is installed --^

# There are UTF8 chars in the Java sources, and the RelEx build will
# break if build in a C environment.
RUN sudo apt-get -y install locales && sudo locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

WORKDIR /home/opencog/src

# Link Parser -- changes often
# Download the current released version of link-grammar.
# The wget gets the latest version w/ wildcard

RUN wget -r --no-parent -nH --cut-dirs=2 https://www.abisource.com/downloads/link-grammar/current/
RUN tar -zxf current/link-grammar-5*.tar.gz
# get linkgrammar version
RUN bash -l -c 'echo `ls|grep link|sed 's/link-grammar-//g'` >> LINKGRAMMAR_VERSION'
RUN cd link-grammar-5.*/; ./configure; make -j6; sudo make install; \
    sudo ldconfig;
RUN cd link-grammar-5.*/; mvn install:install-file \
    -Dfile=./bindings/java/linkgrammar-`cat ../LINKGRAMMAR_VERSION`.jar \
    -DgroupId=org.opencog \
    -DartifactId=linkgrammar \
    -Dversion=`cat ../LINKGRAMMAR_VERSION` \
    -Dpackaging=jar
RUN rm -rf *link-grammar*

# Relex -- changes often
RUN wget https://github.com/singnet/relex/archive/master.tar.gz -O master.tar.gz
RUN tar -xvf master.tar.gz; cd relex-master; mvn install

RUN echo "export LD_LIBRARY_PATH=\$LD_LIBRARY_PATH:/usr/local/lib/" >> /home/opencog/.profile
RUN echo "export LD_LIBRARY_PATH=\$LD_LIBRARY_PATH:/home/opencog/miniconda3/envs/opencog-dev/lib/" >> /home/opencog/.profile
# # cogutil
# RUN wget https://github.com/singnet/cogutil/archive/master.zip
# RUN unzip master.zip && cd cogutil-master/ && mkdir build && cd build && cmake ..
# RUN cd cogutil-master/build && make -j10 && sudo make install
# RUN sudo rm -rf cogutil-master master.zip
#
# # atomspace
# RUN wget https://github.com/singnet/atomspace/archive/master.zip
# RUN unzip master.zip
# RUN source /home/opencog/miniconda3/bin/activate opencog-dev && \
#     cd atomspace-master && \
#     mkdir build && \
#     cd build/ && \
#     cmake .. && \
#     make -j10
# run cd atomspace-master/build && sudo make install
# RUN sudo rm -rf atomspace-master/build master.zip
# RUN mv atomspace-master /home/opencog/src/atomspace
#
# # opencog
# RUN wget https://github.com/singnet/opencog/archive/master.zip
# RUN unzip master.zip
# RUN source /home/opencog/miniconda3/bin/activate opencog-dev && \
#     cd opencog-master && \
#     mkdir build && \
#     cd build/ && \
#     cmake .. && \
#     make -j10
# RUN cd opencog-master/build && sudo make install
# RUN sudo rm -rf opencog-master/build master.zip
# RUN mv opencog-master /home/opencog/src/opencog

RUN echo "export GUILE_AUTO_COMPILE=0" >> /home/opencog/.profile

RUN echo "(use-modules (ice-9 readline)) (activate-readline)\
(add-to-load-path \"/usr/local/share/opencog/scm\")\
(add-to-load-path \"/opencog/examples/pln/conjunction/\")\
(add-to-load-path \"/atomspace/examples/rule-engine/rules/\")\
(add-to-load-path \"/opencog/opencog/pln/rules/\")\
(add-to-load-path \".\")\
(use-modules (opencog))\
(use-modules (opencog query))\
(use-modules (opencog exec))" >> /home/opencog/.guile

RUN echo "export PYTHONPATH=\$PYTHONPATH:/usr/local/lib/python3.6/dist-packages/" >> /home/opencog/.profile
# RUN source /home/opencog/miniconda3/bin/activate opencog-dev && jupyter notebook --generate-config
# RUN echo "c.NotebookApp.password = 'sha1:b6e570f197d6:b920933b262cf450f5c11dc21d878c53972cb2fa'" >> /home/opencog/.jupyter/jupyter_notebook_config.py
# RUN echo "c.NotebookApp.password_required = False" >> /home/opencog/.jupyter/jupyter_notebook_config.py
# RUN echo "c.NotebookApp.port = 8888" >> /home/opencog/.jupyter/jupyter_notebook_config.py
#------------------------------------------------------------------------------#

WORKDIR /projects
CMD /home/opencog/atom-startup-script.sh
