class Api::V1::SessionsController < ApplicationController
  include JWTSessions::RailsAuthorization

  before_action :authorize_access_request!, only: [:destroy, :refresh]

  def create
      user = User.find_by!(email: params[:email])
      if user&.authenticate(params[:password])
        if user.isBanned === 0
          payload = { user_id: user.id }
          session = JWTSessions::Session.new(payload: payload, refresh_by_access_allowed: true)
          tokens = session.login
          # byebug
          response.set_cookie(JWTSessions.access_cookie, value: tokens[:access], httponly: true, secure: Rails.env.production?)
          # byebug
          render json: { access: tokens[:access] }
        else
          render json: { errMsg: "You have been banned! Wait 120 days! haha"}, status: :forbidden
        end
      else
        render json: { errMsg: 'Invalid email or password'}, status: :unauthorized
      end
  end

  def refresh
    session = JWTSessions::Session.new(refresh_by_access_allowed: true)
    tokens = session.refresh_by_access_payload

    response.set_cookie(JWTSessions.access_cookie, value: tokens[:access], httponly: true, secure: Rails.env.production?)
    render json: { access: tokens[:access], refresh: tokens[:refresh] }
  end

  def destroy
    # byebug
    session = JWTSessions::Session.new(payload: payload)
    session.flush_by_access_payload
    render json: 'Logged out successfully', status: :ok
  end

end
