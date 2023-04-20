class PostsController < ApplicationController
  before_action :set_post, only: %i[ show edit update destroy ]

  require 'csv'

  def import
   # file = params[:file]
  
   # file = File.open(file)
   # csv = CSV.parse(file, headers: true, col_sep: ';' )

   # csv.each do |row|
   #   post_hash = {}
   #   post_hash[:name] = row[1] 
   #   Post.create(post_hash)
   # end
  
    redirect_to posts_path, notice: "Posts imported."
  end
  

  def index
    @posts = Post.all
    respond_to do |format|
      format.html
      format.pdf do
        render pdf: "Posts", template: "posts/index", formats: [:html]
      end
    end
  end
  
  def show
  #  PostMailer.new_post.deliver_later

    respond_to do |format|
      format.html
      format.pdf do
        respond_to do |format|
          format.html
          format.pdf do
            render pdf: [@post.id, @post.name].join('-'),
                    template: "posts/show",
                    formats: [:html],
                    disposition: :inline,
                    layout: 'pdf'
          end
        end
      end
    end
  end

  def new
    @post = Post.new 
  end

  def new_multiple
    @posts = []
    2.times { @posts << Post.new }
  end

  def edit
    @quantites = [1, 2]
  end

  def create
    params[:posts].each do |index, post_params|
      Post.create(post_params.permit(:title, :content))
    end
    redirect_to posts_path
  end
  

  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to post_url(@post), notice: "Post was successfully updated." }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @post.destroy

    respond_to do |format|
      format.html { redirect_to posts_url, notice: "Post was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
     def set_post
      @post = Post.find(params[:id])
    end

    def post_params
      params.require(:post).permit(:name, :title, :content, :quantite, :avatar, images:[])
    end
end
