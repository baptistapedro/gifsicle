FROM fuzzers/afl:2.52

RUN apt-get update
RUN apt install -y build-essential wget git clang cmake zlib1g zlib1g-dev autoconf 
RUN git clone https://github.com/kohler/gifsicle.git
WORKDIR /gifsicle
RUN ./bootstrap.sh
RUN CC=afl-clang ./configure
RUN make
RUN make install
RUN cp /usr/local/bin/gifsicle /gifsicle
RUN mkdir /gifsicleCorpus
RUN wget https://www.sample-videos.com/gif/3.gif
RUN wget https://www.sample-videos.com/gif/1.gif
RUN wget https://www.sample-videos.com/gif/2.gif
RUN wget https://file-examples.com/wp-content/uploads/2017/10/file_example_GIF_500kB.gif
RUN wget https://raw.githubusercontent.com/kohler/gifsicle/master/logo.gif
RUN mv *.gif /gifsicleCorpus


ENTRYPOINT ["afl-fuzz", "-i", "/gifsicleCorpus", "-o", "/gifsicleOut"]
CMD ["/gifsicle", "@@", "-o", "/dev/null"]
