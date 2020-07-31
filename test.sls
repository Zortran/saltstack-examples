{% if salt['pkg.version']('postgresql')  %}
show msg:
  test.show_notification:
    - text: Found {{ salt.pkg.version('postgresql') }}
{% endif %}
