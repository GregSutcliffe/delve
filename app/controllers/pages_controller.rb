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
    @doc = @page.document
    @page.destroy

    redirect_to @doc
  end

  def upload
    @page = Page.new
  end

end
