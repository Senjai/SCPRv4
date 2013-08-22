module AuthenticationHelper
  # For features
  def login(options={})
    username = options[:username] || "bricker"
    password = options[:password] || "secret55"
    @user = create :admin_user, username: username, password: password

    visit outpost_login_path

    fill_in "username", with: username
    fill_in "password", with: password
    click_button "Submit"
  end
end
