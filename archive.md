---
layout: default
title: 所有文章
permalink: /archive/
---

# 所有文章

{% for post in site.posts %}
### [{{ post.title }}]({{ post.url | relative_url }})
*{{ post.date | date: "%Y年%m月%d日" }}*
{% if post.categories.size > 0 %}
{% for category in post.categories %}
<span class="category">{{ site.category_display[category] | default: category }}</span>
{% endfor %}
{% endif %}

{{ post.excerpt | strip_html | truncate: 120 }}

[继续阅读 →]({{ post.url | relative_url }})

---
{% endfor %}
