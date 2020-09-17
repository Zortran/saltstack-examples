{{ grains.id }}_nginx-stub:
  file.managed:
    - name: /etc/nginx/conf.d/stub.conf
    - source: salt://{{ slspath }}/files/stub.conf
    - mode: "0644"
    - user: root
    - group: root
    - makedirs: True
  cmd.wait:
    - name: service nginx reload
    - on_changes:
      - file: /etc/nginx/conf.d/stub.conf
    