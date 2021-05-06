# For interacting with jupter notebooks. This installs a kernel for python and guile.

# Build from opencog-dev:latest as it has all packages it needs.
FROM synthillect/opencog-dev:latest

RUN apt-get update --fix-missing && apt-get install -y wget bzip2 ca-certificates \
    libglib2.0-0 libxext6 libsm6 libxrender1 \
    git mercurial subversion \
    curl python3-pip

RUN python3 -m pip install -U setuptools jupyterlab ipykernel tornado

# --- guile kernel installation for Jupyter is suspended for now.

# Install guile-json as it is needed for guile-kernel
# WORKDIR /opt/

# RUN wget https://download.savannah.gnu.org/releases/guile-json/guile-json-3.2.0.tar.gz && \
#     tar xvf guile-json-3.2.0.tar.gz && \
#     rm guile-json-3.2.0.tar.gz && \
#     cd guile-json-3.2.0 && \
#     ./configure --prefix=/usr && \
#     make install
# Why does it install in the wrong directory?
# RUN mkdir -p /usr/local/share/guile/site/2.2/
# RUN mv /usr/local/share/guile/site/json* /usr/share/guile/site/2.2/

# ZMQ library to enable communication with jupyter notebook
# RUN git clone https://github.com/jerry40/guile-simple-zmq /tmp/guile-simple-zmq
# RUN cd /tmp/guile-simple-zmq \
#        && ./bootstrap \
#        && ./configure \
#        && make -j \
#        && make install

# Create a directory with the guile kernel in jupyter notebook kernels directory
# WORKDIR /usr/local/share/jupyter/kernels

# RUN git clone --depth 1 https://github.com/jerry40/guile-kernel guile
# Copy kernel description to the above folder
# COPY kernel.json /usr/local/share/jupyter/kernels/guile/

RUN groupadd -r jupyter_users && gpasswd -a opencog jupyter_users
EXPOSE 8888
USER opencog
CMD [ "jupyter", "lab", "--ip=0.0.0.0", "--port=8888", "--no-browser" ]
