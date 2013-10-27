class PagesController < ApplicationController

  def index
    @pages = Page.all
  end

  def show
    @page = Page.find(params[:id])
  end

  def edit
    @page = Page.find(params[:id])
  end

  def update
    @page = Page.find(params[:id])

    if @page.update(params[:page].permit([:label,:document_id]))
      redirect_to @page
    else
      render 'edit'
    end
  end

  def destroy
    @page = Page.find(params[:id])
    @page.destroy

    redirect_to pages_path
  end

  def upload
    @page = Page.new
  end

  def file_upload
    if params[:file_upload] && params[:file_upload][:file]
      file = params[:file_upload][:file]
      path = file.tempfile
      name = file.original_filename
      type = file.content_type.split('/').last
      page = Page.send("file_upload_#{type}".to_sym,name,path)
      if page.errors.empty?
        redirect_to page_path(page), flash: { :success => "File uploaded!" }
      else
        redirect_to upload_path, flash: { :error => "Error!\n" + page.errors.full_messages.join("\n") }
      end
    else
      redirect_to upload_path,flash: { :error => "No file selected!" }
    end
  end

end
