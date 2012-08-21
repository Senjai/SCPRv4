When /^I go to the content email page$/ do
  visit content_email_path(obj_key: @blog_entry.obj_key)
end

When /^I fill in the "([^"]*)" form with invalid data$/ do |id|
  within "form##{id.gsub(/\s/, "_")}" do
    fill_in "content_email_email", with: "invalid"
  end
end

When /^I fill in the "([^"]*)" form with valid data$/ do |id|
  within "form##{id.gsub(/\s/, "_")}" do
    fill_in "content_email_email",  with: "valid@scpr.org"
    fill_in "content_email_name",   with: "Bryan Ricker"
  end
end

Then /^the e\-mail should have been sent$/ do
  ActionMailer::Base.deliveries.size.should eq 1
end

Then /^I should see an error message$/ do
  page.should have_css ".error"
end

Then /^I should see the success page$/ do
  page.should have_content "Your message was successfully shared!"
end