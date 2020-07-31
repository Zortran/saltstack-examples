net.ipv4.ip_forward:
  sysctl.present:
    - value: 1

iptables-rules1:
  iptables.append:
    - table: nat
    - chain: POSTROUTING
    - jump: MASQUERADE
    - out-interface: eth0
    - save: true
iptables-rules2:
  iptables.append:
    - chain: FORWARD
    - jump: ACCEPT
    - match: state
    - in-interface: eth0
    - out-interface: eth1
    - connstate: RELATED,ESTABLISHED
    - save: True
iptables-rules3:
  iptables.append:
    - chain: FORWARD
    - jump: ACCEPT
    - in-interface: eth1
    - out-interface: eth0
    - save: True

dnsmasq:
  pkg.installed: []
  file.managed:
    - template: jinja
    - names:
      - /etc/dnsmasq.conf:
        - source: salt://{{ slspath }}/files/dnsmasq.conf
      - /etc/resolv.conf:
        - source: salt://{{ slspath }}/files/resolv.conf
    - require:
      - pkg: dnsmasq
  service.running:
    - watch:
      - file: dnsmasq
      - file: /etc/hosts
    - require:
      - pkg: dnsmasq

apt-cacher-ng:
  pkg.installed: []
  file.managed:
    - names:
      - /etc/apt-cacher-ng/acng.conf:
        - source: salt://{{ slspath }}/files/acng.conf
    - require:
      - pkg: apt-cacher-ng
  service.running:
    - watch:
      - file: /etc/apt-cacher-ng/acng.conf
    - require:
      - file: /etc/apt-cacher-ng/acng.conf

apt-proxy:
  file.managed:
    - name: /etc/apt/apt.conf.d/apt-proxy
    - source: salt://{{ slspath }}/files/apt-proxy
    - require:
      - file: /etc/apt-cacher-ng/acng.conf

/etc/hosts:
  file.managed:
    - source: salt://{{ slspath }}/files/hosts

/etc/network/if-pre-up.d/iptables:
  file.managed:
    - mode: "0755"
    - source: salt://{{ slspath }}/files/iptables
    - makedirs: True