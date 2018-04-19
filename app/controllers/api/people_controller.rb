class Api::PeopleController < Api::ApiController
    before_action :authenticate_user!

    def index
    end

    def show
        begin
            @person = Person.find(params[:id])
            if(@person.can_be_seen_by(current_user)) then
                render :json => @person.to_gedx_json
            else
                raise ActiveRecord::RecordNotFound
            end
        rescue ActiveRecord::RecordNotFound
            render :json => { :error => "Person not found" }, :status => 404
        rescue
            render :json => { :error => "An error occurred"}, :status => 500
        end
    end

end