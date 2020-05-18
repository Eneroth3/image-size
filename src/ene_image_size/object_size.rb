module Eneroth
  module ImageSize
    # Get and set size from selection.
    module ObjectSize
      # Check if the selection is valid (an image or a face with a texture).
      #
      # @return [Boolean]
      def self.valid?
        return false unless Sketchup.active_model.selection.size == 1

        Sketchup.active_model.selection.first.is_a?(Sketchup::Image)
      end

      def self.dpi
        entity = Sketchup.active_model.selection.first

        entity.pixelwidth / entity.width
      end

      def self.dpi=(dpi)
        entity = Sketchup.active_model.selection.first

        entity.width = entity.pixelwidth * dpi
        entity.height = entity.pixelheight * dpi
      end
    end
  end
end