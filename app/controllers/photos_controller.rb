class PhotosController < ApplicationController
    before_action :authenticate_admin!, except: [:index, :show]
    
    def index
        @photos = Photo.all.paginate(:page => params[:page])
    end
    
    def new
        @photo = Photo.new
    end
    
    def create
        @photo = Photo.create(photo_params)
        
        if @photo.save
            redirect_to photo_path(@photo)
        else
            render 'new'
        end
    end
    
    def show
        @photo = Photo.find(params[:id])
        @commentable = @photo
    end
    
    def edit
        @photo = Photo.find(params[:id])
    end
    
    def update
        @photo = Photo.find(params[:id])
        
        if @photo.update(photo_params)
            redirect_to photo_path(@photo)
        else
            render 'edit'
        end
    end
    
    def destroy
        @photo = Photo.find(params[:id])
        @photo.destroy
        flash[:success] = "Photo deleted."
        redirect_to photos_path
    end
    
    private
    
    def photo_params
        params.require(:photo).permit(:title, :date, :image, :image_cache, :description, :tag_list)
    end
end
