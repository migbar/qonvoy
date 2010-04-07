module NavigationHelpers
  # Maps a name to a path. Used by the
  #
  #   When /^I go to (.+)$/ do |page_name|
  #
  # step definition in web_steps.rb
  #
  def path_to(page_name)
    case page_name
    
    when /the home\s?page/
      '/'
    when /my profile page/
      edit_profile_path
    when /the ratings page for "([^\"]*)"/
      dish = Dish.find_by_name($1)
      place_dish_path(dish.place, dish)
    when /the edit page for the place "([^\"]*)"/
      edit_place_path(Place.find_by_name($1))
    when /the edit page for the status "([^\"]*)"/
      edit_status_path(Status.find_by_body($1))
    when /the show page for the dish "([^\"]*)"/
      dish = Dish.find_by_name($1)
      place_dish_path(dish.place, dish)
    # Add more mappings here.
    # Here is an example that pulls values out of the Regexp:
    #
    #   when /^(.*)'s profile page$/i
    #     user_profile_path(User.find_by_login($1))

    else
      raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
        "Now, go and add a mapping in #{__FILE__}"
    end
  end
  
  def resource_to(page_name, record)
    case page_name
    
    when /the status edit page/
      edit_status_path(record)
    when /the dish show page/
      place_dish_path(record.place, record)
    else
      raise "Can't find mapping from \"#{page_name}\" to a resource.\n" +
        "Now, go and add a mapping in #{__FILE__}"
    end
  end
end

World(NavigationHelpers)
