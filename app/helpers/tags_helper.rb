module TagsHelper
  def all_interests(group)
    [] # from graph
    
    # ActsAsTaggableOn::Tag.find(:all,
    #   :joins => :taggings,
    #   :conditions => { :taggings => { :context => group.pluralize }},
    #   :group => "tags.id").map(&:name).sort
  end
end