class Api::V1::UsersController < ApplicationController
  before_action :authorize_access_request!, except: [:create]
  before_action :set_user, except: [:index, :create]

  def index
    user = User.all();
    render json: user.as_json(except: [:password_digest, :updated_at]), status: :ok
  end

  def create
    user = User.new(user_params)
    if user.save
      render json: { message: 'User created successfully' }, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def show
    if @user
      render json: @user.as_json(except: [:password_digest, :updated_at, :created_at])
    else
      render json: { errors: "user not found" }, status: :not_found
    end
  end

  def update
    if @user.update(name: params[:name], email: params[:email])
      render json: {
        message: 'Account detail updated!',
        user: @user.as_json(except: [:password_digest, :updated_at, :created_at])
      },status: :ok
    else
      render json: @user.errors_full_message, status: :unprocessable_entity
    end
  end

  def destroy
    if @user.destroy
      render json: { message: 'User deleted successfully.' }, status: :ok
    else
      render json: @user.errors_full_message
    end
  end

  def update_password
    if @user.authenticate(params[:old_password])
      if params[:password] == params[:confirm_password]
        if @user.update(password: params[:password])
          render json: { message: "Password updated successfully." }, status: :ok
        else
          render json: { error: @user.errors_full_message }
        end
      else
        render json: { error: "Password and confirm password are not match!" }
      end
    else
      render json: { error: "Old password incorrect" }
    end
  end

  def update_role
    if @user.update(role_value: params[:role_value])
      render json: {
        message: 'Role updated successfully',
        user: @user.as_json(except: [:password_digest, :updated_at, :created_at])
      }, status: :ok
    else
      render json: @user.errors_full_message, status: :unprocessable_entity
    end
  end

  def update_ban_status
    if @user.update(isBanned: params[:isBanned])
      render json: {
        message: 'Ban status updated successfully',
        user: @user.as_json(except: [:password_digest, :updated_at, :created_at])
      }, status: :ok
    else
      render json: @user.errors_full_message, status: :unprocessable_entity
    end
  end

  private
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation, :role_value)
    end

    def set_user
      @user = User.find(params[:id])
    end
end
