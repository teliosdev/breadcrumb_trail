module BreadcrumbTrail
  class Builder

    def initialize(context, breadcrumbs, options = {}, &block)
      @context = context
      @breadcrumbs = breadcrumbs
      @options = options
      @block = block
    end

    def call
      raise NotImplementedError
    end

  end

  class BlockBuilder < Builder

    def call
      buffer = ActiveSupport::SafeBuffer.new
      @breadcrumbs.each do |breadcrumb|
        buffer << @block.call(breadcrumb.computed(@context))
      end

      buffer
    end
  end

  class HTMLBuilder < Builder

    include ActionView::Helpers

    def call
      outer_tag = @options.fetch(:outer, "ol")
      inner_tag = @options.fetch(:inner, "li")
      outer = tag(outer_tag,
                  @options.fetch(:outer_options, nil),
                  true)
      inner = tag(inner_tag,
                  @options.fetch(:inner_options, nil),
                  true)

      buffer = ActiveSupport::SafeBuffer.new
      buffer << outer

      @breadcrumbs.each do |breadcrumb|
        buffer << inner
        buffer << link_to(breadcrumb.compute_name(@context),
                          breadcrumb.compute_path(@context),
                          breadcrumb.options)
        buffer << "</#{inner_tag}>".html_safe
      end

      buffer.safe_concat "</#{outer_tag}>".html_safe

    end

  end
end
