class PeopleController < ApplicationController
    before_action :authenticate_admin!, except: [:index, :show]
    
    def index
        @people = Person.all.select{|p| p.can_be_seen_by(current_user)}.paginate(:page => params[:page], :per_page => 24)
    end
    
    def new
        @person = Person.new
        @all_names = Person.all.collect { |p| [ p.full_name, p.id ] }
        @all_names.sort_by! {|p| p[0] }
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
        
        if !@person.can_be_seen_by(current_user) then
            flash[:danger] = "You must be an editor to see the details of this person."
            @person = nil
            redirect_to people_path
        end
    end
    
    def edit
        @person = Person.find(params[:id])
        @all_names = Person.all.reject { |p| p.id == @person.id }.collect { |p| [ p.full_name, p.id ] }
        @all_names.sort_by! {|p| p[0] }
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
    
    private

    def person_params
        params.require(:person).permit(:first_name, :last_name, 
                                       :gender, :date_of_birth, :date_of_death, 
                                       :father_id, :mother_id, :current_spouse_id,
                                       :birthplace, :burialplace)
    end
end
