# Alpine X11 Display Container

One uses this image as a companion image for X11 programs
It does not stand on its own.


# Contents

* [Xvfb](http://www.x.org/releases/X11R7.6/doc/man/man1/Xvfb.1.xhtml) - X11 in a virtual framebuffer
* [x11vnc](http://www.karlrunge.com/x11vnc/) - A VNC server that scrapes the above X11 server
* [noNVC](https://kanaka.github.io/noVNC/) - A HTML5 canvas vnc viewer
* [Fluxbox](http://www.fluxbox.org/) - a small window manager
* [socat](http://www.dest-unreach.org/socat/) - for use with other containers
* [supervisord](http://supervisord.org) - to keep it all running

## Usage

Easiest is to use it in a docker compose file like the one below

```yaml
version: '3'

services:
  x11:
    image: ivonet/x11novnc:latest
    environment:
      - DISPLAY_WIDTH=1024
      - DISPLAY_HEIGHT=768
    ports:
      - 8080:8080
  ide:
    image: ivonet/intellij:latest
    environment:
      - DISPLAY=x11:0.0
    volumes:
      - ./projects:/projects
    depends_on:
      - novnc
```

* No access through [http://localhost:8080](http://localhost:8080)
