import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="video-preview"
export default class extends Controller {
  connect() {
    this.element.addEventListener('hidden.bs.modal', (event) => {
      const video = this.element.querySelector('video')

      video.pause()
    })
  }
}
