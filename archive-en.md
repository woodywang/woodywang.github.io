---
layout: default
title: All Posts
permalink: /archive/
lang: en
---

# All Posts

{% assign posts_by_year = site.posts | group_by_exp: "post", "post.date | date: '%Y'" %}
{% for year in posts_by_year %}
## {{ year.name }}

{% for post in year.items %}
- **{{ post.date | date: "%b %d" }}** — [{{ post.title }}]({{ post.url | relative_url }})
  {% if post.categories.size > 0 %}{% for category in post.categories %}<span class="category">{{ site.category_display[site.active_lang][category] | default: category }}</span> {% endfor %}{% endif %}

{% endfor %}
{% endfor %}
