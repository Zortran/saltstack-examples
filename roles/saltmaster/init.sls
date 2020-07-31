salt-master-conf:
  file.managed:
    - names:
      - /etc/salt/master:
        - source: salt://{{ slspath }}/files/master
      - /etc/salt/roster:
        - source: salt://{{ slspath }}/files/roster
salt-master-dirs:
  file.directory:
    - file_mode: "0660"
    - dir_mode: "2770"
    - user: root
    - group: sudo
    - names:
      - /var/log/salt
    - recurse:
      - user
      - group
      - mode

salt-master:
  service.running:
    - watch:
      - file: /etc/salt/master

salt-ssh:
  pkg.installed: []