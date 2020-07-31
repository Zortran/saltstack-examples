include:
  - .repo

salt-minion-base:
  pkg.installed:
    - name: salt-minion
    - require:
      - pkgrepo: saltstack-repo
    - require_in:
      - file: salt-minion-base
      - service: salt-minion
  file.managed:
    - template: jinja
    - names:
      - /etc/salt/minion:
        - source: salt://{{ slspath }}/files/minion.jinja
        - context:
          sls: "{{ sls }}"
  service.running:
    - name: salt-minion
    - restart: true
    - watch:
      - file: salt-minion-base
