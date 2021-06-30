class Admin::Session < ApplicationRecord
  belongs_to :admin_user, class_name: 'Admin::User'
end
