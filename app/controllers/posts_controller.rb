class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user! , except: [:index]
  def index
    @posts = Post.order(created_at: :desc).page(params[:page]).per(5)
    respond_to do |format|
      format.html
      format.json{render json: @posts}
    end
  end

  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.new(post_params)
    respond_to do |format|
      #format.html{render :new}
      #format.json{render json: @posts}
    if @post.save
        #저장이 되었을 경우에 실행
      #flash[:notice]="글 작성이 완료되었습니다."
        #redirect_to "/"
        format.html{redirect_to '/', notice:'success'}
    else
      #저장이 실패했을경우에(validation) 걸렸을 때 실행
      # flash[:alert]="글 작성이 실패하였습니다."
      # redirect_to new_post_path
      format.html{render :new}
      format.json{render json: @post.errors}
    end
  end

  end

  def show
    @comments = @post.comments
  end

  def edit
  end

  def update
    @post.update(post_params)
    redirect_to "/posts/#{@post.id}"
  end

  def destroy
    @post.destroy
    redirct_to "/"
  end

  private
  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:title, :content)
  end
end
