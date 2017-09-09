class UsersController < ApplicationController
    before_action :require_editor, only: [:manage]
    before_action :require_valid_user, only: [:profile]
    
    def manage
        @users = User.all.order('editor ASC, name').paginate(:page => params[:page], :per_page => 50)
    end
    
    def profile
        @user = User.find(current_user.id)
    end
end
