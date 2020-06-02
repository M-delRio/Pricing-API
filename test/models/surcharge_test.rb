require 'test_helper'

class SurchargeTest < ActiveSupport::TestCase
  test "should not save rate without rate_id" do
    surcharge = Surcharge.new
    surcharge.rate_id = 2
    surcharge.item_property = "volume"
    surcharge.surcharge_type = "monetary"
    surcharge.type_value = 5  

    assert surcharge.save, "Saved the surcharge without a rate_id"
  end

  test "should not save rate with an invalid rate_id" do
    surcharge = Surcharge.new
    surcharge.rate_id = 1000
    surcharge.item_property = "volume"
    surcharge.surcharge_type = "monetary"
    surcharge.type_value = 5  

    assert_not surcharge.save, "Saved the surcharge with a non existant a rate_id"
  end

  test "type_value attribute must be a positive integer" do
    surcharge = Surcharge.new
    surcharge.rate_id = 2
    surcharge.item_property = "volume"
    surcharge.surcharge_type = "monetary"
    surcharge.type_value = -5  

    assert_not surcharge.save, "Saved the surcharge with a non existant a rate_id"
  end

  test "item_property attribute must be 'volume' or 'value'" do
    surcharge = Surcharge.new
    surcharge.rate_id = 2
    surcharge.item_property = "vol"
    surcharge.surcharge_type = "monetary"
    surcharge.type_value = 5  

    assert_not surcharge.save, "Saved the surcharge with an invalid item_property string"
  end

  test "surcharge_type attribute must be 'percentage' or 'monetary'" do
    surcharge = Surcharge.new
    surcharge.rate_id = 2
    surcharge.item_property = "volume"
    surcharge.surcharge_type = "monet"
    surcharge.type_value = 5  

    assert_not surcharge.save, "Saved the surcharge with an invalid item_property string"
  end
end

