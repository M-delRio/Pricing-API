class RatesController < ApplicationController
  def create
    rate_profile = params[:rate_profile]
    discounts = rate_profile["discounts"]
    surcharge = rate_profile["surcharge"]

    new_rate = Rate.new do |r|
      r.customer_id = rate_profile["customer_id"]
    end
      
    new_rate.save!
    rate_id = Rate.last["id"] 

    # parse surcharge data
    if surcharge
      new_surcharge = Surcharge.new do |s|  
        s.rate_id = rate_id
        s.item_property = surcharge["item_property"]
        s.surcharge_type = surcharge["surcharge_type"]
        s.type_value = surcharge["type_value"]
      end

      new_surcharge.save!
    end

    # parse discount data
    if discounts    
      discounts.each do |discount|
        new_discount = Discount.new do |d|
          d.rate_id = rate_id
          d.is_flat = discount["is_flat"]
          d.discount_type = discount["discount_type"]
          d.type_value = discount["type_value"]
        end     
        
        new_discount.save!
        discount_id = Discount.last["id"] 
        
        # parse criteria data
        if discount["criteria"]
          criteria = discount["criteria"]

          new_criteria = Criteria.new do |c|
            c.discount_id = discount_id
            c.criteria_type = criteria["criteria_type"]
            c.start = criteria["start"]
            c.end = criteria["end"]
          end
          new_criteria.save!
        end
      end
    end

    render json: {
        message: "Customer pricing successfully created",
        rate_profile: rate_profile
      }, status: 201 
  end
end




