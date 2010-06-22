module AuthenticationHelpers
  def current_user
    model(%{user "#{@current_user}"})
  end
  
  def set_current_user(user)
    @current_user = user
  end
end

World(AuthenticationHelpers)
