class PeopleController < ApplicationController
    
    def index
        @people = Person.all.paginate(:page => params[:page])
    end
    
    def new
        @person = Person.new
    end
    
    def create
        @person = Person.create(person_params)
        
        if @person.save
            redirect_to people_path
        else
            render 'errsav'
        end
    end
    
    def update
    end
    
    def destroy
    end
    
    def person_params
        params.require(:person).permit(:name, :date_of_birth, :date_of_death)
    end
end
