## HTML Assets for RMD Docs

This folder contains some HTML assets helpful for creating clean HTML files with some Urban branding elements. 

You can add header.html, footer.html, and CSS elements as part of the RMD file YAML header: 


```
---
title: "Estimating Sector Size Using Payroll Taxes"
output:
  html_document:
    theme: readable
    df_print: paged
    highlight: tango
    toc: true
    self_contained: true
    number_sections: false
    css: clean.css
    include:
      before_body: header.html
      after_body: footer.html
---
```

These files can be adapted as needed. 

## dot GitIgnore Files

The .gitignore file contains a lot of nuissance filetypes that are created while building tutorials and vignettes using R Markdown files. 

For example, adding caching to a chunk can save a lot of time when you are in the process of drafting files. 

