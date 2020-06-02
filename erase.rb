require 'json'

discounts = {
        10 => [1, 100, 5],
        2 => [101, 200, 10],
        3 => [201, Float::INFINITY, 15]
      }

class SomeClass
  @@fee = 20

  attr_accessor :check

  def checker
    p fee
  end

end

SomeClass.checker



# input = '{
#   "items": [
#     {
#       "name": "Fridge",
#       "length": "3", 
#       "height": "6",
#       "width": "4",
#       "weight": "300",
#       "value": "1000"
#     },
#     {
#       "name": "sofa",
#       "length": "6", 
#       "height": "4",
#       "width": "3",
#       "weight": "100",
#       "value": 500
#     }
#   ]
# }'

# p input.is_a?(String)

# input_as_object = JSON.parse(input)

# p input_as_object





