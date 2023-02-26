require "application_system_test_case"

class PostbisTest < ApplicationSystemTestCase
  setup do
    @postbi = postbis(:one)
  end

  test "visiting the index" do
    visit postbis_url
    assert_selector "h1", text: "Postbis"
  end

  test "should create postbi" do
    visit postbis_url
    click_on "New postbi"

    fill_in "Access", with: @postbi.access
    fill_in "Body", with: @postbi.body
    fill_in "Passcode", with: @postbi.passcode
    click_on "Create Postbi"

    assert_text "Postbi was successfully created"
    click_on "Back"
  end

  test "should update Postbi" do
    visit postbi_url(@postbi)
    click_on "Edit this postbi", match: :first

    fill_in "Access", with: @postbi.access
    fill_in "Body", with: @postbi.body
    fill_in "Passcode", with: @postbi.passcode
    click_on "Update Postbi"

    assert_text "Postbi was successfully updated"
    click_on "Back"
  end

  test "should destroy Postbi" do
    visit postbi_url(@postbi)
    click_on "Destroy this postbi", match: :first

    assert_text "Postbi was successfully destroyed"
  end
end
