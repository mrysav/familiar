class CommentsController < ApplicationController
    before_filter :require_valid_user
    
    def create
        if(!current_user)
            flash[:warning] = "Must be logged in to comment."
        else
            @commentable = find_commentable
            @comment = @commentable.comments.create(comment_params)
            @comment.owner_id = current_user.id
            @comment.save
        end
        redirect_to @commentable
    end
    
    def destroy
        @commentable = find_commentable
        @comment = @commentable.comments.find(params[:id])
        
        if(@comment.owner_id != current_user.id && !current_user.editor)
            flash[:warning] = "Nice try, but you can't delete someone else's comments."
        else
            @comment.destroy
        end
        redirect_to @commentable
    end
 
    private
    def comment_params
        params.require(:comment).permit(:body)
    end
    
    def find_commentable
        params.each do |name, value|
            if name =~ /(.+)_id$/
                return $1.classify.constantize.find(value)
            end
        end
        nil
    end
end
