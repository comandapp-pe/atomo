import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="masonry"
export default class extends Controller {
  connect() {
    const { id } = this.element

    const element = document.getElementById(id)

    const masonry = new Masonry(`#${id}`)

    imagesLoaded(element).on('progress', () => { masonry.layout() })

    this.observer = new MutationObserver((mutations, observer) => {
      imagesLoaded(element).on('always', () => {
        masonry.reloadItems()

        masonry.layout()
      })
    })

    this.observer.observe(element, { childList: true, subtree: true })
  }

  disconnect() {
    this.observer.disconnect()
  }
}
