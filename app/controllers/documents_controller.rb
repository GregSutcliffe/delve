class DocumentsController < ApplicationController

  def index
    if params[:tag]
      @documents = Document.tagged_with(params[:tag]).paginate(page: params[:page])
    else
      @documents = Document.paginate(page: params[:page])
    end
  end

  def show
    @document = Document.find(params[:id])
    @pages = @document.pages.paginate(page: params[:page])
  end

  def new
    @document = Document.new
    @document.relevant_date = Date.today
  end

  def create
    @document = Document.new(document_params)
    if @document.save
      flash[:success] = "Document created!"
      redirect_to @document
    else
      render 'new'
    end
  end

  def edit
    @document = Document.find(params[:id])
  end

  def update
    @document = Document.find(params[:id])
    if @document.update_attributes(document_params)
      flash[:success] = "Document updated"
      redirect_to @document
    else
      render 'edit'
    end
  end

  def destroy
    @document = Document.find(params[:id])
    @document.destroy

    flash[:success] = "Document deleted: #{@document.name}"
    redirect_to documents_path
  end

  def upload
    @document = Document.find(params[:id])
    if params[:document] && params[:document][:image]
      if file_upload params[:document][:image]
        redirect_to @document, flash: { :success => "#{params[:document][:image].original_filename} appended to #{@document.name}" }
      else
        redirect_to @document, flash: { :error => "Error!\n" + @document.errors.full_messages.join("\n") }
      end
    else
      redirect_to @document,flash: { :error => "No file selected!" }
    end
  end

  def scan
    @document = Document.find(params[:id])
    # Make this a drop-down of all scanners
    @scanner = Scanner.first
    page = @scanner.acquire
    if page && page.errors.empty?
      page.document = @document
      if page.save
        flash[:success] = "Page added to #{@document.name}"
      else
        flash[:error] = "Page scanned but failed to add to #{@document.name}\n" + page.errors.full_messages.join("\n")
      end
    else
      flash[:error] = "Failed to scan!\n" + @document.errors.full_messages.join("\n") 
    end
    redirect_to @document
  end

  private

  def document_params
    params.require(:document).permit(:name,
                                     :location,
                                     :tag_list,
                                     :relevant_date,
                                     form_pages: []
                                    )
  end

  def file_upload file
    if file.content_type == 'application/pdf'
      @document.index_pdf! file.tempfile
    else
      type = file.content_type.split('/').last
      @document.send("file_upload_#{type}".to_sym, file.tempfile)
    end
    @document.errors.empty?
  end

end
