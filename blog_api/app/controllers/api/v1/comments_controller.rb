class Api::V1::CommentsController < ApplicationController
  before_action :authorize_access_request!, except: [:index]
  before_action :set_blog
  before_action :set_comment, only: [:destroy, :update, :show]

  def index
    comments = @blog.comments

    render json: {
      comment: comments.as_json(include: { user: { only: [:id, :name] } })
    }
  end

  def show
    render json: @comment
  end

  def create
    @comment = @blog.comments.new(comment_params)

    if @comment.save
      render json: @comment, status: :created
    else
      render json: @comment.error, status: :unprocessable_entity
    end
  end

  def destroy
    # @comment = @blog.comments.find(params[:id])
    @comment.destroy!

    render status: :ok
  end

  def update
    # @comment = @blog.comments.find(params[:id])
    if @comment.update(comment_params)
      render json: @comment
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end

  private
    def set_blog
      @blog = Blog.find(params[:blog_id]);
    end

    def set_comment
      @comment = @blog.comments.find(params[:id])
    end

    def comment_params
      params.permit(:comment, :user_id)
    end
end