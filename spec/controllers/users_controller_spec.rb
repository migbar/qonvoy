require 'spec_helper'

describe UsersController do
  describe "handling GET new" do
    it "renders the new template" do
      get :new
      response.should render_template(:new)
    end
  end
end
