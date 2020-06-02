class QuoteController < ApplicationController 
  def calculate_item_subtotal(surcharge, item)   
    if surcharge["item_property"] == "value" && surcharge["surcharge_type"] == "percentage"
      item_value = item["value"].to_i
      percentage_value = surcharge["type_value"]

      return (percentage_value * item_value / 100) + 20
    end

    if surcharge["item_property"] == "volume" && surcharge["surcharge_type"] == "monetary"
      item_length = item["length"].to_i
      item_width = item["width"].to_i
      item_height = item["height"].to_i

      volume = item_length * item_width * item_height

      return volume * surcharge["type_value"] + 20
    end
  end

  def parse_discount(discount)
    complete_discount = {}

    complete_discount["is_flat"] = discount["is_flat"]
    complete_discount["discount_type"] = discount["discount_type"]
    complete_discount["type_value"] = discount["type_value"]

    if discount.criteria
      criteria = []
      criteria.push(discount.criteria["start"])

      if discount.criteria["end"]
        criteria.push(discount.criteria["end"])
      else   
        criteria.push(Float::INFINITY)
      end

      criteria.push(discount.criteria["criteria_type"])
    end

    complete_discount["criteria"] = criteria

    return complete_discount
  end

  def calculate_item_discount(item, idx, discounts, subtotal)
    range_start = discounts[0]["criteria"][0] 
    range_end = discounts[0]["criteria"][1] 
    discount = 0

    idx += 1

    if (idx >= range_start && idx <= range_end)
      discount_percentage = discounts[0]["type_value"]
           
      discount = discount_percentage.to_f * subtotal / 100
    end

    if (idx == range_end)
      discounts.shift
    end

    return discount
  end

  def generate_quote
  #retrieve pricing_profile data
    customer_id = params[:customer_id]
    rate = Rate.where(customer_id: customer_id)[0] 
    rate_id = rate["id"]

    surcharge = Surcharge.where(rate_id: rate_id)[0]
    raw_discounts = Discount.where(rate_id: rate_id)
    complete_discounts = []

    if raw_discounts
      raw_discounts.each do |discount|
        complete_discount = parse_discount(discount)
        complete_discounts.push(complete_discount)
      end
    end

    # map items to subtotals for each item by applying surcharges
    items = params[:items]

    subtotals = 
      if surcharge
        items.map {|item| calculate_item_subtotal(surcharge, item)}
      else 
        items.map {|item| 20}
      end
  
    subtotal = subtotals.sum

    # iterate each order item, if flat discount apply it directly to subtotal, if item specific check each item to see if it meets the discounts' criteria  
    order_discount = 0

    if complete_discounts.length >= 1

      if complete_discounts[0]["is_flat"] &&
         complete_discounts[0]["discount_type"] == "percentage"
        
        discount = subtotal * complete_discounts[0]["type_value"] / 100
        order_discount += discount
      end

      if complete_discounts[0]["is_flat"] == false &&
        complete_discounts[0]["criteria"][2] == "price"

        criteria = complete_discounts[0]["criteria"]

        if subtotal >= criteria[0]
          discount = complete_discounts[0]["type_value"]
          order_discount += discount
        end
      end

      if complete_discounts[0]["is_flat"] == false &&
        complete_discounts[0]["criteria"][2] == "range"

        subtotals.each_with_index do |subtotal, idx|
          item = items[idx]
          discount = calculate_item_discount(item, idx, complete_discounts, subtotal)
          order_discount += discount
        end
      end
    end
    
    item_count = subtotals.length

    render json: {
        message: "Quote successfully generated",
        quote: {
          number_of_items: item_count,
          subtotal: subtotal,
          discount_total: order_discount.to_i,
          total: subtotal - order_discount.to_i
      }
    }, status: 200  
  end
end




