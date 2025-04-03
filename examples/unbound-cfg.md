version: '3'
services:
  unbound:
    container_name: unbound
    image: "mvance/unbound:latest"
    expose:
      - "53"
    networks:
      - dns
    ports:
      - "53:53/tcp"
      - "53:53/udp"
    volumes:
      - "/data/unbound/my_conf/forward-records.conf:/opt/unbound/etc/unbound/forward-records.conf"
      - "/data/unbound/my_conf/a-records.conf:/opt/unbound/etc/unbound/a-records.conf"
    restart: unless-stopped
networks:
  dns: