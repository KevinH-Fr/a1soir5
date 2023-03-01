import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="totalupdate"
export default class extends Controller {

  static targets = ["prix", "locvente", "quantite", "total", "containerCaution", "caution"]
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

  hideCaution(typeLocVente){
    console.log('connect hide caution')   
    if (typeLocVente == "location") {
      this.containerCautionTarget.hidden = false;
    } else {
    this.containerCautionTarget.hidden = true;
    }
  }

  setInitialPrix(){
    const typeLocVenteField = this.locventeTarget.value; 
    let typeLocVente;
    // to do : remplacer par un else if pour verifier que bien vente
    // verifier pas d'erreur quand valeur vide 
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
