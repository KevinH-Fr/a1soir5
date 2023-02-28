import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="totalupdate"
export default class extends Controller {

  static targets = ["submitbtn", "prix", "total"]
  connect() {
    console.log('hello from totalupdate ctrler')
    this.updateTotal
   
  } 

  setInitialPrix(){
   
    const typeLocVenteField = this.element.querySelector("select[name='locvente']").value;
    let prixInitial;

    if (typeLocVenteField == "location") {
      prixInitial = this.element.querySelector("input[name='prixlocationInitial']").value;
    } else {
      prixInitial = this.element.querySelector("input[name='prixVenteInitial']").value;
    }
    
    console.log("call set initial prix "  + prixInitial + "  " + typeLocVenteField)
    
    this.changePrix(prixInitial)


    this.updateTotal()

 

   // if (!isNaN(prixInitial)) {
   
   // }
  }

  changePrix(prixInitial) {
    console.log("call change prix")
    setTimeout(() => {
      this.element.querySelector("input[name='prix']").value = prixInitial;
    }, 0);

  }

  updateTotal() {
    console.log("call update total")
    const quantiteField = this.element.querySelector("input[name='quantite']");
    const prixField = this.element.querySelector("input[name='prix']");
  //  const totalField = this.totalTarget;

    const quantite = parseInt(quantiteField.value);
    const prix = parseFloat(prixField.value);

   // if (!isNaN(quantite) && !isNaN(prix)) {
   //   totalField.value = (quantite * prix).toFixed(2);
   // } else {
   
   if (!isNaN(quantite) && !isNaN(prix)) {
      this.element.querySelector("input[name='total']").value = (quantite * prix).toFixed(2);
   } else {
      this.element.querySelector("input[name='total']").value = 0;
   }
  }



}
