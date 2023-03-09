require "test_helper"

class FournisseursControllerTest < ActionDispatch::IntegrationTest
  setup do
    @fournisseur = fournisseurs(:one)
  end

  test "should get index" do
    get fournisseurs_url
    assert_response :success
  end

  test "should get new" do
    get new_fournisseur_url
    assert_response :success
  end

  test "should create fournisseur" do
    assert_difference("Fournisseur.count") do
      post fournisseurs_url, params: { fournisseur: { mail: @fournisseur.mail, nom: @fournisseur.nom, notes: @fournisseur.notes, pays: @fournisseur.pays, representant: @fournisseur.representant, telephone: @fournisseur.telephone } }
    end

    assert_redirected_to fournisseur_url(Fournisseur.last)
  end

  test "should show fournisseur" do
    get fournisseur_url(@fournisseur)
    assert_response :success
  end

  test "should get edit" do
    get edit_fournisseur_url(@fournisseur)
    assert_response :success
  end

  test "should update fournisseur" do
    patch fournisseur_url(@fournisseur), params: { fournisseur: { mail: @fournisseur.mail, nom: @fournisseur.nom, notes: @fournisseur.notes, pays: @fournisseur.pays, representant: @fournisseur.representant, telephone: @fournisseur.telephone } }
    assert_redirected_to fournisseur_url(@fournisseur)
  end

  test "should destroy fournisseur" do
    assert_difference("Fournisseur.count", -1) do
      delete fournisseur_url(@fournisseur)
    end

    assert_redirected_to fournisseurs_url
  end
end
