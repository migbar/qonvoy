module TagsHelper
  def all_interests(group)
    ActsAsTaggableOn::Tag.find(:all,
      :joins => :taggings,
      :conditions => { :taggings => { :context => group.pluralize }},
      :group => "tags.id").map(&:name).sort
  end
end