class CommentsController < ApplicationController
  before_action :set_photo

  def create
    @comment = Comment.new(
      body: params[:body],
      photo_id: params[:photo_id],
      author_id: current_user.id
    )
  
    if @comment.save
      redirect_to photo_path(@comment.photo_id)
    else
      redirect_back(fallback_location: photos_path)
    end
  end

  private

  def set_photo
    @photo = Photo.find(params[:photo_id]) # Ensure `photo_id` comes from the nested route
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
