Then /^I should see (?:a|the) comments? section$/ do
  page.should have_css "#comments"
end

Then /^I should see (\d+) related articles$/ do |num|
  page.should have_css ".related-articles li", count: num.to_i
end

Then /^I should see (\d+) related links$/ do |num|
  page.should have_css ".related-links li", count: num.to_i
end

Then /^I should see a brightcove player section$/ do
  pending # express the regexp above with the code you wish you had
end

Then /^the article meta header should say "([^"]*)"$/ do |text|
  page.find(".article-meta").should have_content "#{text}"
end

Then /^I should see article meta$/ do
  page.should have_css ".article-meta"
end

Then /^I should see an audio link$/ do
  pending
  page.should have_css ".audio-toggler"
end
