Then /^"([^\"]*)" should be selected in the "([^\"]*)" interests panel$/ do |interest, scope|
  page.should have_xpath("//*[@id='#{scope}']//a[@class='selected']", :text => /#{Regexp.escape(interest)}/)
end

Then /^my cuisine_list should be "([^\"]*)"$/ do |cuisines|
  current_user.cuisine_list.should == cuisines.split(',').map(&:strip)
end

When /^I select the following interests:$/ do |table|
  table.hashes.each do |hash|
    human_name, value, tag_name = hash['interest'], hash['fill_in'], hash['click']
    interest_name = human_name.downcase.gsub(/\W/, '_')

    When %{I fill in "#{human_name}" with "#{value}"}
    # ..trying to force close the autocomplete or menu so we can move to the next field
    # evaluate_script "$('#user_#{interest_name}').data('autocomplete').menu.deactivate();"
		
		Then %{"#{value}" should be selected in the "#{interest_name}" interests panel}
    When %{I follow "#{tag_name}" within "##{interest_name}.interests"}

		# evaluate_script "alert(1)"

		# evaluate_script "Interests._dimissAutocomplete('#user_#{interest_name}')"
		# evaluate_script "$('#user_#{interest_name}').data('autocomplete').close()"

    Then %{the "#{human_name}" field should contain "#{tag_name}"}
  end
end

Then /^my interest lists should be:$/ do |table|
	table.hashes.each do |hash|
		interest, value = hash['interest'], hash['list']
		current_user.send("#{interest}_list").should == value.split(",").map(&:strip)
	end
end