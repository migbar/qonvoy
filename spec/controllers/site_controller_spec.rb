require 'spec_helper'

describe SiteController do
  describe "handling GET index" do
    it "renders the index template" do
      get :index
      response.should render_template(:index)
    end
  end
end
