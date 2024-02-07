# frozen_string_literal: true

module Decidim
  module Slider
    module Admin
      # TODO: Remove when upgrading to Decidim 0.28
      class ReorderContentBlocks < Decidim::Admin::ReorderContentBlocks
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
          end

          if error.present?
            flash[:error] = error
          end
        end
      end
    end
  end
end
