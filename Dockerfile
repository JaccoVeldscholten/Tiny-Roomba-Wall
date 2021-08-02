# Build Container:  docker build -t jjveldscholten/avr-toolchain .
# Run   Container:  docker run --name avr-toolchain -itd jjveldscholten/avr-toolchain:latest
# Push Command   :  docker push jjveldscholten/avr-toolchain

FROM alpine:3.10

ARG TARBALLS_PATH=contrib
ARG TOOLS_PATH=/tools

# Prepare directory for tools
RUN mkdir ${TOOLS_PATH}
WORKDIR ${TOOLS_PATH}

RUN apk --no-cache add ca-certificates wget make cmake avrdude nano binutils gcc-avr avr-libc uisp avrdude flex byacc bison\
	&& wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub \
	&& wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.29-r0/glibc-2.29-r0.apk \
	&& apk add glibc-2.29-r0.apk \
	&& rm glibc-2.29-r0.apk
	
WORKDIR /build


