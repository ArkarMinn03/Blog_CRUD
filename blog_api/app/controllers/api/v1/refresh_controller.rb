# class Api::V1::RefreshController < ApplicationController
#   include JWTSessions::RailsAuthorization

#   before_action :authorize_refresh_by_access_request!

#   def create
#     session = JWTSessions::Session.new(payload: access_payload, refresh_by_access_allowed: true)
#     tokens = session.refresh_by_access_payload do
#       raise JWTSessions::Errors::Unauthorized, "Malformed refresh token"
#     end

#     response.set_cookie(JWTSessions.access_cookie, value: tokens[:access], httponly: true, secure: Rails.env.production?)
#     render json: { access: tokens[:access] }
#   end

# end
