apt-cacher-ng:
  pkg.latest: []
  file.managed:
    - names:
      - /etc/apt-cacher-ng/acng.conf:
        - source: salt://{{ slspath }}/files/acng.conf.jinja
    - require:
      - pkg: apt-cacher-ng
    - template: jinja
    - context:
      sls: {{ sls }}
    - require_in:
      - file: /etc/apt/apt.conf.d/apt-proxy
  service.running:
    - watch:
      - file: /etc/apt-cacher-ng/acng.conf
    - require:
      - file: /etc/apt-cacher-ng/acng.conf