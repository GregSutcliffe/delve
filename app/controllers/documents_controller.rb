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
      if params[:document] && params[:document][:file]
        if params[:document][:file].content_type == 'application/pdf'
          @document.index_pdf! params[:document][:file].tempfile
        end
      end

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

  private

  def document_params
    params.require(:document).permit(:name,
                                     :location,
                                     :tag_list,
                                     :relevant_date,
                                     form_pages: []
                                    )
  end

end
