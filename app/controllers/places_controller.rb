class PlacesController < ApplicationController
  include ActionView::Helpers::RecordIdentificationHelper
  
  before_filter :find_place
  
  def show                                     
    logger.debug("> inside show")
    @dishes = @place.dishes.descend_by_rating
    logger.debug("> loaded dishes")
    @map = MapPresenter.new(@place, :controller => self)
    logger.debug("> built presenter")
  end
  
  def edit
    render
  end
  
  private
    def find_place
      @place = Place.find(params[:id])
    end
end