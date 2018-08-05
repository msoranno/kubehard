dockerneeds:
  {% if grains['os'] == 'CentOS' %}
  pkg.installed:
    - pkgs:
      - apt-transport-https
      - ca-certificates
      - curl
      - software-properties-common
  {% endif %}

