# Datasets

Sample YAML fields:

```yaml
---
title: Dataset Sample Full Fields
date: 2023-05-27
description: Duis mollis, est non commodo luctus, nisi erat porttitor ligula, eget lacinia odio sem nec elit
categories:
  - environment
  - lorem
  - testing
primaryCtaUrl: "#"
primaryCtaCaption: "File size: 246kb"
primaryLinks:
  - text: "R Package"
    href: "#"
  - text: "Data History"
    href: "#"
author:
- id: jc
- id: jd
- name: "Edmund Choi"
  bio: "Testing bio and author overrides"
citation: 
  author: "Choi. Y & Lee, Y."
  container-title: "Ednel: A large – scale hierarchical dataset in education"
  doi: 10.5555/12345678
---
```

## Required fields:

- `description` - {String} Used in card previews and metadata
- `date` - {Date} format YYYY-MM-DD, time is optional
- `categories` - {Array} lowercase names of resource categories, used for filtering

## Optional fields (unique):

- `primaryCtaUrl` - {String (url)} - main link for dataset. Can be internal or external.
- `primaryCtaLabel` - {String} small label underneath CTA. Intended for descriptors like 'filesize', but could be used for other purposes.
- `primaryLinks` - {Object} text/href/icon for a button link in top section. Icon name must match available file in `_includes/svg/`

## Optional fields (shared):

- `featured` - {Boolean} Used on Story index page to pull items to the top
- `featuredOrder` - {Number} Number for determining ordering for featured entries.

## Author and Citation

See the main readme for author and citation documentation.
