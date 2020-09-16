{{ grains.id }}_{{ sls }}-conf:
  file.managed:
    - names:
      - /etc/zabbix/zabbix_agentd.d/template_db_postgresql.conf:
        - source: salt://{{ slspath }}/files/template_db_postgresql.conf
    - mode: "0644"
    - makedirs: True
    - user: root
    - group: root
    - watch_in:
      - service: zabbix-agent

{{ grains.id }}_{{ sls }}-sqlscripts:
  file.directory:
    - name: /var/lib/zabbix/postgresql/
    - source: salt://{{ slspath }}/files/postgresql
    - dir_mide: "0755"
    - file_mode: "0644"
    - makedirs: True
    - user: root
    - group: root
    - watch_in:
      - service: zabbix-agent

{{ grains.id }}_{{ sls }}-user:
  postgres_user.present:
    - name: zbx_monitor
    - groups: pg_monitor

{% set lines = { "1":"host all zbx_monitor 127\.0\.0\.1\/32 trust",
                 "2":"host all zbx_monitor \:\:1\/64 trust",
                 "3":"host all zbx_monitor 0\.0\.0\.0\/0 md5",
                 "4":"host all zbx_monitor \:\:0\/0 md5" } %}
{% for num, line in lines.items()%}
{{ grains.id }}_{{ sls }}-user_access-line{{ num }}:
    file.replace:
    - name: /etc/postgresql/12/main/pg_hba.conf
    - pattern: '({{ line }})'
    - repl: '\1'
    - append_if_not_found: true
{% endfor %}
