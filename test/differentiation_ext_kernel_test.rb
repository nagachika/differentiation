require "test_helper"

class DifferentiationExtKernelTest < Test::Unit::TestCase

  def test_differential_with_symbol
    mod = Module.new do |mod|
      differential def m(x)
        x
      end
    end
    o = Object.new
    o.extend(mod)
    result = o.m(1.0)
    assert_instance_of(Differentiation::DualNumber, result)
    assert_equal(1.0, result)
    assert_equal([1.0], result.gradients(:x))
  end

  def test_differential_with_nil
    assert_raise(TypeError){ differential nil }
  end
end
