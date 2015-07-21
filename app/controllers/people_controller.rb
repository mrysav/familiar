class PeopleController < ApplicationController
    before_filter :require_valid_user, except: [:index, :show]
    
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
    
    def show
        @person = Person.find(params[:id])
    end
    
    def edit
        @person = Person.find(params[:id])
    end
    
    def update
        @person = Person.find(params[:id])
        
        if @person.update(person_params)
            redirect_to people_path
        else
            render 'errsav'
        end
    end
    
    def destroy
    end
    
    def person_params
        params.require(:person).permit(:name, :gender, :date_of_birth, :date_of_death)
    end
end
