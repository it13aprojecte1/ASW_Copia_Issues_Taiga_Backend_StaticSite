// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
//import "turbo-rails"
//import "controllers"

//import "@hotwired/turbo-rails"
import Rails from "@rails/ujs"
Rails.start()

import { Application } from "@hotwired/stimulus"

const application = Application.start()

// Configure Stimulus development experience
application.debug = false
window.Stimulus   = application

export { application }

