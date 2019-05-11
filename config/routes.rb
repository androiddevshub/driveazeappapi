Rails.application.routes.draw do

  scope '/api' do
    devise_for :vendors
    devise_for :admins, controllers: { sessions: 'admin_sessions' }

    devise_for :users, controllers: { registrations: 'user_registrations',
                                      sessions: 'user_sessions',
                                      passwords: 'user_passwords'}

    post 'user/verify', to: 'verify#verify_user'
    delete 'user/sign_out', to: 'verify#destroy_user'
    get '/user/dashboard', to: 'dashboards#index'
    get '/admin/dashboard', to: 'admin_dashboards#index'
    get 'user_logged_in', to: 'dashboards#user_logged_in'
  end

end
