# fronzen_string_literal: true

require "differentiation/dual_number"

module Differentiation
  class DualNumber
    include Comparable

    def initialize(n, diff=lambda{|_| 0})
      @n = n
      @diff = diff
    end

    attr_reader :n, :diff

    def derivative(key)
      @diff.call(key)
    end

    def gradients(*keys)
      keys.each_with_object({}) do |k, o|
        o[k] = @diff.call(k)
      end
    end

    def to_i
      @n.to_i
    end

    def to_int
      @n.to_int
    end

    def to_f
      @n.to_f
    end

    def coerce(other)
      if Differentiation.differentiable?(other)
        [DualNumber.new(other), self]
      else
        super
      end
    end

    def <=>(other)
      if other.is_a?(DualNumber)
        @n <=> other.n
      else
        @n <=> other
      end
    end

    def +(other)
      if other.is_a?(DualNumber)
        n = @n + other.n
        diff = ->(key) { @diff.call(key) + other.diff.call(key) }
      else
        n = @n + other
        diff = @diff
      end
      DualNumber.new(n, diff)
    end

    def -(other)
      if other.is_a?(DualNumber)
        n = @n - other.n
        diff = ->(key) { @diff.call(key) - other.diff.call(key) }
      else
        n = @n - other
        diff = @diff
      end
      DualNumber.new(n, diff)
    end

    def *(other)
      if other.is_a?(DualNumber)
        n = @n * other.n
        diff = ->(key) { @n * other.diff.call(key) + @diff.call(key) * other.n }
      else
        n = @n * other
        diff = ->(key) { @diff.call(key) * other }
      end
      DualNumber.new(n, diff)
    end

    def /(other)
      if other.is_a?(DualNumber)
        n = @n / other.n
        diff = ->(key) { (@diff.call(key) / other) + (@n * other.diff.call(key)) / (other.n ** 2) }
      else
        n = @n / other
        diff = ->(key) { @diff.call(key) / other }
      end
      DualNumber.new(n, diff)
    end

    def **(other)
      if other.is_a?(DualNumber)
        n = @n ** other.n
        diff = ->(key) { (@n ** other.n) * (other.diff.call(key) * Math.log(@n) + (other.n / @n)) }
      else
        n = @n ** other
        diff = ->(key) { ((@n ** (other-1)) * other) * @diff.call(key) }
      end
      DualNumber.new(n, diff)
    end

    def inspect
      if $DEBUG
        "<DualNumber: #{@n} >"
      else
        @n.inspect
      end
    end
  end
end
