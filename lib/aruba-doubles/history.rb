module ArubaDoubles
  class History

    include Enumerable

    def initialize(filename)
      @store = PStore.new(filename)
    end

    def <<(args)
      @store.transaction do
        @store[:history] ||= []
        @store[:history] << args
      end
    end

    def clear
      @store.transaction do
        @store[:history] = []
      end
    end

    def each
      entries.each { |e| yield(e) }
    end

  private

    def entries
      @store.transaction(readonly=true) do
        @store[:history] || []
      end
    end
  end
end
