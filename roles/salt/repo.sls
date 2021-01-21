saltstack-repo:
  pkgrepo.managed:
    - humanname: SaltStack repo
{% if grains.os_family == "RedHat" %}
    - mirrorlist: https://repo.saltstack.com/py3/redhat/{{ grains.osmajorrelease }}/$basearch/latest
    - file: /etc/yum.repos.d/salt-py3-latest.repo
    - key_url: https://repo.saltstack.com/py3/redhat/{{ grains.osmajorrelease }}/$basearch/latest/SALTSTACK-GPG-KEY.pub
{% elif grains.os == "Ubuntu" %}
    - name: deb http://repo.saltstack.com/py3/{{ grains.os|lower }}/{{ grains.osrelease }}/amd64/latest {{ grains.oscodename|lower }} main
    - file: /etc/apt/sources.list.d/saltstack.list
    - key_url: https://repo.saltstack.com/py3/{{ grains.os|lower }}/{{ grains.osrelease }}/amd64/latest/SALTSTACK-GPG-KEY.pub
{% elif grains.os == "Debian" %}
    - name: deb http://repo.saltstack.com/py3/{{ grains.os|lower }}/{{ grains.osmajorrelease }}/amd64/latest {{ grains.oscodename|lower }} main
    - file: /etc/apt/sources.list.d/saltstack.list
    - key_url: https://repo.saltstack.com/py3/{{ grains.os|lower }}/{{ grains.osmajorrelease }}/amd64/latest/SALTSTACK-GPG-KEY.pub
{% endif %}

{% if grains.os_family == "Debian" %}
apt-https-pkg:
    pkg.installed:
        - pkgs:
            - apt-transport-https
        - require_in:
            pkgrepo: saltstack-repo
{% endif %}