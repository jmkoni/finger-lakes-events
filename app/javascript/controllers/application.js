import { Application } from "@hotwired/stimulus"

const application = Application.start()

// Configure Stimulus development experience
application.debug = false
window.Stimulus   = application

export { application }

function initBurgerMenu() {
  const burger = document.querySelector('[data-role="burger"]')
  const nav = document.querySelector('[data-role="primary-nav"]')

  if (!burger || !nav) return

  const icon = burger.querySelector("[data-role=\"burger-icon\"]")

  const toggleNav = () => {
    const expanded = burger.getAttribute("aria-expanded") === "true"
    const nextExpanded = !expanded
    burger.setAttribute("aria-expanded", nextExpanded.toString())
    burger.classList.toggle("is-active", nextExpanded)
    nav.classList.toggle("nav-active", nextExpanded)
    if (icon) {
      const {barsSrc, timesSrc, barsAlt, timesAlt} = icon.dataset
      const nextSrc = nextExpanded ? timesSrc : barsSrc
      if (nextSrc) {
        icon.setAttribute("src", nextSrc)
      }
      const nextAlt = nextExpanded ? timesAlt : barsAlt
      if (nextAlt) {
        icon.setAttribute("alt", nextAlt)
      }
    }
  }

  burger.addEventListener("click", toggleNav)
}

document.addEventListener("turbo:load", initBurgerMenu)
