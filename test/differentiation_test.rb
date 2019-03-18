require "test_helper"

class DifferentiationTest < Test::Unit::TestCase

  def assert_differential(f, args, kwargs, y, gradients)
    f_d = Differentiation.differential(f)
    if kwargs.empty?
      result = f_d.call(*args)
    else
      result = f_d.call(*args, **kwargs)
    end
    assert_equal(Differentiation::DualNumber, result.class)
    assert_equal(y, result.n)
    assert_equal(gradients, result.gradients(*gradients.keys))
  end

  def test_integer_polynomial
    assert_differential(
      lambda{|x| x * x + x * 2 + 1 },
      [1], {}, 4, { x: 4 })
    assert_differential(
      lambda{|x| x ** 2 + 2 * x + 1 },
      [1], {}, 4, { x: 4 })
    assert_differential(
      lambda{|x| x * x - x * 2 - 1 },
      [1], {}, -2, { x: 0 })
    assert_differential(
      lambda{|x| 2 * x + 1 },
      [2], {}, 5, { x: 2 })
  end

  def test_float_polynomial
    assert_differential(
      lambda{|x| x * x + x * 2.0 + 1.0 },
      [1.0], {}, 4.0, { x: 4.0 })
    assert_differential(
      lambda{|x| x ** 2.0 + 2.0 * x + 1.0 },
      [1.0], {}, 4.0, { x: 4.0 })
    assert_differential(
      lambda{|x| x * x - x * 2.0 - 1.0 },
      [1.0], {}, -2.0, { x: 0.0 })
    assert_differential(
      lambda{|x| 2.0 * x + 1.0 },
      [2.0], {}, 5.0, { x: 2.0 })
  end

  def test_multivariable
    assert_differential(
      lambda{|x, y| (x + 1) * (y - 2) },
      [1.0, 2.0], {},
      0.0, { x: 0.0, y: 2.0 })
  end

  def test_relu
    assert_differential(
      lambda{|x| x > 0 ? x : 0.0 },
      [1.0], {},
      1.0, { x: 1.0 })
    assert_differential(
      lambda{|x| x > 0 ? x : 0.0 },
      [-1.0], {},
      0.0, { x: 0.0 })
    assert_differential(
      lambda{|x| [x, 0.0].max },
      [1.0], {},
      1.0, { x: 1.0 })
    assert_differential(
      lambda{|x| [x, 0.0].max },
      [-11.0], {},
      0.0, { x: 0.0 })
  end
end
