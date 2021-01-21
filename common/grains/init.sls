{# Forming list of roles by installed pkgs #}
{% import_yaml "./role_list.yaml" as role_list %}
{%- set roles_present = [] %}
{%- set roles_absent = [] %}
{%- for role, pkgs in role_list.items() %}
  {%- for pkg in pkgs %}
    {%- if salt['pkg.version'](pkg) %}
      {%- do roles_present.append(role) %}
      {%- break %}
    {%- else %}
      {%- do roles_absent.append(role) %}
    {%- endif %}
  {%- endfor %}
{%- endfor %}
{%- if roles_present %}
grains-present:
  grains.list_present:
    - name: roles
    - value: {{ roles_present|unique }}
{%- endif -%}
{%- if roles_absent|difference(roles_present) %}
grains-absent:
  grains.list_absent:
    - name: roles
    - value: {{ roles_absent|difference(roles_present)|unique }}
{%- endif -%}
{# debug-message:
  test.show_notification:
    - text: "present: {{ roles_present|join(',') }} \nabsent: {{ roles_absent|difference(roles_present)|join(',') }}"
#}
