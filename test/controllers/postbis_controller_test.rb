require "test_helper"

class PostbisControllerTest < ActionDispatch::IntegrationTest
  setup do
    @postbi = postbis(:one)
  end

  test "should get index" do
    get postbis_url
    assert_response :success
  end

  test "should get new" do
    get new_postbi_url
    assert_response :success
  end

  test "should create postbi" do
    assert_difference("Postbi.count") do
      post postbis_url, params: { postbi: { access: @postbi.access, body: @postbi.body, passcode: @postbi.passcode } }
    end

    assert_redirected_to postbi_url(Postbi.last)
  end

  test "should show postbi" do
    get postbi_url(@postbi)
    assert_response :success
  end

  test "should get edit" do
    get edit_postbi_url(@postbi)
    assert_response :success
  end

  test "should update postbi" do
    patch postbi_url(@postbi), params: { postbi: { access: @postbi.access, body: @postbi.body, passcode: @postbi.passcode } }
    assert_redirected_to postbi_url(@postbi)
  end

  test "should destroy postbi" do
    assert_difference("Postbi.count", -1) do
      delete postbi_url(@postbi)
    end

    assert_redirected_to postbis_url
  end
end
