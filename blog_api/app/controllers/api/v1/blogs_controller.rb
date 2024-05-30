class Api::V1::BlogsController < ApplicationController
  before_action :authorize_access_request!, except: [:index, :show]

  before_action :set_blog, only: %i[ show update destroy ]

  # GET /blogs
  def index
    # render json: { message: "Blog index"}
    @blogs = Blog.order(created_at: :desc)
    render json: {
      blogs: @blogs.as_json(
        except: [:user_id, :updated_at],
        methods: :comment_count,
        include: { user: { only: [:id, :name, :role_value] } })
    }
  end

  # GET /blogs/1
  def show
    render json: {
      blog: @blog.as_json(
        except: [:user_id, :updated_at],
        include: { user: { only: [:id, :name] } })
    }
  end

  # POST /blogs
  def create
    # byebug
    @blog = Blog.new(blog_params)
    if @blog.save!
      render json: { message: 'Blog created successfully' }, status: :created
    else
      render json: @blog.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /blogs/1
  def update
    if @blog.update(blog_params)
      render json: @blog
    else
      render json: @blog.errors, status: :unprocessable_entity
    end
  end

  # DELETE /blogs/1
  def destroy
    @blog.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_blog
      @blog = Blog.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def blog_params
      params.require(:blog).permit(:title, :content, :user_id)
    end
end
