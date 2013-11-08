module PagesHelper
  def action_buttons page
    button_group(
      link_to(icon('icon-arrow-left'), move_page_path(page, :direction => :higher), :class => "btn btn-small", :title => "Move Up", :id => "move_up_#{page.id}"),
      link_to(icon('icon-chevron-left'), rotate_page_path(page, :direction => :anticlockwise), class: "btn btn-small", :title => "Rotate Anticlockwise", :id => "rotate_anti_#{page.id}"),
      link_to(icon('icon-trash icon-white'), page_path(page), class: "btn btn-small btn-danger", method: :delete, data: { confirm: 'Are you sure?' }, :title => "Delete Page", :id => "delete_#{page.id}"),
      link_to(icon('icon-chevron-right'), rotate_page_path(page, :direction => :clockwise), class: "btn btn-small", :title => "Rotate Clockwise", :id => "rotate_clockwise_#{page.id}"),
      link_to(icon('icon-arrow-right'), move_page_path(page, :direction => :lower), :class => "btn btn-small", :title => "Move Down", :id => "move_down_#{page.id}")
    )
  end

  def icon icon
    raw("<i class=\"#{icon}\"></i>")
  end
end
