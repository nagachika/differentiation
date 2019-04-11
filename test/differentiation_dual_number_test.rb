require "test_helper"

require "matrix"

class DifferentiationDualNumberTest < Test::Unit::TestCase

  def test_gradients_with_keys
    v = 1.0
    pr = differential(->(x){ 2.0 * x })
    result = pr.call(v)
    assert_instance_of(Differentiation::DualNumber, result)
    assert_equal(2.0, result)
    assert_equal([2.0], result.gradients(:x))
  end

  def test_gradients_with_variables
    v = 1.0.to_dual_number
    pr = differential(->(x){ 2.0 * x })
    result = pr.call(v)
    assert_instance_of(Differentiation::DualNumber, result)
    assert_equal(2.0, result)
    assert_equal([2.0], result.gradients(v))
  end

  def test_gradients_with_keys_with_matrix_variable
    mat = Matrix.build(2, 2){|i, j| i+j }
    pr = differential(->(m){ m + m })
    result = pr.call(mat)
    assert_instance_of(Matrix, result)
    assert_equal(mat+mat, result)
    assert_equal([Matrix[[2.0, 0.0], [0.0, 0.0]]], result[0, 0].gradients(:m))
    assert_equal([Matrix[[0.0, 2.0], [0.0, 0.0]]], result[0, 1].gradients(:m))
    assert_equal([Matrix[[0.0, 0.0], [2.0, 0.0]]], result[1, 0].gradients(:m))
    assert_equal([Matrix[[0.0, 0.0], [0.0, 2.0]]], result[1, 1].gradients(:m))
  end

  def test_gradients_without_keys
    v = 1.0
    pr = differential(->(x){ x + x })
    result = pr.call(v)
    assert_instance_of(Differentiation::DualNumber, result)
    assert_equal(2.0, result)
    assert_equal({x: 2.0}, result.gradients)
  end

  def test_gradients_without_keys_with_matrix_variable
    mat = Matrix.build(2, 2){|i, j| i+j }
    pr = differential(->(m){ m + m })
    result = pr.call(mat)
    assert_instance_of(Matrix, result)
    assert_equal(mat+mat, result)
    assert_equal({ m: Matrix[[2.0, 0.0], [0.0, 0.0]]}, result[0, 0].gradients)
    assert_equal({ m: Matrix[[0.0, 2.0], [0.0, 0.0]]}, result[0, 1].gradients)
    assert_equal({ m: Matrix[[0.0, 0.0], [2.0, 0.0]]}, result[1, 0].gradients)
    assert_equal({ m: Matrix[[0.0, 0.0], [0.0, 2.0]]}, result[1, 1].gradients)
  end

  def test_dual_number_to_i
    assert_instance_of(Integer, 1.to_dual_number.to_i)
  end

  def test_dual_number_to_int
    assert_instance_of(Integer, 1.to_dual_number.to_int)
  end

  def test_dual_number_to_f
    assert_instance_of(Float, 1.to_dual_number.to_f)
  end
end
