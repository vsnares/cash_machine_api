Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  namespace :api do
    post  'charge'   => 'cash_machine#charge'
    post  'withdraw' => 'cash_machine#withdraw'
  end
end
