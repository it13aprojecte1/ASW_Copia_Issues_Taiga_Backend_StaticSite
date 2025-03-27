// app/javascript/controllers/calendar_controller.js
import { Controller } from "stimulus";

export default class extends Controller {
  static targets = ["datepicker", "button"];  // Definir los targets

  connect() {
    console.log("Calendar Controller connected!");
  }

  // Acción para mostrar el datepicker
  showDatepicker(event) {
    event.stopPropagation(); // Evitar que el clic se propague
    this.datepickerTarget.style.display = "block"; // Mostrar el campo de fecha
    this.datepickerTarget.focus(); // Opcional: poner foco al campo de fecha
  }

  // Acción para cerrar el datepicker si se hace clic fuera de él
  closeDatepicker(event) {
    if (!this.datepickerTarget.contains(event.target) && event.target !== this.buttonTarget) {
      this.datepickerTarget.style.display = "none"; // Ocultar el campo de fecha
    }
  }
}
