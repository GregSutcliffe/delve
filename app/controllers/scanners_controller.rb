class ScannersController < ApplicationController

  def index
    @scanners = Scanner.paginate(page: params[:page])
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
      flash[:success] = "Scanner created!"
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
    page = @scanner.acquire
    if page && page.save
      flash[:success] = "Page acquired!"
    else
      flash[:error] = "Page failed to acquire!"
    end
    redirect_to @scanner
  end

  private

  def post_params
    params.require(:scanner).permit(:name, :device_url)
  end

end
