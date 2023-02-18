# frozen_string_literal: true

module Decidim
  module Slider
    module Admin
      # A command with all the business logic to destroy a content block
      # REMOVE ME after Decidim 0.28 upgrade
      class DestroyContentBlock < Rectify::Command
        # Public: Initializes the command.
        #
        # content_block - The content_block to destroy
        def initialize(content_block)
          @content_block = content_block
        end

        # Executes the command. Broadcasts these events:
        #
        # - :ok when everything is valid.
        # - :invalid if the form wasn't valid and we couldn't proceed.
        #
        # Returns nothing.
        def call
          destroy_content_block
          broadcast(:ok)
        rescue StandardError
          broadcast(:invalid)
        end

        private

        def destroy_content_block
          @content_block.destroy!
        end
      end
    end
  end
end
