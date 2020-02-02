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
      flash[:notice] = t('.success')
      redirect_to games_path
      return
    end

    flash.now[:alert] = to_sentence(@game)

    render status: 400
  end
end
