# fronzen_string_literal: true

module Differential

  def self.differentiable?(o)
    # TODO: support Vector and Matrix
    o.is_a?(Numeric)
  end

  def self.convert_to_dual_number(o, key: nil)
    if o.is_a?(DualNumber)
      o
    elsif differentiable?(o)
      DualNumber.new(o, lambda{|_key| _key == key ? 1 : 0})
    else
      o
    end
  end

  def self.differential(f)
    unless f.is_a?(Proc) or f.is_a?(Method)
      raise TypeError, "Only Proc or Method can be differentiable"
    end

    # [[:req, :x], [:req, :y], [:opt, :c], [:rest, :rest], [:keyreq, :k2], [:key, :k1], [:keyrest, :kw]]
    parameters = f.parameters
    positional = []
    parameters.each do |tuple|
      if [:req, :opt].include?(tuple[0])
        positional << tuple[1]
      elsif [:key, :keyreq, :kwrest].include?(tuple[0])
      else
        # TODO: support rest arguments
        raise "rest arguments are currently not supported"
      end
    end
    f_prime = lambda {|*args, **kwargs|
      args.map!.with_index do |a, i|
        Differential.convert_to_dual_number(a, key: positional[i])
      end
      kwargs = Hash[kwargs.map{|k,v| [k, Differential.convert_to_dual_number(v, key: k)] }]
      if kwargs.empty?
        f.call(*args)
      else
        f.call(*args, **kwargs)
      end
    }
  end

  class DualNumber
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
      if Differential.differentiable?(other)
        [DualNumber.new(other), self]
      else
        super
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
        diff = ->(key) { (@n ** other.n) * (other.diff(key) * Math.log(@n) + (other.n / @n)) }
      else
        n = @n ** other
        diff = ->(key) { (@n ** (other-1)) * other }
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

require "differential/ext/kernel"

