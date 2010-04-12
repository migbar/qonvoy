When /^I click the map marker at "([^\"]*)"$/ do |coords|
  lat, lng = *coords.split(',').map(&:to_f)
  
  dom_area_id = Capybara.current_session.evaluate_script("map.Pc[0].kB.id")
  
  marker_lat = Capybara.current_session.evaluate_script("map.Pc[0].B.y")
  marker_lng = Capybara.current_session.evaluate_script("map.Pc[0].B.x")
  
  marker_lat.should == lat
  marker_lng.should == lng
  
  map = locate(:xpath, Capybara::XPath.append("//area[@id='#{dom_area_id}']"), "no map found")
  map.click
  sleep 5
end

Then /^the marker bubble should contain "([^\"]*)"$/ do |text|
  within(".gmnoprint") do
    page.should have_content(text)
  end
end