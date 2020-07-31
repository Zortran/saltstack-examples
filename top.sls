test:
    '*':
        - common
        {%- for role in salt['grains.get']('roles',[]) %}
            {%- if salt.state.sls_exists('roles.'+role) %}
        - roles.{{ role }}
            {%- endif %}
        {%- endfor %}
        {%- if salt.state.sls_exists('vm.'+ grains.id|lower) %}
        - vm.{{ grains.id|lower }}
        {%- endif %}
        {%- if salt.state.sls_exists('os.'+ grains.kernel|lower) %}
        - os.{{ grains.kernel|lower }}
        {%- endif %}
        {%- if salt.state.sls_exists('os.'+ salt['grains.get']('os_family','')|lower) %}
        - os.{{ grains.os_family|lower }}
        {%- endif %}
        {%- if salt.state.sls_exists('os.'+ salt['grains.get']('osfinger','')|regex_replace("\.|\ ","")|lower) %}
        - os.{{ grains.osfinger|regex_replace("\.|\ ","")|lower }}
        {%- endif %}
        