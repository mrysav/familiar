class NotesController < ApplicationController
    before_filter :require_editor, except: [:index, :show]
    
    def index
        @notes = Note.all.paginate(:page => params[:page])
    end
    
    def new
        @note = Note.new
    end
    
    def create
        @note = Note.create(note_params)
        
        if @note.save
            redirect_to note_path(@note)
        else
            render 'new'
        end
    end
    
    def show
        @note = Note.find(params[:id])
        @commentable = @note
    end
    
    def edit
        @note = Note.find(params[:id])
    end
    
    def update
        @note = Note.find(params[:id])
        
        if @note.update(note_params)
            redirect_to note_path(@note)
        else
            render 'edit'
        end
    end
    
    def destroy
        @note = Note.find(params[:id])
        @note.destroy
        flash[:success] = "Note deleted."
        redirect_to notes_path
    end
    
    private
    
    def note_params
        params.require(:note).permit(:title, :date, :content, :tag_list)
    end
end
