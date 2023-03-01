import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="totalupdate"
export default class extends Controller {

  static targets = ["prix", "locvente", "quantite", "total", "containerCaution", "containerLongueduree", "longueduree", "caution"]
  connect() {
    console.log('connect from totalupdate ctrler')   
    this.setTypeLocVente();
  } 

  setTypeLocVente(){
    console.log('connect from set type loc vente')   
    const typeLocVenteField = this.locventeTarget.value; 
    let typeLocVente;
    if (typeLocVenteField == "location") {
      typeLocVente = "location"
    } else if (typeLocVenteField == "vente") {
      typeLocVente = "vente"
    } else {
      typeLocVente = ""
    }
    this.hideCaution(typeLocVente);
  }

  setLongueDuree(){
    const valLongueDuree = this.longuedureeTarget.checked;

    let prix = this.prixTarget.value;
    if (valLongueDuree == true) {
      prix *= 1.2; 
    } else {
      prix /= 1.2; 
    }
    this.prixTarget.value = prix; 
    this.updateTotal();
  }

  hideCaution(typeLocVente){
    console.log('connect hide caution')   
    if (typeLocVente == "location") {
      this.containerCautionTarget.hidden = false;
      this.containerLonguedureeTarget.hidden = false;
    } else {
    this.containerCautionTarget.hidden = true;
    this.containerLonguedureeTarget.hidden = true;
    }
  }

  setInitialPrix(){
    const typeLocVenteField = this.locventeTarget.value; 
    let typeLocVente;

    let prixInitial;
    let cautionInitial;

    if (typeLocVenteField == "location") {
      prixInitial = this.element.querySelector("input[name='prixlocationInitial']").value;
      cautionInitial = this.element.querySelector("input[name='prixCautionInitial']").value;
      typeLocVente = "location";
    } else if (typeLocVenteField == "vente") {
      prixInitial = this.element.querySelector("input[name='prixVenteInitial']").value;
      cautionInitial = 0;
      typeLocVente = "vente";
    } else {
      prixInitial = 0;
    }
    
    this.changePrix(prixInitial, cautionInitial)
    this.updateTotal()
    this.hideCaution(typeLocVente)
  }

  changePrix(prixInitial, cautionInitial) {
    this.prixTarget.value = prixInitial; 
    this.cautionTarget.value = cautionInitial; 
  }

  updateTotal() {
    let quantite;
    quantite = this.quantiteTarget.value; 
  
    let prix;
    prix =  this.prixTarget.value; 
    
    if (!isNaN(quantite) && !isNaN(prix)) {
      this.totalTarget.value = (quantite * prix).toFixed(2);
    } else {
      this.totalTarget.value = 0;
    }     
  }
}
