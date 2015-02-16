module BreadcrumbTrail

  # A Builder that is used by
  # {ActionController::HelperMethods#render_breadcrumbs}.  This should
  # be subclassed and implemented.
  #
  # @abstract
  class Builder

    # Initialize the builder.
    #
    # @param context [ActionView::Base] The base of the view being
    #   rendered.
    # @param breadcrumbs [Array<Breadcrumb>] The breadcrumbs to
    #   render.
    # @param options [Hash] The options for the builder.
    def initialize(context, breadcrumbs, options = {}, &block)
      @context = context
      @breadcrumbs = breadcrumbs
      @options = options
      @block = block
    end

    # Renders the breadcrumbs using the builder.  However, since this
    # is the base, it raises an error.
    #
    # @raise [NotImplementedError]
    # @return [String]
    def call
      raise NotImplementedError
    end

  end

  # Used along with a block given to the initializer, this renders
  # the breadcrumbs.
  class BlockBuilder < Builder

    # Creates a buffer, and iterates over every breadcrumb, yielding
    # the breadcrumb to the block given on initialization.
    #
    # @return [String]
    def call
      buffer = ActiveSupport::SafeBuffer.new
      @breadcrumbs.each do |breadcrumb|
        buffer << @block.call(breadcrumb.computed(@context))
      end

      buffer
    end
  end

  # Creates a structure of HTML elements to render the breadcrumbs.
  class HTMLBuilder < Builder

    include ActionView::Helpers

    # Renders the breadcrumbs in HTML tags.  If no options were
    # provided on initialization, it uses defaults.
    #
    # @option @options [String] :outer ("ol") The outer tag element
    #   to use.
    # @option @options [String] :inner ("li") The inner tag element
    #   to use.
    # @option @options [Hash] :outer_options (nil) The outer tag
    #   element attributes to use.  Things like `class="some-class"`
    #   are best placed here.
    # @option @options [Hash] :inner_options (nil) The inner tag
    #   element attributes to use.  Things like `class="some-class"`
    #   are best placed here.
    # @return [String]
    def call
      outer_tag = @options.fetch(:outer, "ol")
      inner_tag = @options.fetch(:inner, "li")
      outer = tag(outer_tag,
                  @options.fetch(:outer_options, nil),
                  true) if outer_tag
      inner = tag(inner_tag,
                  @options.fetch(:inner_options, nil),
                  true) if inner_tag

      buffer = ActiveSupport::SafeBuffer.new
      buffer.safe_concat(outer) if outer_tag

      @breadcrumbs.each do |breadcrumb|
        buffer.safe_concat(inner) if inner_tag
        buffer << link_to(breadcrumb.compute_name(@context),
                          breadcrumb.compute_path(@context),
                          breadcrumb.options)
        buffer.safe_concat("</#{inner_tag}>") if inner_tag
      end

      buffer.safe_concat("</#{outer_tag}>") if outer_tag
      buffer
    end

  end
end
