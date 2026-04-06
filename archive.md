---
layout: default
title: 所有文章
permalink: /archive/
lang: zh-CN
---

# 所有文章

{% assign posts_by_year = site.posts | group_by_exp: "post", "post.date | date: '%Y'" %}
{% for year in posts_by_year %}
## {{ year.name }} 年

{% for post in year.items %}
- **{{ post.date | date: "%m月%d日" }}** — [{{ post.title }}]({{ post.url | relative_url }})
  {% if post.categories.size > 0 %}{% for category in post.categories %}<span class="category">{{ site.category_display[site.active_lang][category] | default: category }}</span> {% endfor %}{% endif %}

{% endfor %}
{% endfor %}
