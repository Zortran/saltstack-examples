{{ grains.id }}-grains:
  grains.list_present:
    - names:
      - roles:
        - value:
          - saltmaster
          - gate

include:
  - roles/saltmaster
  - roles/gate