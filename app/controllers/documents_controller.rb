class DocumentsController < ApplicationController

  def index
    @documents = Document.all
  end

  def show
    @document = Document.find(params[:id])
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

  def destroy
    @document = Document.find(params[:id])
    @document.destroy

    flash[:success] = "Document deleted: #{@document.name}"
    redirect_to documents_path
  end

  private

  def document_params
    params.require(:document).permit(:name, :location)
  end

end
