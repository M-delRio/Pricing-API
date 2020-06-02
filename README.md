## Overview

This API is degined to handle two main actions:
1) Sales Team members can make a request to create a new pricing profile for an existing customer.
2) Customers can make a request to receive a quote for storing new items. 

### Deployment
This API is currently in development, enter `rails server` from the root folder (`pricing_api`) to issue requests to a local base URL (`http://localhost:3000`).


### Database
This application is configured to use PostgreSQL. 

`db:seed` loads six dummy customers in the customers table

### Testing
Model tests that apply to tables representing pricing properties can be found in `test/models`. 

Testing related to generating quotes can be found in `test/quote_tests.rb`.

Conventional [HTTP response codes](https://developer.mozilla.org/en-US/docs/Web/HTTP/Status) indicate the success or failure of an API request.

# Sales Team

## Create Pricing - Request

- populate the attributes and child objects of the **rate object** to create a customer's pricing profile

### The rate object

This object contains the identifier of the customer a pricing profile belongs to and the attributes that define the pricing structure. 

```json
{ 
  "customer_id": 123,
  "surcharge": {Surcharge object},
  "discounts": [Discount object(s)],      
}
```
##### Attributes
- **customer_id**(positive integer): the id of the customer to be associate with the new pricing profile  
- **surcharge**(hash) - optional: this object contains attributes that define how a surcharge related to a customer's order is calculated
- **discounts**(array of hashes) - optional: a list of objects that hold the attributes that define how discounts related to a customer's order are calculated

#### The rate object child attributes
#### rate.surcharge  - the surcharge object

```json
"surcharge": {
  "item_property": "volume",
  "surcharge_type": "monetary",
  "type_value": 2  
}
```
##### Attributes
- **item_property**(string): the property of an item whose value is used to calculate the surcharge 
  - accepted values: `volume` or `value`
- **surcharge_type**(string): is the surcharge a *percentage* of *surcharge.item_property* or a monetary value applied to each *unit* of *surcharge.item_property*
  - accepted values: `percentage` or `monetary`
- **type_value**(positive integer): the numeric value of *surcharge.type*

#### rate.discounts
A flat discount can be described with a single **discount object**. Discounts that apply to a range of items in an order may require a list **discount objects**

#### the discount object
```json
"discounts": [
  {
    "is_flat": false,
    "criteria": {},
    "discount_type": "percentage",
    "type_value": 10,
  }
]
```
##### Attributes
- **is_flat**(boolean): a value of *true* indicates a flat discount (a discount that that does not vary based on the number of storage items or on any storage item properties)
  - when entering a flat discount: the *discount.criteria* attribute is optional and the *discount.value_type* attribute is not applicable (percentage based flat discounts are currently not supported)
- **criteria**(hash): holds the [properties](#discount.criteria-child-attributes) that specify which storage items are eligible for the discount 
- **discount_type**(string): is the discount a *percentage* of the subtotal of charges related to specific storage items (or all of the items) or is the discount a *monetary* value?
  - accepted values: `percentage` or `monetary`
- **type_value**(positive integer): the numeric value of *surcharge.type*

#### the criteria object 
Specify the condition that needs to be met for a given discount to take effect 

#### discount.criteria child attributes
```json
"criteria": {
  "criteria_type": "range",
  "start": 1,
  "end": 100
}
```

- **criteria_type**(string): does the item number need to be within a specific *range* of items or does the order need to meet a subtotal *price* threshold for the discount to be applied
  - accepted values: `range` or `price`
  - when entering a criteria of type *price* the *criteria.end* attribute is not applicable
- **start**(positive integer): the first number of an item range or the minimum subtotal amount 
- **end**(positive integer): the last number of an item range that is eligible for the discount
  - if the range being entered continues for an indefinite number of storage items ommit this attribute

### Endpoint

`POST /rates`

- submit a JSON hash with a single *rate_profile* attribute that references a rate object
- see [below](#create-pricing---example) for a complete example


```json
{
  "rate_profile": Rate Object
}
```
## Create Pricing - Response

### Success

A JSON object is returned if creating the pricing profile succeeded. 

```json
{
  "message": "Customer pricing successfully created",
  "rate_profile": submitted Rate Object
}
```

### Create Pricing - Example
- Discounts: 5% discount for the first 100 items stored, 10% discount for the next 100 and then 15% on each additional item 
- Surcharge: $2 per unit of volume for all items

#### Request body
```json
{
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
}
```

#### Response body
```json
{
  "message": "Customer pricing successfully created",
  "rate_profile": submitted Rate Object, see above
}
```

# Customers

## Generate a Quote - Request 

- submit a list of JSON representations of the items you wish to store 
- your customer id is required as a URL parameter

### The Item Object

This is an object representing an item you want to store.

```json
{
  "name": "Fridge",
  "length": "3", 
  "height": "6",
  "width": "4",
  "weight": "300",
  "value": "1000"
}
```
**Attributes**

- all of the following attributes are represented as a string, numbers should be string representations of integers
- **name**: description of the item
- **length**: the length of the item in inches 
- **heigth**: the heigth of the item in inches 
- **width**: the width of the item in inches
- **weight**: the weight of the item in inches 
- **value**: the value of the item in CAD

### Endpoint

`GET /quote/:customer_id`

- submit a JSON array of item objects:
```json
{
  "items": [
    {
      Item Object 1, 
      Item Object 2, 
      Item Object 3
    },
  ]
}
```

## Generate a Quote - Response

### Success

A JSON object with an attribute that references a **quote object** is returned if your request sucessfully generated a quote.

### The Quote Object
This is an object representing your quote. 

```json
{
  "quote": {
    "number_of_items": 10,
    "subtotal": 100,
    "discount_total": 10,
    "total": 90
  }
}
```

##### Attributes
- **items**(integer): the total number of items included for this quote

- **subtotal**(positive integer): your storage cost without applicable discounts

- **discount**(positive integer): total value of discounts applied to your order

- **total**(positive integer): your storage cost including applied discounts for your requested items 

### Generate a Quote - Example

A customer with an id of 1 would make a request to the endpoint as follows:

`GET /quote/1`

#### Request body
```json
{
  "items": [
    {
      "name": "Fridge",
      "length": "3", 
      "height": "6",
      "width": "4",
      "weight": "300",
      "value": "1000"
    },
    {
      "name": "sofa",
      "length": "6", 
      "height": "4",
      "width": "3",
      "weight": "100",
      "value": "500"
    }
  ]
}
```

#### Response body
```json
{
    "message": "Quote successfully generated",
    "quote": {
        "number_of_items": 2,
        "subtotal": 328,
        "discount_total": 16,
        "total": 312
    }
}
```

