# frozen_string_literal: true

class Public::LandingPageController < ApplicationController
  skip_before_action :authenticate_user!

  def show
    authorize %i[public landing_page]
  end
end
