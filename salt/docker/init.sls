neededs:
  pkg.installed:
    {% if grains['os'] == 'CentOS'%}
    - pkgs:
      - apt-transport-https
      - ca-certificates
      - curl
      - software-properties-common
    {% endif %}

