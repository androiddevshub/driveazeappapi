Rails.application.routes.draw do
  scope '/api' do
    devise_for :users, controllers: { registrations: 'registrations',
                                      sessions: 'sessions',
                                      passwords: 'passwords'}

    post 'user/verify', to: 'verify#verify_user'
    delete 'user/sign_out', to: 'verify#destroy_user'
    get '/user/dashboard', to: 'dashboards#index'
    get 'user_logged_in', to: 'dashboards#user_logged_in'
  end

end
