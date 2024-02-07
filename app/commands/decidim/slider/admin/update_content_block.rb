# frozen_string_literal: true

module Decidim
  module Slider
    module Admin
      # TODO: Remove when upgrading to Decidim 0.28
      class UpdateContentBlock < Decidim::Admin::UpdateContentBlock
        def call
          images_valid = true

          transaction do
            update_content_block_settings

            # Saving the images will cause the image file validations to run
            # according to their uploader settings and the organization settings.
            # The content block validation will fail in case there are processing
            # errors on the image files.
            #
            # NOTE:
            # The images can be only stored correctly if the content block is
            # already persisted. This is not the case e.g. when creating a new
            # newsletter which uses the content blocks through newsletter
            # templates. This is why this needs to happen after the initial
            # `content_block.save!` call.
            update_content_block_images

            # The save method needs to be called another time in order to store
            # the image information.
            content_block.save!

            images_valid = false unless content_block.valid?
          end

          return broadcast(:invalid) unless images_valid

          broadcast(:ok, content_block)

        rescue StandardError
          broadcast(:invalid)
        end
      end
    end
  end
end
