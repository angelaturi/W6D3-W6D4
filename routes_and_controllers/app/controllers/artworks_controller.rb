class ArtworksController < ApplicationController
    def index
        if params.has_key?(:user_id)
            artworks = {}
            artworks[:artworks_owned] = Artwork.find_by(artist_id: params[:user_id])
            artworks[:shared] = Artwork.select('artworks.*')
            .joins(:shared_viewers)
            .where(users: { id: params[:user_id] } )
            # .left_outer_joins(:artwork_shares)
            # .where(artwork_shares: { viewer_id: params[:user_id] } )
        else 
            artworks = Artwork.all 
        end 

            render json: artworks
    end

    def show
        artwork = Artwork.find(params[:id])
        render json: artwork
    end

    def create
        artwork = Artwork.new(artwork_params)
        if artwork.save
            render json: artwork
        else 
             render json: artwork.errors.full_messages, status: 422
        end 
    end 



    def update
        artwork = Artwork.find(params[:id])      
        if artwork.update(artwork_params)
            render json: artwork
        else 
             render json: artwork.errors.full_messages, status: 422 
        end 
    end 


    def destroy
        artwork = Artwork.find(params[:id])

        if artwork.destroy
            render json: artwork
        else 
            render json: "can't destroy this artwork"
        end 

    end 

    def favorite
        # debugger
        artwork = Artwork.find_by(id: params[:id], artist_id: params[:user_id])
        # debugger
        artwork.favorite = true
        artwork.save
        render json: artwork
    end

    private 

    def artwork_params
        params.require(:artwork).permit(:title, :image_url, :artist_id) 
    end 
end