# docker CE for ubuntu18 and centos7.5

{% set gpg = {
    'CentOS': 'not defined',
    'Ubuntu': 'https://download.docker.com/linux/ubuntu/gpg',
    }.get(grains.os) %}


{% set repo = {
    'CentOS': '"Not Defined"',
    'Ubuntu': '"deb [arch=amd64] https://download.docker.com/linux/ubuntu"',
    }.get(grains.os) %}


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
    - name: {{ repo }} {{ os_distro }} stable
    - file: /etc/apt/sources.list.d/docker.list
    - gpgcheck: 1
    - key_url: {{ gpg }}

docker-ce:
  pkg.latest: []
  require:
    - pkgrepo: dockerneeds
    - pkg: dockerneeds
  service.running:
    - name: docker
    - enable: True
    - restart: True
{% endif %}

