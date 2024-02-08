# frozen_string_literal: true

module Decidim
  module Slider
    module Admin
      # TODO: Remove when upgrading to Decidim 0.28
      class ReorderContentBlocks < Decidim::Admin::ReorderContentBlocks
        def call
          return broadcast(:invalid) if order.blank?

          reorder_steps
          broadcast(:ok)
        rescue StandardError
          broadcast(:invalid, "Error while reordering content blocks")
        end

        private

        def set_new_weights
          data = order.each_with_index.inject({}) do |hash, (id, index)|
            hash.update(id => index + 1)
          end

          error = nil

          data.each do |id, weight|
            content_block = collection.find_by(id: id)
            content_block.update!(weight: weight) if content_block.present?

            next unless content_block.errors.any?

            error = content_block.errors.full_messages.join(", ")
            title = translated_attribute(content_block.settings.title).presence || content_block.manifest_name
            error = t("decidim.content_blocks.update.error", title: title, error: error)

          end

          if error.present?
            flash[:error] = error
            raise StandardError, error
          end
        end

        def translated_attribute(attribute)
          return unless attribute.is_a?(Hash)

          attribute[I18n.locale] || attribute.values.first
        end
      end
    end
  end
end
