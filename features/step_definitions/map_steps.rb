When /^I click the map marker at "([^\"]*)"$/ do |coords|
  lat, lng = *coords.split(',').map(&:to_f)
  
  dom_area_id = Capybara.current_session.evaluate_script("MapController.getMarkerId(0)")
  
  marker_lat = Capybara.current_session.evaluate_script("MapController.getMarker(0).getLatLng().lat()")
  marker_lng = Capybara.current_session.evaluate_script("MapController.getMarker(0).getLatLng().lng()")
  
  marker_lat.should == lat
  marker_lng.should == lng
  map = locate(:xpath, Capybara::XPath.append("//area[@id='#{dom_area_id}']"), "no map marker found")    
  
  map.click
end

Then /^the marker bubble should contain "([^\"]*)"$/ do |text|
  within(".gmnoprint") do
    page.should have_content(text)
  end
end
