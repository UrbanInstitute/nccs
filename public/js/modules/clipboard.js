/**
 * Clipboard module for copy-to-clipboard functionality
 * @module modules/clipboard
 */

/**
 * Provides copy-to-clipboard functionality for designated text content
 * Uses the Clipboard API with fallbacks for older browsers
 * @class
 */
export default class clipboard {
  /**
   * Creates a new clipboard instance
   * @param {HTMLElement} el - The container element with clipboard trigger and target
   */
  constructor(el) {
    this.el = el;
    this.setVars();
    this.bindEvents();
  }

  /**
   * Initializes DOM references and checks for clipboard support
   * @private
   */
  setVars() {
    /** @type {HTMLElement} Button that triggers copy */
    this.clipTrigger = this.el.querySelector("[data-clipboard-trigger]");
    /** @type {HTMLElement} Element containing text to copy */
    this.clipTarget = this.el.querySelector("[data-clipboard-text]");
    /** @type {boolean} Whether the Clipboard API is supported */
    this.copySupported = navigator.clipboard;
  }

  /**
   * Binds click event to the trigger button
   * @private
   */
  bindEvents() {
    this.clipTrigger.addEventListener("click", this.handleClick);
  }

  /**
   * Handles the copy action when trigger is clicked
   * Cleans text by removing extra whitespace before copying
   * Shows feedback via alert/prompt (note: not ideal for accessibility)
   */
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
