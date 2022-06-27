class TweetsController < ApplicationController
    before_action :set_tweet, only: [:edit, :show]
    before_action :move_to_index, except: [:index, :show, :search]
    
    def index
        @tweets = Tweet.includes(:user).order("created_at desc")
    end
    
    def new
        @tweet = Tweet.new
    end
    
    def create
        Tweet.create(tweet_params)
        redirect_to action: :index
    end
    
    def edit
    end
    
    def update
        tweet = Tweet.find(params[:id])
        tweet.update(tweet_params)
        redirect_to action: :index
    end
    
    def show
        @comment = Comment.new
        @comments = @tweet.comments.includes(:user)
    end
    
    def destroy
        tweet = Tweet.find(params[:id])
        tweet.destroy
        redirect_to action: :index
    end
    
    def search
        @tweets = Tweet.search(params[:keyword])
    end
    
    private
    def tweet_params
        params.require(:tweet).permit(:text).merge(user_id: current_user.id)
    end
    
    def set_tweet
        @tweet = Tweet.find(params[:id])
    end
    
    def move_to_index
        unless user_signed_in?
            redirect_to action: :index
        end
    end
    
end
