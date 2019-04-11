# frozen_string_literal: true

class Float
  def to_dual_number(key: nil)
    Differentiation.convert_to_dual_number(self, key: key)
  end
end
