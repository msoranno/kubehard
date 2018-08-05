dockerneeds:
  pkg.installed:
  {% if grains['os'] == 'CentOS' %}
      - name: apt-transport-https
      - name: ca-certificates
      - name: curl
      - name: software-properties-common
  {% endif %}

