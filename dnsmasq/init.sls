# -*- coding: utf-8 -*-
# vim: ft=sls
---
{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as dnsmasq with context %}

{%- if salt['pillar.get']('dnsmasq:dnsmasq_conf') %}
dnsmasq_conf:
  file.managed:
    - name: {{ dnsmasq.dnsmasq_conf }}
    - source: {{ salt['pillar.get']('dnsmasq:dnsmasq_conf', 'salt://dnsmasq/files/dnsmasq.conf') }}
    - user: root
    - group: {{ dnsmasq.group }}
    - mode: 644
    - template: jinja
    - require:
      - pkg: dnsmasq
{%- if salt['pillar.get']('dnsmasq:dnsmasq_hosts') %}
    - context:
        addn_hosts: {{ dnsmasq.dnsmasq_hosts }}
{%- endif %}

dnsmasq_conf_dir:
  file.recurse:
    - name: {{ dnsmasq.dnsmasq_conf_dir }}
    - source: {{ salt['pillar.get']('dnsmasq:dnsmasq_conf_dir', 'salt://dnsmasq/files/dnsmasq.d') }}
    - template: jinja
    - require:
      - pkg: dnsmasq
{%- endif %}

{%- if salt['pillar.get']('dnsmasq:dnsmasq_hosts') %}
dnsmasq_hosts:
  file.managed:
    - name: {{ dnsmasq.dnsmasq_hosts }}
    - source: {{ salt['pillar.get']('dnsmasq:dnsmasq_hosts', 'salt://dnsmasq/files/dnsmasq.hosts') }}
    - user: root
    - group: {{ dnsmasq.group }}
    - mode: 644
    - template: jinja
    - require:
      - pkg: dnsmasq
    - watch_in:
      - service: dnsmasq
{%- endif %}

{%- if salt['pillar.get']('dnsmasq:dnsmasq_cnames') %}
dnsmasq_cnames:
  file.managed:
    - name: {{ dnsmasq.dnsmasq_cnames }}
    - source: {{ salt['pillar.get']('dnsmasq:dnsmasq_cnames', 'salt://dnsmasq/files/dnsmasq.cnames') }}
    - user: root
    - group: {{ dnsmasq.group }}
    - mode: 644
    - template: jinja
    - require:
      - pkg: dnsmasq
    - watch_in:
      - service: dnsmasq
{%- endif %}

{%- if salt['pillar.get']('dnsmasq:dnsmasq_addresses') %}
dnsmasq_addresses:
  file.managed:
    - name: {{ dnsmasq.dnsmasq_addresses }}
    - source: {{ salt['pillar.get']('dnsmasq:dnsmasq_addresses', 'salt://dnsmasq/files/dnsmasq.addresses') }}
    - user: root
    - group: {{ dnsmasq.group }}
    - mode: 644
    - template: jinja
    - require:
      - pkg: dnsmasq
    - watch_in:
      - service: dnsmasq
{%- endif %}

dnsmasq:
  pkg.installed:
    - name: {{ dnsmasq.package }}
  service.running:
    - name: {{ dnsmasq.service }}
    - enable: True
    - require:
      - pkg: dnsmasq
{%- if salt['pillar.get']('dnsmasq:dnsmasq_conf') %}
    - watch:
      - file: dnsmasq_conf
      - file: dnsmasq_conf_dir
{%- endif %}
