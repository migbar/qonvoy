class PlacesController < ApplicationController
  def edit
    @place = Place.find(params[:id])
  end
end