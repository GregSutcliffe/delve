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

  private

  def document_params
    params.require(:document).permit(:name, :location, :tag_list)
  end

end
