import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="progress"
export default class extends Controller {
  connect() {
    this.element.addEventListener('direct-upload:initialize', event => {
      if (event.target.id !== this.element.id) {
        return
      }

      const { target, detail } = event

      const { id, file } = detail

      const { name } = file

      target.insertAdjacentHTML('beforebegin', `
        <div id="progress-${id}" class="progress mb-3">
          <div id="progress-bar-${id}" class="progress-bar"></div>
        </div>
      `)
    })

    this.element.addEventListener('direct-upload:progress', event => {
      if (event.target.id !== this.element.id) {
        return
      }

      const { id, progress, file } = event.detail

      const { name } = file

      const progressBar = document.getElementById(`progress-bar-${id}`)

      progressBar.style.width = `${Math.trunc(progress)}%`
    })

    this.element.addEventListener('direct-upload:end', event => {
      if (event.target.id !== this.element.id) {
        return
      }

      const { id } = event.detail

      const progressBarParent = document.getElementById(`progress-${id}`)

      progressBarParent.remove()
    })
  }
}
