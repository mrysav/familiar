class UsersController < ApplicationController
    before_filter :require_editor, only: [:manage]
    
    def manage
        @users = User.all.paginate(:page => params[:page], :per_page => 50)
    end
end
