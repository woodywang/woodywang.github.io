export const zh = {
  site_tagline: "一个关于技术与生活的思考实验场",
  site_tagline_en: "A sandbox for thoughts on technology and life",
  about_heading: "关于",
  bio_text:
    "我是 Woody，一个热爱技术和编程的全栈开发者。我相信代码不仅是工具，更是一种创造性的表达方式。这里是我的数字沙盒，记录技术探索和生活感悟。",
  cta_button: "进入博客",
  cta_url: "https://blog.brainsandbox.com",
  copyright: "Brain Sandbox. All rights reserved.",
  meta_title: "Brain Sandbox - 一个关于技术与生活的思考实验场",
  meta_description:
    "一个关于技术与生活的思考实验场。探索技术、记录生活、分享知识。",
  lang_switch_label: "EN",
  lang_switch_url: "/en/",
};

export const en = {
  site_tagline: "A sandbox for experiments in tech and life",
  site_tagline_en: "",
  about_heading: "About",
  bio_text:
    "I'm Woody, a full-stack developer who loves technology and programming. I believe code is not just a tool but a form of creative expression. This is my digital sandbox, where I document technical explorations and life reflections.",
  cta_button: "Enter Blog",
  cta_url: "https://blog.brainsandbox.com/en/",
  copyright: "Brain Sandbox. All rights reserved.",
  meta_title: "Brain Sandbox - A sandbox for experiments in tech and life",
  meta_description:
    "A sandbox for experiments in tech and life. Exploring technology, documenting life, sharing knowledge.",
  lang_switch_label: "中文",
  lang_switch_url: "/",
};

export type Translations = typeof zh;

export function getTranslations(lang: "zh" | "en"): Translations {
  return lang === "en" ? en : zh;
}
