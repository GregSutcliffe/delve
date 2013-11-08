module LayoutHelper
  def button_group *elements
    content_tag(:div,:class=>"btn-group") { elements.join(" ").html_safe }
  end
end
