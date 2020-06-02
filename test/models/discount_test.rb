require 'test_helper'

class DiscountTest < ActiveSupport::TestCase
  test "should not save rate without rate_id" do
    discount = Discount.new
    discount.is_flat = true
    discount.discount_type = "percentage"
    discount.type_value = 10

    assert_not discount.save, "Saved the discount without a rate_id"
  end

  test "should not save rate with an invalid rate_id" do
    discount = Discount.new
    discount.is_flat = true
    discount.discount_type = "percentage"
    discount.type_value = 10
    discount.rate_id = 10000

    assert_not discount.save, "Saved the discount with a non existant a rate_id"
  end

  test "type_value attribute must be a positive integer" do

    discount = Discount.new
    discount.rate_id = 1
    discount.is_flat = true
    discount.discount_type = "percentage"
    discount.type_value = -1

    assert_not discount.save, "Saved the discount with a negative type_value"
  end

  test "discount_type attribute must be 'percentage' or 'monetary'" do

    discount = Discount.new
    discount.rate_id = 1
    discount.is_flat = true
    discount.discount_type = "percent"
    discount.type_value = 1

    assert_not discount.save, "Saved the discount with an invalid discount_type string"
  end
end