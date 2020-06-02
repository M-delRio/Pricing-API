require 'test_helper'

class CriteriaTest < ActiveSupport::TestCase
  test "should not save rate without discount_id" do
    criteria = Criteria.new
    criteria.start = 1
    criteria.end = 10
    criteria.criteria_type = "range"
    
    assert_not criteria.save, "Saved the rate without a discount_id"
  end

  test "start attribute must be a positive integer" do
    criteria = Criteria.new
    criteria.discount_id = 1
    criteria.start = -1
    criteria.end = 10
    criteria.criteria_type = "range"
    
    assert_not criteria.save, "Saved the criteria with a negative start value"
  end

  test "discount_type attribute must be 'range' or 'price'" do
    criteria = Criteria.new
    criteria.discount_id = 1
    criteria.start = 1
    criteria.end = 10
    criteria.criteria_type = "rang"
    
    assert_not criteria.save, "Saved the rate with an invalid discount_type value"
  end 
end