class PostsController < ApplicationController
  before_action :set_post, only: %i[show edit update destroy]
  before_action :authenticate_user!, except: %i[show index]
  # GET /posts or /posts.json
  def index
    @posts = Post.includes(:user, images_attachments: :blob).order(created_at: :desc)
  end

  # GET /posts/1 or /posts/1.json
  def show
    @post.update(views: @post.views + 1)
    @comments = @post.comments.includes(:user).order(created_at: :desc)

    ahoy.track 'Viewed Post', post_id: @post.id

    mark_notifications_as_read
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit; end

  # POST /posts or /posts.json
  def create
    @post = Post.new(post_params)
    @post.user = current_user

    respond_to do |format|
      if @post.save
        format.html { redirect_to post_url(@post), notice: 'Post was successfully created.' }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1 or /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to post_url(@post), notice: 'Post was successfully updated.' }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1 or /posts/1.json
  def destroy
    @post.destroy

    respond_to do |format|
      format.html { redirect_to posts_url, notice: 'Post was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_post
    @post = Post.find_by(slug: params[:id])

    if @post.nil?
      render file: "#{Rails.root}/public/404.html", status: :not_found and return
    end

    # If an old id or a numeric id was used to find the record, then
    # the request slug will not match the current slug, and we should do
    # a 301 redirect to the new path
    if params[:id] != @post.slug
      redirect_to @post, status: :moved_permanently and return
    end
  end

  # Only allow a list of trusted parameters through.
  def post_params
    params.require(:post).permit(:title, :body, :category_id, images: [])
  end

  def mark_notifications_as_read
    if current_user
      notifications_to_mark_as_read = @post.notifications_as_post.where(recipient: current_user)
      notifications_to_mark_as_read.update_all(read_at: Time.zone.now)
    end
  end
end
