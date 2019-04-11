# fronzen_string_literal: true

require "differentiation/dual_number"

module Differentiation

  def self.differentiable?(o)
    o.is_a?(Numeric) or (defined?(Matrix) and o.is_a?(Matrix))
  end

  def self.convert_to_dual_number(o, key: nil, named_variables: {})
    if o.is_a?(DualNumber)
      if key and o.named_variables.empty?
        DualNumber.new(o.n, o.diff, key: key)
      else
        o
      end
    elsif differentiable?(o)
      if defined?(Matrix) and o.is_a?(Matrix)
        if key
          vars = Matrix.build(o.row_size, o.column_size){ nil }
          named_variables = { key => vars }
        end
        Matrix.build(o.row_size, o.column_size) do |i, j|
          v = self.convert_to_dual_number(o[i, j], named_variables: named_variables)
          if key
            vars.__send__(:[]=, i, j, v)
          end
          v
        end
      else
        DualNumber.new(o, key: key, named_variables: named_variables)
      end
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
        Differentiation.convert_to_dual_number(a, key: positional[i])
      end
      kwargs = Hash[kwargs.map{|k,v| [k, Differentiation.convert_to_dual_number(v, key: k)] }]
      if kwargs.empty?
        Differentiation.convert_to_dual_number(f.call(*args))
      else
        Differentiation.convert_to_dual_number(f.call(*args, **kwargs))
      end
    }
  end
end

require "differentiation/ext/kernel"
require "differentiation/ext/integer"
require "differentiation/ext/float"

