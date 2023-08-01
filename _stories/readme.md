# Stories

Sample YAML fields:

```yaml
---
title: Story Sample
date: 2023-05-29
description: Amet amet maxime sit neque cumque Maxime explicabo maxime est accusamus exercitationem ad Dolor nulla ipsum rem nemo ab deserunt eligendi quas hic Quo impedit vel perspiciatis quam.
image: stories/story-placeholder.webp
featured: true
featuredOrder: 1
type: test
categories:
  - flamingos
  - zebras
  - antelopes
author:
  - id: mr
  - id: jd
  - id: jc
citation: 
  container-title: Journal of Psychoceramics
  volume: 1
  issue: 1
  doi: 10.5555/12345678
links:
  - header: Data
    links:
    - text: Test
      href: #
      icon: download
  - header: Customs
    links:
    - text: View Data
      href: #
      icon: download
---
```

## Required fields:

- `description` - {String} Used in card previews and metadata
- `date` - {Date} format YYYY-MM-DD, time is optional
- `type` - {String} lowercase name of resource type, used for filtering, displays in 'eyebrow' text
- `categories` - {Array} lowercase names of resource categories, used for filtering

## Optional fields (unique):

- `image` - {String} Path from `public/img` to use as a featured image. This is also used in the 'Content Feature' component.
- `links` - {Object} text/href/icon for a button link in top section. Icon name must match available file in `_includes/svg/`

## Optional fields (shared):

- `featured` - {Boolean} Used on Story index page to pull items to the top
- `featuredOrder` - {Number} Number for determining ordering for featured entries. Recommended max = 3 or 2 if using images.

## Author and Citation

See the main readme for author and citation documentation.
