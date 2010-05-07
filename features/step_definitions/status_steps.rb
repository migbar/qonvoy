Then /^a processed status should exist having body "([^\"]*)"$/ do |body|
  Status.processed.find_by_body(body).should_not be_nil
end