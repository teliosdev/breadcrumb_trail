module BreadcrumbTrail

  # A module to extend Controllers with.  It provides the main methods
  # that are used within the application, namely `breadcrumbs` and
  # `render_breadcrumbs`.
  module ActionController
    extend ActiveSupport::Concern

    included do
      include HelperMethods
      helper HelperMethods
      helper_method :breadcrumb, :breadcrumbs
    end

    # This extends a controller, providing the `breadcrumb` method to
    # the class as a method.
    module ClassMethods

      # Creates a before action that defines a breadcrumb before the
      # action takes place.  See {HelperMethods#breadcrumb}.
      #
      # @param (see HelperMethods#breadcrumb)
      # @return [void]
      def breadcrumb(options, &block)
        before_action(options.delete(:action) || {}) do
          breadcrumb(options, &block)
        end
      end
    end

    # This is both included in the controller and used as a helper,
    # so any methods defined here are usable in both the controller
    # and in the views.  These methods are the primary interface
    # that the developer uses to define and render breadcrumbs.
    module HelperMethods

      # Define a breadcrumb with the given options.  All of this
      # information is passed directly to the Breadcrumb initializer.
      #
      # @see Breadcrumb#initialize
      # @params options [Hash] A hash of options to pass directly to
      #   the Breadcrumb.
      # @yield
      # @return [void]
      def breadcrumb(options, &block)
        breadcrumbs << Breadcrumb.new(**options, &block)
      end

      # All of the defined breadcrumbs, in order.
      #
      # @return [Array<Breadcrumb>]
      def breadcrumbs
        @_breadcrumbs ||= []
      end

      # Renders the defined breadcrumbs, with the given options.
      #
      # @param options [Hash] The options that are passed to the
      #   builder to help render the breadcrumbs.
      # @option options [Hash] :builder (Builder) The builder to use.
      #   If this isn't provided, a sensible default is used.
      # @yield
      # @return [String]
      def render_breadcrumbs(options = {}, &block)
        block_given = block_given?
        builder = options.fetch(:builder) do
          if block_given
            BlockBuilder
          else
            HTMLBuilder
          end
        end

        builder.new(self, breadcrumbs, options, &block).call
      end

    end
  end
end
