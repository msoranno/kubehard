# docker CE for ubuntu18 and centos7.5

{% set gpg = {
    'CentOS': 'not defined',
    'Ubuntu': 'https://download.docker.com/linux/ubuntu/gpg',
    }.get(grains.os) %}


{% set repo = {
    'CentOS': 'https://download.docker.com/linux/centos/docker-ce.repo',
    'Ubuntu': 'deb [arch=amd64] https://download.docker.com/linux/ubuntu',
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
    - name: "{{ repo }} {{ os_distro }} stable"
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



{% if grains['os'] == 'CentOS' %}
dockerneeds:
  pkg.installed:
    - pkgs:
      - yum-utils
      - device-mapper-persistent-data
      - lvm2
      - curl

yum-config-manager --add-repo {{ repo }}:
  cmd.run:
    - require:
        - pkg: dockerneeds

docker-ce:
  pkg.latest: []
  require:
    - pkg: dockerneeds
  service.running:
    - name: docker
    - enable: True
    - restart: True
{% endif %}