/**
 * Content module for post-processing Quarto-generated content
 * @module modules/content
 */

/**
 * Enhances content areas with responsive wrappers for tables
 * Ensures proper display regardless of Quarto output
 * @class
 */
export default class content {
  /**
   * Creates a new content processor instance
   * @param {HTMLElement} el - The content container element
   */
  constructor(el) {
    this.el = el;
    this.setVars();
    this.formatContent();
  }

  /**
   * Initializes DOM references for content elements
   * @private
   */
  setVars() {
    /** @type {NodeList} All table elements in the content area */
    this.tables = this.el.querySelectorAll('table')
  }

  /**
   * Wraps tables in responsive containers for horizontal scrolling on small screens
   * Ensures tables from Quarto output display correctly on mobile devices
   */
  formatContent() {
    if (this.tables) {
      this.tables.forEach((table) => {
        let wrapper = document.createElement('div');
        wrapper.classList = "table-responsive"
        table.parentNode.insertBefore(wrapper, table)
        wrapper.appendChild(table)
      })
    }
  }
}
