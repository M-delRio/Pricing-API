require 'json'
require 'httparty'

# generate 5 customer rate profiles with the following rate profiles
customer_1 = 
  '{
    "rate_profile": {
      "customer_id": 1,
      "discounts": [
        {
          "is_flat": true,
          "discount_type": "percentage",
          "type_value": 10
        }
      ]
    }
  }'

customer_2 = 
  '{
    "rate_profile" : {
      "customer_id": 2,
      "surcharge": {
        "item_property": "volume",
        "surcharge_type": "monetary",
        "type_value": 1
      }  
    }
  }'

customer_3 =
  '{
    "rate_profile" : {
      "customer_id": 3,
      "surcharge": {
        "item_property": "value",
        "surcharge_type": "percentage",
        "type_value": 5
      }
    }
  }'

customer_4 =
  '{
    "rate_profile" : {
      "customer_id": 4,
      "discounts": [
        {
          "is_flat": false,
          "criteria": {
            "criteria_type": "range",
            "start": 1,
            "end": 100
          },
          "discount_type": "percentage",
          "type_value": 5
        },
        {
          "is_flat": false,
          "criteria": {
            "criteria_type": "range",
            "start": 101,
            "end": 200
          },
          "discount_type": "percentage",
          "type_value": 10
        },
        {
          "is_flat": false,
          "criteria": {
            "criteria_type": "range",
            "start": 201
          },
          "discount_type": "percentage",
          "type_value": 15
        }
      ],
      "surcharge": {
        "item_property": "volume",
        "surcharge_type": "monetary",
        "type_value": 2
      }
    }
  }'

customer_5 = 
  '{
    "rate_profile" : {
      "customer_id": 5,
      "discounts": [
        {
          "is_flat": false,
          "criteria": {
            "criteria_type": "price",
            "start": 401
          },
          "discount_type": "monetary",
          "type_value": 200
        }
      ]
    }          
  }'

items_list = [
  {
    "name"=> "Fridge",
    "length"=> "3", 
    "height"=> "6",
    "width"=> "4",
    "weight"=> "300",
    "value"=> "1000"
  }
] 

1.upto(299) do |_|
  items_list.push(items_list[0].clone)
end

order = 
{
  "items"=> items_list 
}

# response = HTTParty.get("http://localhost:3000/quote/1", body: order)
# p response.body
# anticipated
"{\"message\":\"Quote successfully generated\",\"quote\":{\"number_of_items\":300,\"subtotal\":6000,\"discount_total\":600,\"total\":5400}}"

# response = HTTParty.get("http://localhost:3000/quote/2", body: order)
# p response.body
# anticipated
"{\"message\":\"Quote successfully generated\",\"quote\":{\"number_of_items\":300,\"subtotal\":27600,\"discount_total\":0,\"total\":27600}}"

# response = HTTParty.get("http://localhost:3000/quote/3", body: order)
# p response.body
# anticipated
"{\"message\":\"Quote successfully generated\",\"quote\":{\"number_of_items\":300,\"subtotal\":21000,\"discount_total\":0,\"total\":21000}}"

# response = HTTParty.get("http://localhost:3000/quote/4", body: order)
# p response.body
# anticipated
"{\"message\":\"Quote successfully generated\",\"quote\":{\"number_of_items\":300,\"subtotal\":49200,\"discount_total\":4920,\"total\":44280}}"

# response = HTTParty.get("http://localhost:3000/quote/5", body: order)
# p response.body
# anticipated
"{\"message\":\"Quote successfully generated\",\"quote\":{\"number_of_items\":300,\"subtotal\":6000,\"discount_total\":200,\"total\":5800}}"

