# For creating images with gui tools for development, and dependencies installed
# Steps:
# 1. docker build -t singnet/opencog-dev:juno .
# 2. docker create --name opencog-dev-juno -p 17001:17001 -p 5000:5000
#       -e DISPLAY=$DISPLAY -v /tmp/.X11-unix/:/tmp/.X11-unix/:ro -it
#       -w /opencog
#       -it singnet/opencog-dev:juno
# 3. docker start -i opencog-dev-juno
# 4. atom

FROM opencog/cogutil

# Install non-system project dependencies
RUN  /tmp/octool -al ; ccache -C

# Tools
RUN apt-get -y install tmux

ADD https://julialang-s3.julialang.org/bin/linux/x64/1.1/julia-1.1.1-linux-x86_64.tar.gz julia.tar.gz
RUN tar xf julia.tar.gz -C /home/opencog
RUN wget -L https://atom.io/download/deb -O atom.deb
RUN apt install -y ./atom.deb

# Workspace configuration
ADD atom-startup-script.sh /home/opencog/
RUN chown opencog:opencog /home/opencog/atom-startup-script.sh
RUN chown -R opencog:opencog /home/opencog/julia-1.1.1/
USER opencog
RUN apm install uber-juno
RUN apm install language-julia
RUN apm install indent-detective
RUN apm install ink
RUN apm install julia-client
RUN apm install latex-completions
RUN apm install tool-bar
ADD config.cson /home/opencog/.atom/
ENV PATH "/home/opencog/julia-1.1.1/bin:$PATH"
CMD /home/opencog/atom-startup-script.sh
