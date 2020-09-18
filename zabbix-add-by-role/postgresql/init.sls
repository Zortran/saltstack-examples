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
  file.recurse:
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
    - user: postgres
{%- if salt.pkg.version_cmp(salt.cmd.run('ls -1 /etc/postgresql'),"10") == 1 %}
    - groups: pg_monitor
{%- else %}
{{ grains.id }}_{{ sls }}-user-privileges:
  postgres_privileges.present:
    - name: zbx_monitor
    - prepend: pg_catalog
    - object_name: pg_stat_database
    - object_type: table
    - privileges:
      - SELECT
    - user: postgres
{%- endif %}

{%- set lines = { "1":"host all zbx_monitor 127.0.0.1/32 trust",
                 "2":"host all zbx_monitor ::1/64 trust",
                 "3":"host all zbx_monitor 0.0.0.0/0 md5",
                 "4":"host all zbx_monitor ::0/0 md5" } %}
{%- for num, line in lines.items() %}
{{ grains.id }}_{{ sls }}-user_access-line{{ num }}:
    file.replace:
    - name: /etc/postgresql/{{ salt.cmd.run('ls -1 /etc/postgresql') }}/main/pg_hba.conf
    - pattern: '{{ line }}'
    - repl: '{{ line }}'
    - prepend_if_not_found: true
    - on_changes_in:
      - file: {{ grains.id }}_{{ sls }}-pgctl-apply
{%- endfor %}

{{ grains.id }}_{{ sls }}-pgctl-apply:
  cmd.wait:
    - name: sudo -u postgres psql -U postgres -c 'SELECT pg_reload_conf();'
