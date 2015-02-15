module BreadcrumbTrail
  class Breadcrumb

    attr_reader :name

    attr_reader :path

    attr_reader :options

    def initialize(name:, path: nil, **options, &block)
      @name    = name
      @path    = path || block
      @options = options
      @block   = block
    end

    def computed(context)
      self.class.new(name: compute_name(context),
                     path: compute_path(context),
                     **@options)
    end

    def compute_path(context)
      case @path
      when String
        @path
      when Symbol
        context.public_send(@path) # todo
      when Proc
        context.instance_exec(&@path)
      else
        raise ArgumentError,
          "Expected one of String, Symbol, or Proc, " \
          "got #{@path.class}"
      end
    end

    def compute_name(context)
      case @name
      when String
        @name
      when Symbol
        context.public_send(@name) # todo
      when Proc
        context.instance_exec(&@name)
      else
        raise ArgumentError,
          "Expected one of String, Symbol, or Proc, " \
          "got #{@name.class}"
      end
    end

  end
end
