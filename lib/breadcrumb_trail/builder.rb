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

  class ListBuilder < Builder

    def call
      buffer = ActiveSupport::SafeBuffer.new
      buffer.safe_concat("<ol>")
      @breadcrumbs.each do |breadcrumb|
        buffer.safe_concat("<li><a href=\"")
        buffer << breadcrumb.compute_path(@context)
        buffer.safe_concat("\">")
        buffer << breadcrumb.compute_name(@context)
        buffer.safe_concat("</a></li>")
      end
      buffer.safe_concat("</ol>")
    end
  end
end
