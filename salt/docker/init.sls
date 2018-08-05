dockerneeds:
  pkg.installed:
  {% if grains['os'] == 'CentOS' %}
      - name: apt-transport-https
  {% endif %}

