require "test_helper"

class DifferentiationExtNumericTest < Test::Unit::TestCase

  def test_math_sin
    assert_instance_of(Float, Math.sin(0.0))
    assert_equal(0.0, Math.sin(0.0))

    x = 0.0.to_dual_number
    r = Math.sin(x)
    assert_instance_of(Differentiation::DualNumber, r)
    assert_equal(0.0, r)
    assert_equal([1.0], r.gradients(x))
  end

  def test_math_cos
    assert_instance_of(Float, Math.cos(0.0))
    assert_equal(1.0, Math.cos(0.0))

    x = 0.0.to_dual_number
    r = Math.cos(x)
    assert_instance_of(Differentiation::DualNumber, r)
    assert_equal(1.0, r)
    assert_equal([0.0], r.gradients(x))
  end

  def test_math_tan
    assert_instance_of(Float, Math.tan(0.0))
    assert_equal(0.0, Math.tan(0.0))

    x = 0.0.to_dual_number
    r = Math.tan(x)
    assert_instance_of(Differentiation::DualNumber, r)
    assert_equal(0.0, r)
    assert_equal([1.0], r.gradients(x))
  end

  def test_math_exp
    assert_instance_of(Float, Math.exp(0.0))
    assert_equal(1.0, Math.exp(0.0))
    assert_instance_of(Float, Math.exp(1.0))
    assert_equal(Math::E, Math.exp(1.0))

    x = 0.0.to_dual_number
    r = Math.exp(x)
    assert_instance_of(Differentiation::DualNumber, r)
    assert_equal(1.0, r)
    assert_equal([1.0], r.gradients(x))
  end
end
