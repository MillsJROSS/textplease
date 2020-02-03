# frozen_string_literal: true

class LocationsController < ApplicationController
  before_action :set_and_authorize_game

  def index
    @locations = policy_scope @game, policy_scope_class: LocationPolicy::Scope
  end

  def new
    @location = authorize Location.new(game: @game)
  end

  def create
    @location = authorize Location.new(create_params)
    @location.game = @game

    if @location.save
      redirect_to locations_path(game_id: @game.id), notice: t(".success")
      return
    end

    flash.now[:alert] = to_sentence(@location)
    render status: 400
  end

  private

  def create_params
    params.require(:location).permit(:name, :enter_location_text)
  end

  def set_and_authorize_game
    @game = authorize Game.find(params[:game_id] || params[:location][:game_id])
  end
end
