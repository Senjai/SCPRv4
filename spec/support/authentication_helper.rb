module AuthenticationHelper
  # For features
  def login(trait=:superuser, options={})
    @user = create :admin_user, trait, options.reverse_merge!(username: "bricker", unencrypted_password: "secret55")
    visit outpost_login_path
    fill_in "username", with: @user.username
    fill_in "password", with: @user.unencrypted_password
    click_button "Submit"
  end
end
