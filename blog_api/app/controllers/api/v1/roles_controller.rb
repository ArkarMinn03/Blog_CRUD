class Api::V1::RolesController < ApplicationController
  def index
    roles = Role.all();
    render json: roles.as_json(except: [:created_at, :updated_at])
  end

  def show
    role = Role.find(params[:id])
    if role
      render json: role.as_json(except: [:created_at, :updated_at]), status: :ok
    else
      render json: [ 'msg' => 'role not found' ], status: :not_found
    end
  end
end