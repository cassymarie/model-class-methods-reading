class PostsController < ApplicationController
  #helper_method :params #Reading params is a controller concern, so we don't need to expose it to the views
  
  def index
  # provide a list of authors to the view for the filter control
  @authors = Author.all
  
  #Step 3
  # separation of concerns, the controller should NOT have deep knowledge of the database and make direct queries.
  # filter the @posts list based on user input
    if !params[:author].blank?
      #Step3:  @posts = Post.where(author: params[:author])
      @posts = Post.by_author(params[:author]) #use a helper instead

    elsif !params[:date].blank?
      if params[:date] == "Today"
        #Step3:  @posts = Post.where("created_at >=?", Time.zone.today.beginning_of_day)
        @posts = Post.from_today
      else
        #Step3:  @posts = Post.where("created_at <?", Time.zone.today.beginning_of_day)
        @posts = Post.old_news
      end
    else
      # if no filters are applied, show all posts
      @posts = Post.all
    end
  end

  def show
    @post = Post.find(params[:id])
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(params)
    @post.save
    redirect_to post_path(@post)
  end

  def update
    @post = Post.find(params[:id])
    @post.update(params.require(:post))
    redirect_to post_path(@post)
  end

  def edit
    @post = Post.find(params[:id])
  end
end
