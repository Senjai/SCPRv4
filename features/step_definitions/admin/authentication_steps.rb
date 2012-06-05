#### Setup
Given /^I am an admin user$/ do
  @user ||= create :admin_user
end

When /^I update the required fields with valid information$/ do
  pending # express the regexp above with the code you wish you had
end


Given /^I am logged in$/ do
  @user ||= create :admin_user
  visit admin_login_path
  fill_in 'email', with: @user.email
  fill_in 'password', with: @user.password
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
  pending
end

Then /^I should not be logged in$/ do
  pending
end



#### Actions
When /^I fill in the login fields with invalid information$/ do
  fill_in 'email', with: @user.email
  fill_in 'password', with: 'incorrect'
end

When /^I fill in the login fields with valid information$/ do
  fill_in "email", with: @user.email
  fill_in "password", with: "secret"
end