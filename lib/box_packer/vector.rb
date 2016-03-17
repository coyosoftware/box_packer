module BoxPacker
  class Vector
    def self.[](*args)
      new(*args)
    end

    def initialize(x, y)
      @x, @y = x, y
    end

    attr_reader :x, :y

    def +(other)
      self.class.new(*zip_map(other, :+))
    end

    def -(other)
      self.class.new(*zip_map(other, :-))
    end

    def width
      self.class.new(x, 0)
    end

    def height
      self.class.new(0, y)
    end

    def to_a
      [x, y]
    end

    def ==(other)
      zip_map(other, :==).reduce(&:&)
    end

    def eql?(other)
      zip_map(other, :eql?).reduce(&:&)
    end

    private

    def zip_map(other, method)
      to_a.zip(other.to_a).map { |a, b| a.send(method, b) }
    end
  end
end
