import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="totalupdate"
export default class extends Controller {

  static targets = ["prix", "locvente", "quantite", "total"]
  connect() {
    console.log('connect from totalupdate ctrler')   
  } 

  setInitialPrix(){
    console.log("call set initial prix " )
    const typeLocVenteField = this.locventeTarget.value; //this.element.querySelector("select[name='locvente']").value;
    console.log("type: " + typeLocVenteField )



    let prixInitial;
    if (typeLocVenteField == "location") {
      prixInitial = this.element.querySelector("input[name='prixlocationInitial']").value;
    } else {
      prixInitial = this.element.querySelector("input[name='prixVenteInitial']").value;
    }
    
    this.changePrix(prixInitial)
    this.updateTotal()

  }

  changePrix(prixInitial) {
  //  console.log("call change prix")
    setTimeout(() => {
      this.prixTarget.value = prixInitial; // this.element.querySelector("input[name='prix']").value 
    }, 0);
  }

  updateTotal() {

    setTimeout(() => {

      let quantite;
      quantite = this.quantiteTarget.value; // this.element.querySelector("input[name='quantite']").value
   
      let prix;
      prix =  this.prixTarget.value; //this.element.querySelector("input[name='prix']").value
      
      if (!isNaN(quantite) && !isNaN(prix)) {
          //console.log("call update total - qté:" + quantite + " prix:" + prix)
         // this.element.querySelector("input[name='total']").value 
         this.totalTarget.value = (quantite * prix).toFixed(2);

        } else {
          //this.element.querySelector("input[name='total']").value
          this.totalTarget.value = 0;
        }     
    }, 0);
  }
}
