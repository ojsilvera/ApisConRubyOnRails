class PostsController <  ApplicationController

  def index
    @posts = Post.where(published: true)
    render json: @posts, status: :ok
  end

  def show
    @post = Post.find(params[:id])
    render json: @post, status: :ok
  end

  # def edit; end

  def update
    @post = Post.find(params[:id])
  end

  # def new; end

  def create
    @post = Post.create!(create_params)
    render json: @post, status: :create
  end

  def delete; end

  private

  def create_params
    params.require(:post).permit(:title, :content, :published, :user_id)
  end

  def update_params
    params.require(:post).permit(:title, :content, :published)
  end
end
