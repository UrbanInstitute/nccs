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

The author and citation fields have been built to follow the [Quarto Citation](https://quarto.org/docs/authoring/create-citeable-articles.html) formats.

The simplest version of the citation is to set it as:

`citation: true`

Which will cause all default fields to be used. But for customization, refer to the following fields:

- `author` - {Array} - Used in citation and author information
  - `id` - {String} (Preferred) uses the id of an author defined in `_data/people.yml` to populate fields.
  - `name` - {String} (Override) If no `id`, this field can provide an override that works to show in the author section AND citation information for the specified author. However, this will not correctly format the citation in the Chicago Author-Date style if this is the first listed author. See `citation.author`
  - `bio` - {String} (Override) Allows override of bio section. Useful if the author is not in `_data/people.yml`.
- `citation` - {Array}
  - `author` - {String} (Override) Will override all `author` fields and allow custom formatting. Intended for use if authors are not in the `_data/people.yml` file.
  - `container-title` - {String} Title of publication. If left blank, it will revert to the site name in `_config.yml`
  - `volume` - {Number} Volume of publication
  - `number` - {Number} Number of publication
- `citationData` - {Date}
