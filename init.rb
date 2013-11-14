require 'redmine'
require_dependency 'appspace_users_patch'

Rails.logger.info 'Starting Timesheets Application'

Redmine::Plugin.register :redmine_app_timesheets do
  name 'Redmine Timesheets Application'
  author 'Massimo Rossello'
  description 'Timesheets application for global app space'
  version '0.0.1'
  url 'https://github.com/maxrossello/redmine_app_timesheets.git'
  author_url 'https://github.com/maxrossello'
  requires_redmine :version_or_higher => '2.0.0'
  requires_redmine_plugin :redmine_app__space, '0.0.2'

  settings(:default => {
      'project' => "",
      'admin_group' => "",
      'tracker' => "",
  },
  :partial => 'timesheets/settings'
  )

end

# needs to be evaluated before /apps(/:tab)!
RedmineApp::Application.routes.prepend do
  application 'timesheets', :to => 'timesheets#index', :via => :get
  application 'order_mgmt', :to => 'orders#index', :via => :get

  put 'apps/order_mgmt/disable/:id', :controller => 'orders', :action => 'disable'
  put 'apps/order_mgmt/enable/:id', :controller => 'orders', :action => 'enable'
  post 'apps/order_mgmt/create', :controller => 'orders', :action => 'create'
  get 'apps/order_mgmt/new', :controller => 'orders', :action => 'new'

  get 'apps/order_users/:id', :controller => 'order_users', :action => 'index'
  get 'apps/order_users/:id/new', :controller => 'order_users', :action => 'new'
  get 'apps/order_users/:id/autocomplete_for_user', :controller => 'order_users', :action => 'autocomplete_for_user'
  post 'apps/order_users/:id/create', :controller => 'order_users', :action => 'create'
  post 'apps/order_users/:id/append', :controller => 'order_users', :action => 'append'
  delete 'apps/order_users/:id/destroy', :controller => 'order_users', :action => 'destroy'

  post 'apps/timesheets/save_weekly', :controller => 'timesheets', :action => 'save_weekly'
  delete 'apps/timesheets/delete_row', :controller => 'timesheets', :action => 'delete_row'
end

module Timesheet
  class Hooks < Redmine::Hook::ViewListener

    def view_layouts_base_html_head(context = { })
      stylesheet_link_tag 'timesheets.css', :plugin => 'redmine_app_timesheets'
    end

  end
end