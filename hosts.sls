{% include 'servers/' + salt['grains.get']('host') ignore missing %}
{% include 'os/' + salt['grains.get']('os')+ '/init.sls' ignore missing %}
{% set textstr = 'DCA-SOME-0001-V' %}
test-sring-cut:
  test.show_notification:
{%- if (textstr | regex_search('^CLI-(.*)-.*-V.*', ignorecase=True)) %}
    - text: "{{ (textstr | regex_search('^CLI-(.*)-.*-V.*', ignorecase=True))[0] }}"
{%- else %}
    - text: 'No string'
{% endif %}
