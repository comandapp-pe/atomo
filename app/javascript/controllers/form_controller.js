import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="form"
export default class extends Controller {
  connect() {
    console.log('connected')

    const form = document.getElementById('new-video')

    form.addEventListener('ajax:success', event => {
      const [data, status, xhr] = event.detail

      const { responseText } = xhr

      const all_videos = document.getElementById('all_videos')

      all_videos.insertAdjacentHTML('beforeend', responseText)

      console.log(event.detail, 'ajax:success')
    })

    form.addEventListener('ajax:error', event => {
      const [data, status, xhr] = event.detail

      const { responseText } = xhr

      form.outerHTML = responseText

      console.log(event.detail, 'ajax:error')
    })
  }
}
