class PlacesController < ApplicationController
  include ActionView::Helpers::RecordIdentificationHelper
  
  before_filter :find_place
  
  def show
    @dishes = @place.dishes.descend_by_rating
    @map = MapPresenter.new(@place, :controller => self)
  end
  
  def edit
    render
  end
  
  private
    def find_place
      @place = Place.find(params[:id])
    end
end