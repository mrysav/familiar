class SearchController < ApplicationController
    def index
        @results = PgSearch.multisearch(params[:s]).paginate(:page => params[:p], :per_page => 10)
    end
    
    def help
    end
end
