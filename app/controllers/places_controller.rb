class PlacesController < ApplicationController
  before_filter :find_place
  
  def show
    render
  end
  
  def edit
    render
  end
  
  private
    def find_place
      @place = Place.find(params[:id])
    end
end