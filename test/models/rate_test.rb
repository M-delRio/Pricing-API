require 'test_helper'

class RateTest < ActiveSupport::TestCase
  test "should not save rate without customer_id" do
    rate = Rate.new
    assert_not rate.save, "Saved the rate without a customer_id"
  end

  test "should not save rate with an invalid customer_id" do
    rate = Rate.new
    rate.customer_id = 10000
    assert_not rate.save, "Saved the rate with a non existant customer_id"
  end 
end