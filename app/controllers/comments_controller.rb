class CommentsController < ApplicationController
    before_filter :require_valid_user
    
    def create
        if(!current_user)
            flash[:warning] = "Must be logged in to comment."
        else
            @photo = Photo.find(params[:photo_id])
            @comment = @photo.comments.create(comment_params)
            @comment.owner_id = current_user.id
            @comment.save
        end
        redirect_to photo_path(@photo)
    end
    
    def destroy
        @photo = Photo.find(params[:photo_id])
        @comment = @photo.comments.find(params[:id])
        
        if(@comment.owner_id != current_user.id && !current_user.editor)
            flash[:warning] = "Nice try, but you can't delete someone else's comments."
        else
            @comment.destroy
        end
        redirect_to photo_path(@photo)
    end
 
    private
    def comment_params
        params.require(:comment).permit(:body)
    end
end
