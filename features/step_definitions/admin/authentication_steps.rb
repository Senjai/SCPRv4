#### Setup
Given /^I am an admin user$/ do
  @admin_user ||= create :admin_user
end

# The factory is_superuser by default so we can test anything
# Test permissions separately
Given /^I am logged in$/ do
  @admin_user ||= create :admin_user
  visit admin_login_path
  fill_in 'username', with: @admin_user.username
  fill_in 'password', with: @admin_user.passw
  find("input[type=submit]").click
  current_path.should eq admin_root_path
  page.should have_css ".alert-success"
end

Given /^I am logged out$/ do
  visit admin_logout_path
  current_path.should eq admin_login_path
end



#### Finders
Then /^I should not see a logout link$/ do
  page.should_not have_css '#logout'
end



#### Assertions
Then /^I should be logged in$/ do
  cookies[:auth_token].should be_present
end

Then /^I should not be logged in$/ do
  cookies[:auth_token].should be_nil
end



#### Actions
When /^I fill in the login fields with invalid information$/ do
  fill_in 'username', with: @admin_user.username
  fill_in 'password', with: 'incorrect'
end

When /^I fill in the login fields with valid information$/ do
  fill_in "username", with: @admin_user.username
  fill_in "password", with: "secret"
end
