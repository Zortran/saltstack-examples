include:
  - .repo

salt-master-base:
  pkg.installed:
    - name: salt-master
    - require:
      - pkgrepo: saltstack-repo
    - require_in:
      - file: salt-master-base
      - service: salt-master
  file.managed:
    - template: jinja
    - names:
      - /etc/salt/master:
        - source: salt://{{ slspath }}/files/master.jinja
        - context:
          sls: "{{ sls }}"
  service.running:
    - name: salt-master
    - restart: true
    - watch:
      - file: salt-master-base

salt-master-dirs:
  file.directory:
    - names:
      - /srv/saltstack/base
      - /srv/saltstack/formulas
      - /srv/saltstack/test
      - /srv/saltstack/pillar:
        - dir_mode: "2770"
        - file_mode: "0660"
        - recurse:
          - group
          - mode
    - dir_mode: "2775"
    - file_mode: "0664"
    - group: sudo
    - exclude_pat: ".git"