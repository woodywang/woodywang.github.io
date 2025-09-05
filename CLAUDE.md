# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Jekyll-based GitHub Pages site called "Brain Sandbox" (一个关于技术与生活的思考实验场), a bilingual blog focused on technology and life reflections. The site uses the Slate theme and is hosted at woodywang.github.io.

## Development Commands

### Local Development
- **Start development server**: `bundle exec jekyll serve`
- **Install dependencies**: `bundle install`
- **Update dependencies**: `bundle update`

### Jekyll Commands
- **Build site**: `bundle exec jekyll build`
- **Clean build artifacts**: `bundle exec jekyll clean`

## Architecture

### Site Configuration
- **Theme**: Uses `pages-themes/slate@v0.2.0` as remote theme
- **Markdown**: Kramdown with GFM parser
- **Plugins**: jekyll-feed, jekyll-remote-theme
- **Language**: Mixed Chinese/English content

### Key Files Structure
- `_config.yml`: Main Jekyll configuration with site metadata
- `index.md`: Homepage with recent posts listing
- `about.md`: About page
- `_posts/`: Blog posts directory (currently empty)
- `_includes/head-custom.html`: Custom head includes for favicon and theme color
- `favicon.svg`: Custom SVG favicon
- `404.html`: Custom error page
- `CNAME`: GitHub Pages custom domain configuration

### Content Management
- Posts should be placed in `_posts/` with Jekyll naming convention: `YYYY-MM-DD-title.md`
- Posts use YAML front matter with layout, title, date, and categories
- Homepage automatically displays the 5 most recent posts
- Site supports both Chinese and English content

### Styling
- Uses Slate theme with custom favicon and theme color (#2e7d32)
- Custom head modifications in `_includes/head-custom.html`

## Development Environment

The project includes a devcontainer configuration with:
- Ruby environment for Jekyll development
- Python and UV for additional tooling
- GitHub CLI for repository management
- Claude Code extension pre-installed