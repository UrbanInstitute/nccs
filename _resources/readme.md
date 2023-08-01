## Resource

A multi-purpose content collection

### Sample Resource YAML Header

Fields that Jekyll will look for in a Resource entry.

```yaml
---
title: Project Sample
description: Sed posuere consectetur est at lobortis duis mollis, est non commodo luctus, nisi erat porttitor ligula, eget lacinia odio sem nec elit.
date: 2023-05-01
featured: true
featuredOrder: 1
type: project
categories:
  - cat
  - dog
  - stilton
author:
  - id: jd
  - id: ar
abstract: 
  - Elit excepturi cupiditate optio eligendi est? **Officia porro** architecto amet temporibus ratione. Dolorum vel [repellat ipsum](#) ipsam commodi accusantium? Eveniet quis alias exercitationem maxime vel, est quas Quaerat laborum quia.
  - Lorem soluta laborum omnis quae excepturi. Sit nisi qui iure inventore ab. Soluta voluptatibus odit libero blanditiis optio. Cumque voluptatem molestias ex fugit praesentium. Rem temporibus ex quidem rerum in.
primaryLinks:
  - text: Testing
    href: https://www.google.com/
    icon: pdf
  - text: More testing
    href: https://duckduckgo.com/
    icon: download
citation: 
  container-title: Journal of Psychoceramics
  volume: 1
  issue: 1
  doi: 10.5555/12345678
---

```

## Required fields:

- `description` - {String} Used in card previews and metadata
- `date` - {Date} format YYYY-MM-DD, time is optional
- `type` - {String} lowercase name of resource type, used for filtering, displays in 'eyebrow' text
- `categories` - {Array} lowercase names of resource categories, used for filtering

## Optional fields (unique):

- `abstract` - {String|Array} Paragraphs for abstract section, allows markdown content
- `primaryLinks` - {Object} text/href/icon for a button link in top section. Icon name must match available file in `_includes/svg/`

## Optional fields (shared):

- `featured` - {Boolean} Used on Resource index page to pull items to the top
- `featuredOrder` - {Number} Number for determining ordering for featured entries. Recommended max = 4

## Author and Citation

See the main readme for author and citation documentation.
