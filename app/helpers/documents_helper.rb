module DocumentsHelper
  def create_or_update_doc
    params[:action] == "new" ? "Create Document" : "Save Changes"
  end

  def document_info_buttons doc
    date_string = doc.relevant_date.blank? ? "No date set" : doc.relevant_date
    content_tag(:button, date_string, :class => "btn btn-default", :disabled => true)
  end

  def document_edit_buttons doc
    link_to('Edit', edit_document_path(doc), class: "btn btn-success") +
      link_to('Delete', document_path(@document), :class => "btn btn-danger",
              :method => :delete, :data => { confirm: 'Are you sure?' })
  end

  def document_page_buttons doc
    location_string = "Location: #{doc.location.blank? ? "No hardcopy" : doc.location }"
    link_to(location_string, '#', :class => "btn btn-default", :disabled => doc.location.blank?) +

    link_to("Download Original PDF", image_path("/scans/#{doc.pdf_path}"),
              :class => "btn", :target => "_blank", :disabled => doc.pdf_path.blank?)
  end
end
