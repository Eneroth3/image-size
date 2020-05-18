module Eneroth
  module ImageSize
    # Get and set size from selection.
    module ObjectSize
      # Check if the selection is valid (an image or a face with a texture).
      #
      # @return [Boolean]
      def self.valid?
        entity = Sketchup.active_model.selection.first

        return true if entity.is_a?(Sketchup::Image)
        return false unless entity.is_a?(Sketchup::Face)

        !!entity.material.texture
      end

      def self.dpi
        entity = Sketchup.active_model.selection.first
        case entity
        when Sketchup::Image
          entity.pixelwidth / entity.width
        when Sketchup::Face
          # TODO: Get texture size...
        end
      end

      def self.dpi=(dpi)
        entity = Sketchup.active_model.selection.first
        case entity
        when Sketchup::Image
          entity.width = entity.pixelwidth * dpi
          entity.height = entity.pixelheight * dpi
        when Sketchup::Face
          # TODO: Set texture size...
        end
      end
    end
  end
end