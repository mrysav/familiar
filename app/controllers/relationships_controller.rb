class RelationshipsController < ApplicationController
    before_filter :require_valid_user
    
    def create
        @person = Person.find(params[:person_id])
        other_person = Person.find(relationship_params[:other_person_id])
        @relationship = @person.relationships.create(relationship_params)
        corresponding_args = { :kind => Relationship.opposite(relationship_params[:kind], @person.gender, other_person.gender), :other_person_id => @person.id }
        # logger.info corresponding_args
        corresponding_rel = other_person.relationships.create(corresponding_args)
        redirect_to person_path(@person)
    end
    
    private
    
    def relationship_params
        params.require(:relationship).permit(:other_person_id, :kind)
    end
end
