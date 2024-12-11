class UsersController < ApplicationController
  before_action :set_user, only: [:show]
  skip_before_action :authenticate_user!, only: [:index]

  def index
    @users = User.all
    @follow_statuses = user_signed_in? ? current_user.sent_follow_requests.pluck(:recipient_id, :status).to_h : {}
  end

  def show
    @user = User.find(params[:id])
    @show_section = params[:show_section] || "own"

    @photos = case @show_section
    when "own"
      @user.photos.order(created_at: :desc)  # Show user's own photos by default
    when "liked_photos"
      @user.likes.includes(:photo).order(created_at: :desc).map(&:photo)
    when "feed"
      followed_user_ids = @user.sent_follow_requests
                              .where(status: 'accepted')
                              .pluck(:recipient_id)
      Photo.where(user_id: followed_user_ids).order(created_at: :desc)
    when "discover"
      Photo.where(user: User.discoverable_by(@user))
    end

    @follow_statuses = current_user ? get_follow_statuses : {}
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
