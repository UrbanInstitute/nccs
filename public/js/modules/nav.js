import {
  disableBodyScroll,
  enableBodyScroll,
} from "../lib/bodyScrollLock.esm.js";

export default class nav {
  constructor(el) {
    this.el = el;
    this.setVars();
    this.bindEvents();
  }

  mql = window.matchMedia("(min-width: 768px)");

  get mobileOpen() {
    return this.el.dataset.mobile === "true";
  }

  setVars() {
    // grab targets
    this.navTarget = this.el.querySelector("[data-nav-target]");
    this.navToggle = this.el.querySelector("[data-nav-toggle]");

    // build list for focus trap
    this.focusableEls = this.el.querySelectorAll(
      'a[href]:not([disabled]), a[href]:not(.skip-link), button:not([disabled]), textarea:not([disabled]), input[type="text"]:not([disabled]), input[type="radio"]:not([disabled]), input[type="checkbox"]:not([disabled]), select:not([disabled])'
    );
    this.focusFirst = this.focusableEls[0]
    this.focusLast = this.focusableEls[this.focusableEls.length - 1]

    // close mobile nav if left open and resized
    this.resizeObserver = new ResizeObserver(() => {
      if (this.mql.matches && this.mobileOpen) {
        this.toggleVisibilty();
      }
    });

    // track when the sticky nav is pinned
    this.intersectionObserver = new IntersectionObserver(
      ([e]) => {
        setTimeout(() => {
          e.target.classList.toggle("-pinned", e.intersectionRatio < 1);
        }, 250);
      },
      { threshold: 1 }
    );
  }

  bindEvents() {
    this.navToggle.addEventListener("click", this.toggleVisibilty.bind(this));
    this.resizeObserver.observe(this.el);
    this.intersectionObserver.observe(this.el);
    this.navTarget.addEventListener("transitionend", this.toggleOpacity.bind(this));
    window.addEventListener('keydown', this.handleKeyDown)
  }

  toggleVisibilty = () => {
    if (this.mobileOpen) {
      // close
      this.navTarget.classList.remove("-active");
      this.el.dataset.mobile = false;
      enableBodyScroll(this.navTarget);
      document.activeElement.blur();
      this.el.removeEventListener('keydown', this.focusTrap)
    } else {
      // open
      this.navToggle.ariaPressed = true;
      this.el.dataset.mobile = true;
      disableBodyScroll(this.navTarget);
      this.navTarget.classList.add("-visible");
      setTimeout(() => {
        this.navTarget.classList.add("-active");
      }, 0);
      this.el.addEventListener('keydown', this.focusTrap)
    }
  };

  toggleOpacity = () => {
    if (!this.mobileOpen) {
      this.navTarget.classList.remove("-visible");
    }
  };

  focusTrap = (e) => {
    const isTabPressed = e.key === "Tab" || e.keyCode === "9";
    const isEscapedPressed = e.key === "Escape" || e.keyCode === "27";

    if (isEscapedPressed) {
      this.toggleVisibilty();
    }

    if (!isTabPressed) {
      return;
    }

    if (e.shiftKey) {
      //shift + tab
      if (document.activeElement === this.focusFirst) {
        this.focusLast.focus();
        e.preventDefault();
      }
    } else {
      // tab
      if (document.activeElement === this.focusLast) {
        this.focusFirst.focus();
        e.preventDefault();
      }
    }
  };
  
  // close nav on Escape press if nav is open
  handleKeyDown = (e) => {
    if (!this.mobileOpen) {
      return
    }

    // NOTE: may need better normalization of keycodes? 27 = ESC (mostly)
    if (e.keyCode === 27) {
      this.toggleVisibilty()
    }
  }
}
