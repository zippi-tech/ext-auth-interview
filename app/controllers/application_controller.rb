class ApplicationController < ActionController::API
  rescue_from ActionController::ParameterMissing, with: :render_bad_request
  rescue_from ActiveRecord::RecordNotFound, with: :render_bad_request
  rescue_from ArgumentError, with: :render_bad_request

  private
  def render_bad_request
    render status: :bad_request
  end
end
