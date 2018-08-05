
{% if grains['os'] == 'CentOS' %}
dockerneeds:
  pkg.installed:
    - pkgs:
      - apt-transport-https
      - ca-certificates
      - curl
      - software-properties-common
  pkgrepo.managed:
    - humanname: Docker
    # El 'Core' lo hemos determinado con "lsb_release -cs"
    - name: deb [arch=amd64] https://download.docker.com/linux/ubuntu Core stable
    - file: /etc/apt/sources.list.d/docker.list
    - gpgcheck: 1
    - key_url: https://download.docker.com/linux/ubuntu/gpg

docker-ce:
  pkg.latest: []
  require:
    - dockerneeds
  service.running:
    - name: docker
    - enable: True
    - restart: True
{% endif %}

