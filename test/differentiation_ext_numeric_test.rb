require "test_helper"

class DifferentiationTest < Test::Unit::TestCase

  def test_integer_to_dual_number
    n = 0.to_dual_number
    assert_instance_of(Differentiation::DualNumber, n)
    assert_equal(0, n.n)
    assert_instance_of(Proc, n.diff)
    assert_equal({}, n.named_variables)
    assert_equal({}, n.gradients)
    assert_equal([1.0], n.gradients(n))
    assert_equal([0.0], n.gradients(:x))

    n = 1.to_dual_number(key: :x)
    assert_instance_of(Differentiation::DualNumber, n)
    assert_equal(1, n.n)
    assert_instance_of(Proc, n.diff)
    assert_equal({x: n}, n.named_variables)
    assert_equal({x: 1.0}, n.gradients)
    assert_equal([1.0], n.gradients(n))
    assert_equal([1.0], n.gradients(:x))
  end

  def test_float_to_dual_number
    n = 0.0.to_dual_number
    assert_instance_of(Differentiation::DualNumber, n)
    assert_equal(0.0, n.n)
    assert_instance_of(Proc, n.diff)
    assert_equal({}, n.named_variables)
    assert_equal({}, n.gradients)
    assert_equal([1.0], n.gradients(n))
    assert_equal([0.0], n.gradients(:x))

    n = 1.0.to_dual_number(key: :x)
    assert_instance_of(Differentiation::DualNumber, n)
    assert_equal(1, n.n)
    assert_instance_of(Proc, n.diff)
    assert_equal({x: n}, n.named_variables)
    assert_equal({x: 1.0}, n.gradients)
    assert_equal([1.0], n.gradients(n))
    assert_equal([1.0], n.gradients(:x))
  end
end
