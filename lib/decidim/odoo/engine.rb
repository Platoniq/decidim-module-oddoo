# frozen_string_literal: true

require "omniauth/strategies/odoo_keycloak"

module Decidim
  module Odoo
    # This is the engine that runs on the public interface of odoo.
    class Engine < ::Rails::Engine
      isolate_namespace Decidim::Odoo

      initializer "decidim_odoo.omniauth" do
        next unless Decidim::Odoo.keycloak_omniauth && Decidim::Odoo.keycloak_omniauth[:client_id]

        Rails.application.config.middleware.use OmniAuth::Builder do
          provider :odoo_keycloak, Decidim::Odoo.keycloak_omniauth[:client_id], Decidim::Odoo.keycloak_omniauth[:client_secret],
                   client_options: Decidim::Odoo.keycloak_omniauth[:client_options]
        end
      end

      initializer "decidim_odoo.webpacker.assets_path" do
        Decidim.register_assets_path File.expand_path("app/packs", root)
      end
    end
  end
end
