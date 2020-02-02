# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Pundit
  before_action :authenticate_user!
  after_action :pundit_authorized, except: :index
  after_action :verify_policy_scoped, only: :index

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def pundit_authorized
    return if controller_path =~ /devise/
    verify_authorized
  end

  def user_not_authorized
    flash[:alert] = t('global.pundit.unauthorize')
    redirect_to(request.referrer || root_path)
  end

  def to_sentence(model)
    model.errors.full_messages.to_sentence
  end
end
