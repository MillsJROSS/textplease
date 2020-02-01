# frozen_string_literal: true

module I18nHelpers
  def t(args)
    I18n.t(*args)
  end
end
