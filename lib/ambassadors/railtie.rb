# frozen_string_literal: true

require "rails/railtie"

module Ambassadors
  ##
  # Hooks into the Rails boot process when the gem is loaded inside a Rails application.
  # @see https://api.rubyonrails.org/classes/Rails/Railtie.html
  class Railtie < Rails::Railtie
    ##
    # Includes +ActiveModel::Serialization+ in {::Ambassador} when ActiveModel is
    # available, so exposed properties can be serialised.
    initializer "ambassadors.active_model_serialization" do
      ActiveSupport.on_load(:active_model) do
        if defined?(::Ambassador) && defined?(::ActiveModel::Serialization)
          ::Ambassador.include(ActiveModel::Serialization)
        end
      end
    end
  end
end
