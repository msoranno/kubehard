
{% if grains['os'] == 'Ubuntu' %}
{% set os_distro = salt['cmd.shell']('lsb_release -cs') %}
dockerneeds:
  pkg.installed:
    - pkgs:
      - apt-transport-https
      - ca-certificates
      - curl
      - software-properties-common
  pkgrepo.managed:
    - humanname: Docker
    - name: deb [arch=amd64] https://download.docker.com/linux/ubuntu {{ os_distro }} stable
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

