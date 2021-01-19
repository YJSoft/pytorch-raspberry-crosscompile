FROM balenalib/raspberrypi3-python
# great feature from balena images that allow xcompile!
RUN [ "cross-build-start" ]

WORKDIR /usr/src/app
RUN apt-get update && apt-get install libopenblas-dev libblas-dev m4 cmake cython python3-dev python3-yaml python3-setuptools libavutil-dev libavcodec-dev libavformat-dev libswscale-dev -y
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
