# Differential

differential.gem make ruby numeric Method/Proc differentiable.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'differential'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install differential

## Usage

```
require "differential"

differential def f(x, y)
  (x + 1) * (y - 2)
end


result = f(1, 2)

p result  # => -2

p result.gradients(:x, :y) # => {:x=>1, :y=>0}
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/nagachika/differential.

