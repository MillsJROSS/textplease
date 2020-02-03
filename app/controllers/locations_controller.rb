# frozen_string_literal: true

class LocationsController < ApplicationController
  def index
    @game = authorize Game.find(params[:game_id])
    @locations = policy_scope @game, policy_scope_class: LocationPolicy::Scope
  end

  def new
    game = authorize Game.find(params[:game_id])
    @location = authorize Location.new(game: game)
  end

  def create
    game = authorize Game.find(params[:location][:game_id])
    @location = authorize Location.new(params.require(:location).permit(:name, :enter_location_text))
    @location.game = game

    if @location.save
      redirect_to locations_path(game_id: game.id), notice: t(".success")
      return
    end

    flash.now[:alert] = to_sentence(@location)
    render status: 400
  end
end
