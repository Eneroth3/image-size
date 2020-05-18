# frozen_string_literal: true

require "extensions.rb"

# Eneroth Extensions
module Eneroth
  # Image Size
  module ImageSize
    # Correct for encoding issue in Windows.
    # https://sketchucation.com/forums/viewtopic.php?f=180&t=57017
    path = __FILE__.dup
    path.force_encoding("UTF-8") if path.respond_to?(:force_encoding)

    # Identifier for this extension.
    PLUGIN_ID = File.basename(path, ".*")

    # Root directory of this extension.
    PLUGIN_ROOT = File.join(File.dirname(path), PLUGIN_ID)

    # Extension object for this extension.
    EXTENSION = SketchupExtension.new(
      "Eneroth Image Size",
      File.join(PLUGIN_ROOT, "main")
    )

    EXTENSION.creator     = "Julia Christina Eneroth"
    EXTENSION.description = "Size image to exact scales."
    EXTENSION.version     = "1.0.0"
    EXTENSION.copyright   = "2020 #{EXTENSION.creator}"
    Sketchup.register_extension(EXTENSION, true)
  end
end
