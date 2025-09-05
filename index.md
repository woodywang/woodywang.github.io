---
layout: default
---

# 欢迎来到 Brain Sandbox

> 一个关于技术与生活的思考实验场

## 关于这个空间

这里是我的数字沙盒，一个记录技术探索和生活感悟的地方。在这里，你会发现：

- **技术实验** - 各种技术栈的探索和实践
- **开发笔记** - 编程技巧、工具使用和问题解决
- **架构思考** - 系统设计和架构模式的讨论
- **生活感悟** - 工作与生活平衡的思考

## 最近的文章

{% for post in site.posts limit:5 %}
### [{{ post.title }}]({{ post.url | relative_url }})
*{{ post.date | date: "%Y年%m月%d日" }}*

{{ post.excerpt }}

[继续阅读 →]({{ post.url | relative_url }})

---
{% endfor %}

{% if site.posts.size == 0 %}
*即将更新 - 敬请期待第一篇文章！*
{% elsif site.posts.size > 5 %}
[查看所有文章 →](/archive/)
{% endif %}

## 联系我

如果你有任何想法或建议，欢迎通过以下方式联系我：

{% if site.github_username %}
- GitHub: [@{{ site.github_username }}](https://github.com/{{ site.github_username }})
{% endif %}
{% if site.twitter_username %}
- Twitter: [@{{ site.twitter_username }}](https://twitter.com/{{ site.twitter_username }})
{% endif %}

---

*欢迎来到沙盒。随意探索，打破常规，学点新东西。*