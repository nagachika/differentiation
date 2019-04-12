# frozen_string_literal: true

module Kernel
  def differential(m)
    if m.is_a?(Symbol)
      if self.is_a?(Module)
        f = self.instance_method(m)
      else
        f = self.method(m)
      end
    elsif m.is_a?(Proc) or m.is_a?(Method) or m.is_a?(UnboundMethod)
      f = m
    else
      raise TypeError, "differential requires Method/UnboundMethod/Proc/Symbol argument."
    end
    f = Differentiation.differential(f)
    if m.is_a?(Symbol)
      if self.is_a?(Module)
        self.define_method(m, f)
      else
        self.define_singleton_method(m, f)
      end
    end
    f
  end
end

