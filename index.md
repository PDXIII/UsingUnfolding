---
layout: default
title: UsingUnfolding
teaser: GeoViz
---


This is a tutorial about using the [Unfolding library][Unfolding library] for [Processing][Processing] by [Till Nagel][Till Nagel].


##GeoJSONApp
These tutorials cover the use of [GeoJSON][GeoJSON] files with [Unfolding][Unfolding library]. We will build a map showing us the airports of any country we point with the mouse at. Therefore we are going to use two files of the type [GeoJSON][GeoJSON].

<ul>

{% for page in site.pages %}
{% if page.category == 'GeoJSONApp' %}
    <li><a href="/UsingUnfolding{{ page.url }}">{{ page.title }}</a></li>
{% endif %}
{% endfor %}
</ul>


{% include linklist.md %}
