FROM alpine:latest as builder


RUN apk --update --upgrade add git
RUN git clone https://github.com/kanaka/noVNC.git /root/noVNC \
 && git clone https://github.com/kanaka/websockify /root/noVNC/utils/websockify \
 && rm -rf /root/noVNC/.git || true \
 && rm -rf /root/noVNC/utils/websockify/.git || true \
 && cp /root/noVNC/vnc.html /root/noVNC/index.html

FROM alpine:latest

COPY --from=builder /root/noVNC /root/noVNC

ARG DEBIAN_FRONTEND=noninteractive
# Setup demo environment variables
ENV HOME=/root \
	LANG=en_US.UTF-8 \
	LANGUAGE=en_US.UTF-8 \
	LC_ALL=C.UTF-8 \
	DISPLAY=:0.0 \
	DISPLAY_WIDTH=1024 \
	DISPLAY_HEIGHT=768

RUN echo "http://dl-3.alpinelinux.org/alpine/edge/main/" >> /etc/apk/repositories \
 && echo "http://dl-3.alpinelinux.org/alpine/edge/community/" >> /etc/apk/repositories \
 && apk --update --upgrade --no-cache  add \
    libressl3.8-libcrypto libressl3.8-libssl \
    build-base python3-dev python3 libffi-dev libressl-dev \
	bash \
	fluxbox \
	git \
	socat \
	supervisor \
	x11vnc \
	xvfb
#	xterm

RUN ln -s /usr/bin/python3 /usr/bin/python || true

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

#USER nobody

EXPOSE 8080
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
