# app/controllers/concerns/authenticable.rb

module Authenticable
  extend ActiveSupport::Concern
  
  private
  
  def current_user
    return @current_user if @current_user
    
    token = extract_token_from_header
    return nil unless token
    
    decoded = JsonWebToken.decode(token)
    return nil unless decoded
    
    @current_user = User.find_by(id: decoded[:user_id])
  end
  
  def authenticate_user!
    unless current_user
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
  end
  
  def extract_token_from_header
    header = request.headers['Authorization']
    return nil unless header
    
    header.split(' ').last if header.present?
  end
  
  def authorize_user!(resource)
    unless resource.user_id == current_user.id || resource.creator_id == current_user.id
      render json: { error: 'Forbidden' }, status: :forbidden
    end
  end
end