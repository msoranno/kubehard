dockerneeds:
  pkg.installed:
    - pkgs:
  {% if grains['os'] == 'CentOS' %}
      - apt-transport-https
      - ca-certificates
      - curl
      - software-properties-common
  {% endif %}

