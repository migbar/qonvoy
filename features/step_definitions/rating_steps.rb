Then /^the dish "([^\"]*)" should have a rating of "([^\"]*)"$/ do |dish_name, rating|
  Dish.find_by_name(dish_name).rating.should == rating.to_i
end