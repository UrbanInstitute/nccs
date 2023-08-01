export default class content {
  constructor(el) {
    this.el = el;
    this.setVars();
    this.formatContent();
  }

  setVars() {
    this.tables = this.el.querySelectorAll('table')
  }

  formatContent() {
    // provide responsive overflow for tables no matter what quarto generates
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
