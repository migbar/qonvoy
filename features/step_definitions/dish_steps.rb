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