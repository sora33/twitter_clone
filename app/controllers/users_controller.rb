# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :authenticate_user!, only: %i[show edit update]
  before_action :set_user, only: %i[show retweets comments likes]

  def show
    @tweets = @user.ordered_tweets.page(params[:page])
  end

  def edit
    @user = current_user
  end

  def update
    if current_user.update(user_params)
      redirect_to current_user, notice: 'プロフィールを変更できました。'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def retweets
    @tweets = @user.ordered_retweets.page(params[:page])
    render :show
  end

  def comments
    @tweets = @user.ordered_comments.page(params[:page])
    render :show
  end

  def likes
    @tweets = @user.ordered_likes.page(params[:page])
    render :show
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :profile_image, :header_image, :description, :place, :website, :birthday)
  end
end