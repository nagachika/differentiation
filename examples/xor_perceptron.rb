require "matrix"
require "differentiation"

Dataset = {
  inputs: [
    Matrix[[0.0], [0.0]],
    Matrix[[0.0], [1.0]],
    Matrix[[1.0], [0.0]],
    Matrix[[1.0], [1.0]],
  ],
  targets: [
    0.0,
    1.0,
    1.0,
    0.0
  ]
}

def sigmoid(x, a=1.0)
  1.0 / (1.0 + Math.exp(-a * x))
end

def mlp(input, w1, b1, w2, b2)
  x = w1 * input + b1
  x = x.map{|i| sigmoid(i) }
  x = w2 * x + b2
  sigmoid(x[0, 0])
end

differential def loss(w1, b1, w2, b2)
  l = 0.0
  Dataset[:inputs].zip(Dataset[:targets]) do |x, y|
    l += (y - mlp(x, w1, b1, w2, b2)) ** 2
  end
  l
end

weights1 = Matrix.build(2, 2){ (rand() - 0.5) * 0.5 }
bias1 = Matrix.build(2, 1) { 0.0 }
weights2 = Matrix.build(1, 2){ (rand() - 0.5) * 0.5 }
bias2 = Matrix.build(1, 1) { 0.0 }

rate = 2.0

10001.times do |step|
  _loss = loss(weights1, bias1, weights2, bias2)
  puts "%5d\t%.05f" % [step, _loss] if step % 1000 == 0
  gw1, gb1, gw2, gb2 = _loss.gradients(:w1, :b1, :w2, :b2)
  weights1 -= gw1.map{|v| v * rate }
  bias1 -= gb1.map{|v| v * rate }
  weights2 -= gw2.map{|v| v * rate }
  bias2 -= gb2.map{|v| v * rate }
end

Dataset[:inputs].each do |x|
  puts "#{[x[0,0], x[1, 0]]} => #{mlp(x, weights1, bias1, weights2, bias2)}"
end
