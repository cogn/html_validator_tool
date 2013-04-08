require 'test_helper'

class ValidatorControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get validate" do
    get :validate
    assert_response :success
  end

  test "should get show" do
    get :show
    assert_response :success
  end

end
