class UsersController < ApplicationController
  before_action :set_user, only: [:show]
  skip_before_action :authenticate_user!, only: [:index]

  def index
    @users = User.all
    @follow_statuses = user_signed_in? ? current_user.sent_follow_requests.pluck(:recipient_id, :status).to_h : {}
  end

  def show
    # Redirect if user not found
    unless @user
      redirect_to root_path, alert: "User not found."
      return
    end

    # Redirect if the profile is private and access is unauthorized
    if @user.private?
      if !user_signed_in?
        redirect_to root_path, alert: "You must be signed in to view this user's profile."
        return
      elsif !@user.received_follow_requests.where(sender: current_user, status: 'accepted').exists?
        redirect_to root_path, alert: "You do not have permission to view this user's profile."
        return
      end
    end

    @follow_statuses = user_signed_in? ? current_user.sent_follow_requests.pluck(:recipient_id, :status).to_h : {}

    # Determine which section to display
    @show_section = params[:show_section] || 'own'
    @photos = fetch_photos(@show_section)
  end

  private

  def set_user
    @user = User.find_by(id: params[:id])
    redirect_to root_path, alert: "User not found." unless @user
  end

  def fetch_photos(section)
    case section
    when 'feed'
      followed_users_ids = current_user.sent_follow_requests.where(status: 'accepted').pluck(:recipient_id)
      Photo.where(owner_id: followed_users_ids).order(created_at: :desc)
    when 'liked_photos'
      @user.liked_photos
    when 'discover'
      followed_users_ids = @user.following.pluck(:id)
      Photo.joins(:likes).where(likes: { fan_id: followed_users_ids }).distinct
    else
      @user.photos
    end || []
  end
end
