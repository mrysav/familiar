class CommentsController < ApplicationController
    before_filter :require_valid_user
    
    def create
        if(!current_user)
            flash[:warning] = "Must be logged in to comment."
            render 'photo/show'
        end
        
        @photo = Photo.find(params[:photo_id])
        @comment = @photo.comments.create(comment_params)
        @comment.owner_id = current_user.id
        
        if(@comment.save)
            redirect_to photo_path(@photo)
        else
            render 'photo/show'
        end
    end
 
    private
    def comment_params
        params.require(:comment).permit(:body)
    end
end
