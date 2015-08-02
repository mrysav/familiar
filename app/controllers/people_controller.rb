class PeopleController < ApplicationController
    before_filter :require_editor, except: [:index, :show]
    
    def index
        @people = Person.all.select{|p| p.can_see(current_user)}.paginate(:page => params[:page], :per_page => 15)
    end
    
    def new
        @person = Person.new
    end
    
    def create
        @person = Person.create(person_params)
        
        if @person.save
            redirect_to person_path(@person)
        else
            render 'new'
        end
    end
    
    def show
        @person = Person.find(params[:id])
        
        if !@person.can_see(current_user) then
            flash[:danger] = "You must be an editor to see the details of living people."
            redirect_to people_path
        end
    end
    
    def edit
        @person = Person.find(params[:id])
    end
    
    def update
        @person = Person.find(params[:id])
        
        if @person.update(person_params)
            redirect_to person_path(@person)
        else
            render 'edit'
        end
    end
    
    def destroy
    end
    
    def person_params
        params.require(:person).permit(:name, :gender, :date_of_birth, :date_of_death, :father_id, :mother_id, :current_spouse_id)
    end
end
