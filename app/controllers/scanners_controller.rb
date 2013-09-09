class ScannersController < ApplicationController

  def index
    @scanners = Scanner.all
  end

  def show
    @scanner = Scanner.find(params[:id])
  end

  def new
    @scanner = Scanner.new
  end

  def create
    @scanner = Scanner.new(post_params)

    if @scanner.save
      redirect_to @scanner
    else
      render 'new'
    end
  end

  def edit
    @scanner = Scanner.find(params[:id])
  end

  def update
    @scanner = Scanner.find(params[:id])

    if @scanner.update(params[:scanner].permit(:name, :device_url))
      redirect_to @scanner
    else
      render 'edit'
    end
  end

  def destroy
    @scanner = Scanner.find(params[:id])
    @scanner.destroy

    redirect_to scanners_path
  end

  def acquire
    @scanner = Scanner.find(params[:id])
    @scanner.get_image
    redirect_to :back
  end

  private

  def post_params
    params.require(:scanner).permit(:name, :device_url)
  end

end
