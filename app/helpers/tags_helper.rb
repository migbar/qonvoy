module TagsHelper
  def all_cuisines
    ActsAsTaggableOn::Tag.find(:all, :joins => :taggings, :conditions => { :taggings => { :context => "cuisines" }}, :group => "tags.id").map(&:name).sort
  end
end