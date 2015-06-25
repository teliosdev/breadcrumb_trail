module BreadcrumbTrail

  # A single representation of a breadcrumb.
  class Breadcrumb

    # The name of the breadcrumb.  Normally, this represents the text
    # that is displayed in place of the link to give meaning to the
    # breadcrumb.
    #
    # @return [String, Symbol, Proc, nil]
    attr_reader :name

    # The path the breadcrumb represents.  Normally, this is where the
    # breadcrumb should take the user when clicked.
    #
    # @return [String, Symbol, Proc, Hash]
    attr_reader :path

    # Options for the breadcrumb.  Normally, these are HTML attributes
    # that are used for the link tag.
    #
    # @return [Hash]
    attr_reader :options

    # Initialize the breadcrumb.  If a block is given, and a path is
    # not, then the path is set to be the block.
    #
    # @param name [String, Symbol, Proc, nil] The name of the
    #   breadcrumb.  See {#name}.
    # @param path [String, Symbol, Proc, Hash] The path of the
    #   breadcrumb.  See {#path}.
    # @param options [Hash] Options that are used as HTML attributes.
    #   See {#options}.
    #
    def initialize(name: nil, path: nil, **options, &block)
      @name    = name
      @path    = path || block
      @options = options
    end

    # Creates a version of the breadcrumb that has a computed name and
    # path.  This is used, for example, in a builder that exposes a
    # breadcrumb to application code.
    #
    # @see #computed_path
    # @see #computed_name
    # @param context [ActionView::Base] The context to compute the
    #   elements under.
    # @return [Breadcrumb]
    def computed(context)
      self.class.new(name: computed_name(context),
                     path: computed_path(context),
                     **@options)
    end

    # Computes the path of the breadcrumb under the given context.
    #
    # @return [String, Hash]
    def computed_path(context)
      @_path ||= case @path
      when String, Hash
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

    # Computes the name of the breadcrumb under the given context.
    #
    # @return [String]
    def computed_name(context)
      @_name ||= case @name
      when String
        @name
      when Symbol
        I18n.translate(@name)
      when Proc
        context.instance_exec(&@name)
      when nil
        computed_path(context)
      else
        raise ArgumentError,
          "Expected one of String, Symbol, or Proc, " \
          "got #{@name.class}"
      end
    end

  end
end
