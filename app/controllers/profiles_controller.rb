class ProfilesController < ApplicationController
  def index
    @profiles = Profile.all

    @profiles = @profiles.where(gender: params[:gender]) if params[:gender].present?
    @profiles = @profiles.where(category: params[:category]) if params[:category].present?
    @categories = Profile.distinct.pluck(:category).sort
    @profiles = @profiles.page(params[:page]).per(25)
  end
end
