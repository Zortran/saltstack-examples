{%- if grains.os_family == "Debian" %}
{%- set aptproxy = "proxy-srv" %}
apt-proxy:
  file.managed:
    - name: /etc/apt/apt.conf.d/apt-proxy
    - source: salt://{{ slspath }}/files/apt-proxy.j2
    - template: jinja
    - context:
      sls: {{ sls }}
      proxy: {{ aptproxy if grains.id != aptproxy else "127.0.0.1" }}
base packages:
  pkg.latest:
    - refresh: true
    - pkgs:
      - dos2unix
      - mc
      - htop
      - iftop
      - iotop
      - tree
      - wget
      - curl
      - vim
      - gnupg
      - apt-transport-https
      - dnsutils
{%- endif %}

{%- if grains.kernel == "Linux" %}
avaible_locales:
  locale.present:
    - names:
      - en_US.UTF-8
      - ru_RU
      - ru_RU.UTF-8

default_locale:
  locale.system:
    - name: en_US.UTF-8
    - require:
      - locale: avaible_locales
{%- endif %}