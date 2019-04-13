# frozen_string_literal: true

module DualMath
  def sin(x)
    if x.is_a?(Differentiation::DualNumber)
      Differentiation::DualNumber.new(super(x.n), ->(var){ cos(x.n) * x.derivative(var) }, named_variables: x.named_variables)
    else
      super(x)
    end
  end

  def cos(x)
    if x.is_a?(Differentiation::DualNumber)
      Differentiation::DualNumber.new(super(x.n), ->(var){ -1.0 * sin(x.n) * x.derivative(var) }, named_variables: x.named_variables)
    else
      super(x)
    end
  end

  def tan(x)
    if x.is_a?(Differentiation::DualNumber)
      Differentiation::DualNumber.new(super(x.n), ->(var){ ((1.0 / cos(x.n)) ** 2) * x.derivative(var) }, named_variables: x.named_variables)
    else
      super(x)
    end
  end

  def exp(x)
    if x.is_a?(Differentiation::DualNumber)
      Differentiation::DualNumber.new(super(x.n), ->(var){ exp(x.n) * x.derivative(var) }, named_variables: x.named_variables)
    else
      super(x)
    end
  end
end

module Math
  prepend DualMath
end
Math.singleton_class.prepend(DualMath)
