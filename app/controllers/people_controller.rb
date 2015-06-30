class PeopleController < ApplicationController
    
    def index
        @people = Person.all.paginate(:page => params[:page])
    end
    
    def new
    end
    
    def create
    end
    
    def update
    end
    
    def destroy
    end
    
end
