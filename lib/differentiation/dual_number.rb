# fronzen_string_literal: true

module Differentiation
  class DualNumber
    include Comparable

    def initialize(n, diff=lambda{|var| var.equal?(self) ? 1.0 : 0.0 }, named_variables: {}, key: nil)
      @n = n
      @diff = diff
      if key
        @named_variables = { key => self }.freeze
      else
        @named_variables = named_variables.dup.freeze
      end
    end

    attr_reader :n, :diff, :named_variables

    def derivative(var)
      if var.equal?(self)
        1.0
      else
        @diff.call(var)
      end
    end

    def gradients(*keys)
      keys = keys.flatten(1)
      return_hash = false
      if keys.empty?
        return_hash = true
        keys = @named_variables.keys
        vars = @named_variables.values
      else
        vars = keys.map do |k|
          if k.is_a?(DualNumber) or (defined?(::Matrix) and k.is_a?(Matrix))
            k
          else
            @named_variables[k]
          end
        end
      end
      if return_hash
        keys.each_with_object({}) do |k, o|
          v = @named_variables[k]
          if v.nil?
            o[k] = 0.0
          elsif defined?(::Matrix) and v.is_a?(::Matrix)
            o[k] = Matrix.build(v.row_size, v.column_size){|i, j| derivative(v[i, j]) }
          else
            o[k] = derivative(v)
          end
        end
      else
        vars.map do |v|
          if v.nil?
            0.0
          elsif defined?(::Matrix) and v.is_a?(::Matrix)
            Matrix.build(v.row_size, v.column_size){|i, j| derivative(v[i, j]) }
          else
            derivative(v)
          end
        end
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
        [Differentiation.convert_to_dual_number(other), self]
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

    def +@
      self
    end

    def -@
      self * -1
    end

    def +(other)
      if other.is_a?(DualNumber)
        n = @n + other.n
        diff = ->(var) { self.derivative(var) + other.derivative(var) }
        named_variables = @named_variables.merge(other.named_variables)
      else
        n = @n + other
        diff = @diff
        named_variables = @named_variables
      end
      DualNumber.new(n, diff, named_variables: named_variables)
    end

    def -(other)
      if other.is_a?(DualNumber)
        n = @n - other.n
        diff = ->(var) { self.derivative(var) - other.derivative(var) }
        named_variables = @named_variables.merge(other.named_variables)
      else
        n = @n - other
        diff = @diff
        named_variables = @named_variables
      end
      DualNumber.new(n, diff, named_variables: named_variables)
    end

    def *(other)
      if other.is_a?(DualNumber)
        n = @n * other.n
        diff = ->(var) { @n * other.derivative(var) + self.derivative(var) * other.n }
        named_variables = @named_variables.merge(other.named_variables)
      else
        n = @n * other
        diff = ->(var) { self.derivative(var) * other }
        named_variables = @named_variables
      end
      DualNumber.new(n, diff, named_variables: named_variables)
    end

    def /(other)
      if other.is_a?(DualNumber)
        n = @n / other.n
        diff = ->(var) { (self.derivative(var) / other.n) + (@n * other.derivative(var)) / (other.n ** 2) }
        named_variables = @named_variables.merge(other.named_variables)
      else
        n = @n / other
        diff = ->(var) { self.derivative(var) / other }
        named_variables = @named_variables
      end
      DualNumber.new(n, diff, named_variables: named_variables)
    end

    def **(other)
      if other.is_a?(DualNumber)
        n = @n ** other.n
        diff = ->(var) { (@n ** other.n) * (other.derivative(var) * Math.log(@n) + (other.n / @n)) }
        named_variables = @named_variables.merge(other.named_variables)
      else
        n = @n ** other
        diff = ->(var) { ((@n ** (other-1)) * other) * self.derivative(var) }
        named_variables = @named_variables
      end
      DualNumber.new(n, diff, named_variables: named_variables)
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
