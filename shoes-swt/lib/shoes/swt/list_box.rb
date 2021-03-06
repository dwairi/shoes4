class Shoes
  module Swt
    class ListBox
      include Common::Child
      include Common::Remove
      include Common::Visibility
      include Common::UpdatePosition
      include ::Shoes::BackendDimensionsDelegations

      attr_reader :dsl, :parent

      # Create a list box
      #
      # @param dsl    [Shoes::List_box] The Shoes DSL list box this represents
      # @param parent [::Swt::Widgets::Composite] The parent element of this button
      def initialize(dsl, parent)
        @dsl = dsl
        @parent = parent
        @real = ::Swt::Widgets::Combo.new(
          @parent.real,
          ::Swt::SWT::DROP_DOWN | ::Swt::SWT::READ_ONLY
        )
        @real.set_size dsl.element_width, dsl.element_height
        @real.add_selection_listener do |_event|
          @dsl.call_change_listeners
        end
        update_items

        # Set initial selection without triggering callbacks!
        choice = @dsl.style[:choose]
        @real.text = choice if choice
      end

      def update_items
        @real.items = @dsl.items.to_a.map(&:to_s)
      end

      def text
        text = @real.text
        text == '' ? nil : text
      end

      def choose(item)
        @real.text = item
        @dsl.call_change_listeners
      end

      def enabled(value)
        @real.enable_widget value
      end
    end
  end
end
