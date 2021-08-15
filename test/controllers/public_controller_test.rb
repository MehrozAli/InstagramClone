require 'test_helper'

class PublicControllerTest < ActionDispatch::IntegrationTest
  test 'the landing page renders for visitors' do
    get root_path

    assert_response :success
    assert_select 'h1', /Post a print/
  end

  test 'signed-in users land on their feed' do
    sign_in users(:alice)

    get root_path

    assert_redirected_to home_path
  end

  test 'signing in goes straight to the feed' do
    post user_session_path, params: { user: { email: 'alice@example.test', password: 'password123' } }

    follow_redirect! while response.redirect?

    assert_equal home_path, path
  end

  test 'the health check answers without a session' do
    get rails_health_check_path

    assert_response :success
  end

  test 'unknown paths get the 404 page' do
    get '/no/such/page'

    assert_response :not_found
  end
end
