module Api
  module V1
    class AuthController < ApplicationController
      skip_before_action :authenticate_user!, only: [:signup, :login]
      
      def signup
        user = User.new(signup_params)
        
        if user.save
          token = JsonWebToken.encode(user_id: user.id)
          
          render json: {
            message: 'User created successfully',
            token: token,
            user: {
              id: user.id,
              email: user.email,
              username: user.username,
              vetos_remaining: user.vetos_remaining
            }
          }, status: :created
        else
          render json: {
            error: 'Signup failed',
            messages: user.errors.full_messages
          }, status: :unprocessable_entity
        end
      end
      
      def login
        user = User.find_by(email: login_params[:email].downcase)
        
        if user && user.authenticate(login_params[:password])
          token = JsonWebToken.encode(user_id: user.id)
          
          render json: {
            message: 'Login successful',
            token: token,
            user: {
              id: user.id,
              email: user.email,
              username: user.username,
              vetos_remaining: user.vetos_remaining,
              unused_dictator_tokens: user.unused_dictator_tokens_count
            }
          }, status: :ok
        else
          render json: {
            error: 'Invalid email or password'
          }, status: :unauthorized
        end
      end
      
      def me
        render json: {
          user: {
            id: current_user.id,
            email: current_user.email,
            username: current_user.username,
            vetos_remaining: current_user.vetos_remaining,
            unused_dictator_tokens: current_user.unused_dictator_tokens_count,
            current_win_streak: current_user.win_streak&.current_streak || 0
          }
        }, status: :ok
      end
      
      private
      
      def signup_params
        params.require(:user).permit(:email, :username, :password, :password_confirmation)
      end
      
      def login_params
        params.require(:user).permit(:email, :password)
      end
    end
  end
end