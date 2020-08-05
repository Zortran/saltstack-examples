{{ sls }}-Pkgs:
  pkg.installed:
    - names:
      - python-pip
      - git

/etc/pip.conf:
  file.managed:
    - source: salt://{{ slspath }}/files/pip.conf