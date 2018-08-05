{% if grains['os'] == 'CentOS' %}
dockerneeds:
  pkg.installed:
    - pkgs:
      - apt-transport-https
      - ca-certificates
      - curl
      - software-properties-common
{% endif %}

