class DishesController < ApplicationController
  def show
    @place = Place.find(params[:place_id])
    @dish = @place.dishes.find(params[:id])
  end
end