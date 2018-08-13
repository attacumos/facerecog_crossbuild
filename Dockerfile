# Use an official Python runtime as a parent image
FROM nxpml/armv8:ncnn

# Copy over cross build environment
COPY qemu-aarch64-static /usr/bin/ 

# Set the working directory to /app
WORKDIR /app

# wipe out previous content
#RUN rm -rf /app/*

# Copy the current directory contents into the container at /app
ADD . /app


#disable interactive mode in tzdata installation
#ENV DEBIAN_FRONTEND noninteractive

#Install required Ubuntu packages (Note: need to explicitly list them in cross build environ
RUN apt-get update && apt-get install -y --fix-missing \
    libboost-dev                                       \
    libboost-python-dev

#install required PIP packages
RUN pip install  flask_socketio


RUN git clone https://github.com/nxp-gf/flask-server-for-ncnn                           &&\
    cd flask-server-for-ncnn                                                            &&\
    git checkout f69e5afa1116dd08fd8ced5dc884e048e9731cc4                               &&\
    git apply --verbose --ignore-whitespace --reject /app/server.diff

RUN git clone https://github.com/nxp-gf/ncnn-face-recognition.git                       &&\
    cd ncnn-face-recognition                                                            &&\
    git checkout b1702d60916d20c687e024f8e6ed3f9b4d5058bf                               &&\
    mkdir build                                                                         &&\
    cd build                                                                            &&\
    cmake ..                                                                            &&\
    make -j 4                                                                           &&\
    cp facerecognition.so /app/flask-server-for-ncnn


    









