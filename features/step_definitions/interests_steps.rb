Then /^"([^\"]*)" should be selected in the "([^\"]*)" interests panel$/ do |interest, scope|
  with_scope("##{scope}.interests") do
    page.body.should have_tag("a.selected", interest)
  end
end