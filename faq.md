---
title: "Frequently Asked Questions"
layout: page
permalink: /faq/
activeLink: /faq/
---



**CONTENTS:**

-----------------------

<div id="toc"></div>

-----------------------




## FOR NONPROFITS 

### How Do I Select An NTEE Code For My Organization?

Nonprofits are required to select an NTEE code when applying for tax
exempt status. A full list of codes and descriptions used by the IRS can
be found
[here](https://urbaninstitute.github.io/nccs-legacy/ntee/ntee.html), a
searchable table of those same codes can be found
[here](https://nccs.urban.org/nccs/widgets/ntee_tables/ntee1_table.html),
and a concise 2-page cheat sheet can be found
[here](https://nccs.urban.org/nccs/pubs/ntee-two-page-2005.pdf).

It is the IRS and not NCCS that maintains the official database of
codes. NCCS **cannot** change or assign NTEE codes for any organization.

### How Can I Obtain An NTEE Code Or Change My Current Code?

To modify or obtain an NTEE code, an organization should send a written
request to the IRS Correspondence Unit with the relevant facts,
including the Code currently assigned, if any, and the requested Code,
as well as who selected the currently assigned Code initially, if known.

The Correspondence Unit will refer to the IRS Exempt Organizations
Divisions, if necessary, and will notify the organization if a form or
user fee is required to make the requested change. The written request
must be sent or faxed to:

Internal Revenue Service  
Attn: Correspondence Unit  
P.O. Box 2508, Room 6403  
Cincinnati, Ohio 45201  
Fax: (855) 204-6184

Express and Overnight Delivery: <br> Internal Revenue Service <br> Attn:
Correspondence Unit <br> 500 Main Street, Room 6403 <br> Cincinnati,
Ohio 45202 <br>

More details can be found [here](https://www.irs.gov/publications/p557)

## FOR DATA USERS 





<script src="https://code.jquery.com/jquery-3.3.1.min.js"></script>

<script>
// https://github.com/ghiculescu/jekyll-table-of-contents
(function($){
  $.fn.toc = function(options) {
    var defaults = {
      noBackToTopLinks: false,
      title: '<i>Jump to...</i>',
      minimumHeaders: 3,
      headers: 'h1, h2, h3, h4, h5, h6',
      listType: 'ol', // values: [ol|ul]
      showEffect: 'show', // values: [show|slideDown|fadeIn|none]
      showSpeed: 'slow', // set to 0 to deactivate effect
      classes: { list: '',
                 item: '',
                 link: ''
               }
    },
    settings = $.extend(defaults, options);

    function fixedEncodeURIComponent (str) {
      return encodeURIComponent(str).replace(/[!'()*]/g, function(c) {
        return '%' + c.charCodeAt(0).toString(16);
      });
    }

    function createLink (header) {
      var innerText = (header.textContent === undefined) ? header.innerText : header.textContent;
      return "<a class='"+settings.classes.link+"' href='#" + fixedEncodeURIComponent(header.id) + "'>" + innerText + "</a>";
    }

    var headers = $(settings.headers).filter(function() {
      // get all headers with an ID
      var previousSiblingName = $(this).prev().attr( "name" );
      if (!this.id && previousSiblingName) {
        this.id = $(this).attr( "id", previousSiblingName.replace(/\./g, "-") );
      }
      return this.id;
    }), output = $(this);
    if (!headers.length || headers.length < settings.minimumHeaders || !output.length) {
      $(this).hide();
      return;
    }

    if (0 === settings.showSpeed) {
      settings.showEffect = 'none';
    }

    var render = {
      show: function() { output.hide().html(html).show(settings.showSpeed); },
      slideDown: function() { output.hide().html(html).slideDown(settings.showSpeed); },
      fadeIn: function() { output.hide().html(html).fadeIn(settings.showSpeed); },
      none: function() { output.html(html); }
    };

    var get_level = function(ele) { return parseInt(ele.nodeName.replace("H", ""), 10); };
    var highest_level = headers.map(function(_, ele) { return get_level(ele); }).get().sort()[0];
    var return_to_top = '<i class="icon-arrow-up back-to-top"> </i>';

    var level = get_level(headers[0]),
      this_level,
      html = settings.title + " <" +settings.listType + " class=\"" + settings.classes.list +"\">";
    headers.on('click', function() {
      if (!settings.noBackToTopLinks) {
        window.location.hash = this.id;
      }
    })
    .addClass('clickable-header')
    .each(function(_, header) {
      this_level = get_level(header);
      if (!settings.noBackToTopLinks && this_level === highest_level) {
        $(header).addClass('top-level-header').after(return_to_top);
      }
      if (this_level === level) // same level as before; same indenting
        html += "<li class=\"" + settings.classes.item + "\">" + createLink(header);
      else if (this_level <= level){ // higher level than before; end parent ol
        for(var i = this_level; i < level; i++) {
          html += "</li></"+settings.listType+">"
        }
        html += "<li class=\"" + settings.classes.item + "\">" + createLink(header);
      }
      else if (this_level > level) { // lower level than before; expand the previous to contain a ol
        for(i = this_level; i > level; i--) {
          html += "<" + settings.listType + " class=\"" + settings.classes.list +"\">" +
                  "<li class=\"" + settings.classes.item + "\">"
        }
        html += createLink(header);
      }
      level = this_level; // update for the next one
    });
    html += "</"+settings.listType+">";
    if (!settings.noBackToTopLinks) {
      $(document).on('click', '.back-to-top', function() {
        $(window).scrollTop(0);
        window.location.hash = '';
      });
    }

    render[settings.showEffect]();
  };
})(jQuery);
</script>

<script type="text/javascript">
$(document).ready(function() {
    $('#toc').toc();
});
</script>
