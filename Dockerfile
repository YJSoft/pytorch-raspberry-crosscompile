FROM balenalib/raspberrypi3-python:3-buster
# great feature from balena images that allow xcompile!
RUN [ "cross-build-start" ]

RUN sed -i "s/deb.debian.org/ftp.harukasan.org/g" /etc/apt/sources.list
RUN sed -i "s/archive.raspbian.org\/raspbian/ftp.harukasan.org\/raspbian\/raspbian/g" /etc/apt/sources.list
RUN sed -i "s/archive.raspberrypi.org\/debian/ftp.harukasan.org\/raspberrypi\/debian/g" /etc/apt/sources.list.d/raspi.list

WORKDIR /usr/src/app
RUN apt-get update && apt-get install build-essential libopenblas-dev libblas-dev m4 cmake git wget curl cython python3-dev python3-yaml python3-setuptools libavutil-dev libavcodec-dev libavformat-dev libswscale-dev -y
RUN git clone --recursive https://github.com/pytorch/pytorch ./pytorch

WORKDIR /usr/src/app/pytorch
RUN git submodule update --remote third_party/protobuf
RUN export NO_CUDA=1
RUN export NO_DISTRIBUTED=1
RUN export NO_MKLDNN=1 
RUN export NO_NNPACK=1
RUN export NO_QNNPACK=1

# build pytorch
RUN python3 setup.py build

WORKDIR /usr/src/app
RUN git clone --recursive https://github.com/pytorch/vision ./vision

WORKDIR /usr/src/app/vision
RUN python3 setup.py build

RUN [ "cross-build-end" ]
