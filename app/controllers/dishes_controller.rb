class DishesController < ApplicationController
  def show
    @place = Place.find(params[:place_id])
    @dish = @place.dishes.find(params[:id])
    @statuses = @dish.processed_statuses.descend_by_processed_at
    @dishes = @place.dishes.descend_by_rating
    @map = MapPresenter.new(@place, :controller => self)
  end
end