module Eneroth
  module ImageSize
    Sketchup.require "#{PLUGIN_ROOT}/vendor/scale"
    Sketchup.require "#{PLUGIN_ROOT}/object_size"
    Sketchup.require "#{PLUGIN_ROOT}/observers"

    # Dialog for setting size of selected image.
    module Dialog
      # Message for invalid selection.
      INVALID_SEL = "No Image selected"

      @scale = Scale.new("1:100")
      @dpi = 300

      # Show dialog.
      def self.show
        if visible?
          @dialog.bring_to_front
        else
          create_dialog unless @dialog
          @dialog.set_file("#{PLUGIN_ROOT}/dialog.html")
          attach_callbacks
          @dialog.show
        end
        @observer = SelectionObserver.new { on_selection_change }
      end

      # Hide dialog.
      def self.hide
        @dialog.close
      end

      # Check whether dialog is visible.
      #
      # @return [Boolean]
      def self.visible?
        @dialog && @dialog.visible?
      end

      # Toggle visibility of dialog.
      def self.toggle
        visible? ? hide : show
      end

      # Get SketchUp UI command state for dialog visibility state.
      #
      # @return [MF_CHECKED, MF_UNCHECKED]
      def self.command_state
        visible? ? MF_CHECKED : MF_UNCHECKED
      end

      # @api
      # Expected to be called when the selection changes.
      def self.on_selection_change
        if ObjectSize.valid?
          @scale = Scale.new(ObjectSize.dpi / @dpi)
          update_dialog
        else
          @dialog.execute_script("displayMessage(#{INVALID_SEL.inspect});")
        end
      end

      # Private

      def self.attach_callbacks
        @dialog.add_action_callback("ready") { on_selection_change }
        @dialog.add_action_callback("onChange") do |_, scale, dpi|
          on_change(scale, dpi)
        end
        @dialog.set_on_closed { @observer.release }
      end
      private_class_method :attach_callbacks

      def self.create_dialog
        @dialog = UI::HtmlDialog.new(
          dialog_title:    EXTENSION.name,
          preferences_key: name, # Full module name
          resizable:       false,
          style:           UI::HtmlDialog::STYLE_DIALOG,
          width:           220,
          height:          220,
          left:            200,
          top:             100
        )
      end
      private_class_method :create_dialog

      def self.update_dialog
        @dialog.execute_script("updateFields('#{@scale}', #{@dpi});")
      end
      private_class_method :update_dialog

      def self.on_change(scale, dpi)
        scale = Scale.new(scale)
        if scale.valid?
          @scale = scale
          @dialog.execute_script("markAsValid(scaleField);")
        else
          @dialog.execute_script("markAsInvalid(scaleField);")
          return
        end

        dpi = dpi.to_i
        if dpi == 0
          @dialog.execute_script("markAsInvalid(dpiField);")
          return
        else
          @dpi = dpi
          @dialog.execute_script("markAsValid(dpiField);")
        end

        Sketchup.active_model.start_operation("Image Size", true)
        ObjectSize.dpi=(1 / @scale.factor / @dpi)
        Sketchup.active_model.commit_operation
      end
      private_class_method :on_change
    end
  end
end