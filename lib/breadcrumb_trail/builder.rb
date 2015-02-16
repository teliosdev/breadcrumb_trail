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
