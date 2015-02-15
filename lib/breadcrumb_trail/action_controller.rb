module BreadcrumbTrail
  module ActionController
    extend ActiveSupport::Concern

    included do
      include HelperMethods
      helper HelperMethods
      helper_method :breadcrumb, :breadcrumbs
    end

    module ClassMethods

      def breadcrumb(**options, &block)
        before_action(options.delete(:action) || {}) do
          breadcrumb(options, &block)
        end
      end

    end

    module HelperMethods

      def breadcrumb(options, &block)
        breadcrumbs << Breadcrumb.new(**options, &block)
      end

      def breadcrumbs
        @_breadcrumbs ||= []
      end

      def render_breadcrumbs(options = {}, &block)
        block_given = block_given?
        builder = options.fetch(:builder) do
          if block_given
            BlockBuilder
          else
            ListBuilder
          end
        end

        builder.new(self, breadcrumbs, options, &block).call
      end

    end
  end
end
