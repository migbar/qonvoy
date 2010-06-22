Then /^"([^\"]*)" should be selected in the "([^\"]*)" interests panel$/ do |interest, scope|
  # with_scope("##{scope}.interests") do
  #   page.body.should have_tag("a.selected", interest)
  # end
  page.should have_xpath("//*[@id='#{scope}']//a[@class='selected']", :text => interest)
end

Then /^my cuisine_list should be "([^\"]*)"$/ do |cuisines|
  current_user.cuisine_list.should == cuisines.split(',').map(&:strip)
end
