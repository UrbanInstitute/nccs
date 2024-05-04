## Adding Reference Sections to Pages

These files are used to add reference sections or bibliographies to project pages. 

The R Markdown file **bibliography.rmd** generates the bibliography from the BibTex file called **references.bib**.

The output is specifically an **html_fragment** instead of **html_document** so that the output can be added directly to a page using the jekyll function: 

For example, to insert the bibliography created from **ref-section-nptrends.rmd** add: 
```
{% include bib/bibliography/ref-section-nptrends.html %}
```

## Updating References

In order to refresh the database you need to visit Google scholar pages for project publications. 

For example, the first major report for the Nonprofit Trends project is at: 

https://scholar.google.com/scholar?start=0&hl=en&as_sdt=20000005&sciodt=1,21&cites=1166513345463666613&scipsc=

Export all of the citations to Zotero (or another reference manager, but Zotero is free). 

It is easier to use the Zotero Connect plugin because you can select many citations at once: 

https://guides.library.illinoisstate.edu/zotero/adding/resultslist

Replace the **references.bib** file with the updated version and the re-run the **bibliography.rmd** file. 

Sync the updated **bibliography.html** to GitHub and the references will refresh. 

## Style Sheet

Note that the following elements are needed to ensure publications are formatting correctly. These are located in **public/scss/components/_bibliography.scss**.  

```
<style>
/* BIBLIOGRAPHY ITEMS */

div.csl-bib-body { }

div.csl-entry {
  margin-left:2em;
  text-indent:-2em;
  margin-bottom: 10px;
  font-size: calc(0.8em + 0.15vw);
}

div.csl-left-margin {
  min-width:2em;
  float:left;
}

div.csl-right-inline {
  margin-left:2em;
  padding-left:1em;
}

div.csl-indent {
  margin-left: 2em;
}

div.cite {
  margin-left:2em;
  text-indent:-2em;
  margin-bottom: 20px;
}

</style>
```
