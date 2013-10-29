module DocumentsHelper
  def create_or_update_doc
    params[:action] == "new" ? "Create Document" : "Save Changes"
  end
end
