module AuthenticationHelper
  # For features
  def login(options={})
    @user = create :admin_user, options.reverse_merge!(username: "bricker", password: "secret55")
    visit outpost_login_path
    fill_in "username", with: @user.username
    fill_in "password", with: "secret55"
    click_button "Submit"
  end
end
