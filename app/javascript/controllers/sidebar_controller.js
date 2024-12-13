import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    console.log("Hello World!")
  }
  showSidebar() {
      const toggle = document.getElementById("header-toggle")
      const sidebar = document.getElementById("sidebar")
      const header = document.getElementById("header")
      const main = document.getElementById("main")
     
          toggle.addEventListener('click', ()=>{
              /* Show */
              console.log("sidebar has been clicked")
              sidebar.classList.toggle('show-sidebar')
              
              header.classList.toggle('left-pd')

              main.classList.toggle('left-pd')
          })
      } 
}
