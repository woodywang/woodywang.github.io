---
layout: home
lang: en
permalink: /
---

# Welcome to Brain Sandbox

> A sandbox for experiments in tech and life

## About This Space

This is my digital sandbox, a place to document technical explorations and life reflections. Here you will find:

- **Tech Experiments** - Exploring and practicing with various tech stacks
- **Dev Notes** - Programming tips, tool usage, and problem solving
- **Architecture Thoughts** - Discussions on system design and architecture patterns
- **Life Reflections** - Thoughts on work-life balance

## Recent Posts

{% for post in site.posts limit:5 %}
### [{{ post.title }}]({{ post.url | relative_url }})
*{{ post.date | date: "%B %d, %Y" }}*

{{ post.excerpt }}

[Read more →]({{ post.url | relative_url }})

---
{% endfor %}

{% if site.posts.size == 0 %}
*Coming soon - stay tuned for the first post!*
{% elsif site.posts.size > 5 %}
[View all posts →](/archive/)
{% endif %}

## Contact

If you have any thoughts or suggestions, feel free to reach out:

{% if site.github_username %}
- GitHub: [@{{ site.github_username }}](https://github.com/{{ site.github_username }})
{% endif %}
{% if site.twitter_username %}
- Twitter: [@{{ site.twitter_username }}](https://twitter.com/{{ site.twitter_username }})
{% endif %}

---

*Welcome to the sandbox. Feel free to explore, break conventions, and learn something new.*
