export default class filter {
  constructor(el) {
    this.el = el;
    this.setVars();
    this.bindEvents();
  }

  setVars() {
    this.sortSearch = this.el.querySelector("[data-filter-search]");
    this.sortCat = this.el.querySelector("[data-filter-sort-category]");
    this.sortType = this.el.querySelector("[data-filter-sort-type]");
    this.clear = this.el.querySelector("[data-filter-clear]");
    this.entries = this.el.querySelectorAll("[data-filter-entry]");
    this.sections = this.el.querySelectorAll("[data-filter-entry-section]");
    this.timeout = null;

    // animation presets
    this.fadeOut = [
      { opacity: 1, transform: "translateY(0)" },
      { opacity: 0, transform: "translateY(5px)" },
    ];

    this.fadeIn = [
      { opacity: 0, transform: "translateY(5px)" },
      { opacity: 1, transform: "translateY(0)" },
    ];

    this.defaultTiming = {
      duration: 250,
      fill: "both",
      iterations: 1,
      easing: "cubic-bezier(0.33, 1, 0.68, 1)", //easeOutCubic
    };
  }

  bindEvents() {
    if (this.sortSearch) {
      this.sortSearch.addEventListener("keyup", this.handleSearchChange);
    }

    if (this.sortCat) {
      this.sortCat.addEventListener("change", this.handleChange);
    }

    if (this.sortType) {
      this.sortType.addEventListener("change", this.handleChange);
    }

    this.clear.addEventListener("click", this.handleClear);
  }

  handleClear = () => {
    this.sortSearch ? this.sortSearch.value = "" : null;
    this.sortCat ? this.sortCat.value = "" : null;
    this.sortType ? this.sortType.value = "" : null;
    this.filterSort("", "", "");
  };

  handleSearchChange = (e) => {
    clearTimeout(this.timeout)

    this.timeout  = setTimeout(() => {
      this.handleChange()
    }, 750)
  }

  handleChange = (e) => {
    const searchValue = this.sortSearch ? this.sortSearch.value.toLowerCase() : "";
    const catValue = this.sortCat ? this.sortCat.value : "";
    const typeValue = this.sortType ? this.sortType.value : "";

    this.filterSort(searchValue, catValue, typeValue)
  };

  filterSort(filterSearch, filterCat, filterType) {
    // build array of matches
    const matches = Array.prototype.filter.call(
      this.entries,
      function (entry) {
        if (filterSearch === "" && filterCat === "" && filterType === "") {
          return entry;
        }

        let searchMatch = true;
        let catMatch = true;
        let typeMatch = true;

        if (filterSearch !== "") {
          searchMatch = entry.querySelector("[data-filter-entry-text]").innerHTML.toLowerCase().includes(filterSearch)
        }

        if (filterCat !== "") {
          catMatch = entry.dataset.filterCategories.includes(filterCat);
        }

        if (filterType !== "") {
          typeMatch = entry.dataset.filterType.includes(filterType);
        }

        return searchMatch && catMatch && typeMatch
      }
    );

    this.sections.forEach((section) => {
      section.animate(this.fadeOut, this.defaultTiming).finished.then(() => {
        this.entries.forEach((entry) => {
            entry.dataset.active = false;
            matches.forEach((match) => {
              match.dataset.active = true;
            });
        });
        section.animate(this.fadeIn, this.defaultTiming);
      })

    })


  }
}
