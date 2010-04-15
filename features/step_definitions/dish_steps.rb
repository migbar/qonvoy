Then /^I should see the following dishes:$/ do |expected_table|
  doc = Nokogiri::HTML(page.body) 
  actual_table = [%w[name rating status status_rating]]
  
  doc.css('.dishes .dish').each do |e|
    name = e.css('.name')[0].content
    rating = e.css('.rating')[0].content
    status = e.css('.status .body')[0].content
    status_rating = e.css('.status .rating')[0].content
    actual_table << [name, rating, status, status_rating]
  end
  
  expected_table.diff!(Cucumber::Ast::Table.new(actual_table))
end


Then /^I should see the following ratings:$/ do |expected_table|
  doc = Nokogiri::HTML(page.body) 
  actual_table = [%w[body rating user]]
  
  doc.css('.ratings .status').each do |e|
    body = e.css('.body')[0].content
    rating = e.css('.rating')[0].content
    user = e.css('.user')[0].content
    actual_table << [body, rating, user]
  end
  
  expected_table.diff!(Cucumber::Ast::Table.new(actual_table))
end

Then /^I should see the following dishes in the sidebar$/ do |expected_table|
  doc = Nokogiri::HTML(page.body) 
  actual_table = [%w[name rating]]
  
  doc.css('#sidebar .dishes .dish').each do |e|
    name = e.css('.name')[0].content
    rating = e.css('.rating')[0].content
    actual_table << [name, rating]
  end
  
  expected_table.diff!(Cucumber::Ast::Table.new(actual_table))
end