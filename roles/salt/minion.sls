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
    - enable: true

Restart Salt Minion:
  cmd.run:
{%- if grains['kernel'] == 'Windows' %}
    - name: 'C:\salt\salt-call.bat service.restart salt-minion'
{%- else %}
    - name: 'salt-call service.restart salt-minion'
{%- endif %}
    - bg: True
    - onchanges:
      - pkg: salt-minion-base
      - file: salt-minion-base