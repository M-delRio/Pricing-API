Rails.application.routes.draw do
  post 'rates', to: 'rates#create'
  
  get 'quote/:customer_id', to: 'quote#generate_quote'
end
