class ApplicationController < ActionController::API
  include JWTSessions::RailsAuthorization

  rescue_from JWTSessions::Errors::Unauthorized, with: :not_authorized

  private
    # def current_user
    #   # byebug
    #   @current_user ||= User.find(extract_payload['user_id'])
    # rescue => e
    #   Rails.logger.error "Payload: #{payload.inspect}"
    #   raise e
    # end

    # def extract_payload
    #   # byebug
    #   @payload ||= authorize_access_request!
    # end

    def not_authorized
      render json: { error: 'Not authorized' }, status: :unauthorized
    end
end
