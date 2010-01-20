module ApplicationHelper
  def title(page_title, show_title = true)
    @content_for_title = page_title.to_s
    @show_title = show_title
  end

  def title_tag
    common_title = 'Qonvoy'
    content_tag(:title, @content_for_title.blank? && "Untitled | #{common_title}" || "#{h(@content_for_title)} | #{common_title}")
  end

  def show_title?
    @show_title
  end

  def stylesheet(*args)
    content_for(:head) { stylesheet_link_tag(*args.map(&:to_s)) }
  end

  def javascript(*args)
    args = args.map { |arg| arg == :defaults ? arg : arg.to_s }
    content_for(:head) { javascript_include_tag(*args) } # => @content_for_head << '...'
  end
end
