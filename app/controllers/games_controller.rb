# frozen_string_literal: true

class GamesController < ApplicationController
  def index
    @games = policy_scope(Game)
  end

  def new
    @game = authorize Game.new(created_by: current_user)
  end

  def create
    @game = authorize Game.new(params.require(:game).permit(:name, :created_by_id))

    if @game.save
      flash[:notice] = t(".success")
      redirect_to games_path
      return
    end

    flash.now[:alert] = to_sentence(@game)
    render status: 400
  end

  def show
    @game = authorize Game.find(params[:id])
  end

  def edit
    @game = authorize Game.find(params[:id])
  end

  def update
    @game = authorize Game.find(params[:id])

    if @game.update(update_params)
      redirect_to game_path(@game), notice: t(".success")
      return
    end

    flash.now[:alert] = to_sentence(@game)
    render status: 400
  end

  def destroy
    @game = authorize Game.find(params[:id])
    @game.destroy!
    redirect_to games_path, notice: t(".success")
  end

  private

  def update_params
    params.require(:game).permit(:name)
  end
end
