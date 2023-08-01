export default class clipboard {
  constructor(el) {
    this.el = el;
    this.setVars();
    this.bindEvents();
  }

  setVars() {
    this.clipTrigger = this.el.querySelector("[data-clipboard-trigger]");
    this.clipTarget = this.el.querySelector("[data-clipboard-text]");
    this.copySupported = navigator.clipboard;
  }

  bindEvents() {
    this.clipTrigger.addEventListener("click", this.handleClick);
  }

  handleClick = () => {
    // grab text and replace newlines with a space and remove all extra spaces
    let copyText = this.clipTarget.innerHTML.replace(/(\r\n|\n|\r|\s\s+)/gm, " ").replace(/(\s\s+)/gm, "")

    if (this.copySupported) {
      navigator.clipboard.writeText(copyText).then(
        () => {
          window.alert("Copied!")
        },
        () => {
          window.prompt("Copy to clipboard failed, but you can copy the following text: ", copyText);
        }
      )
    } else {
      // Fallback if browser doesn't support .execCommand('copy')
      window.prompt("Copy to clipboard not supported, but you can copy the following text: ", copyText);
    }
  }
}
