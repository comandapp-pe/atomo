class Admin::Session < ApplicationRecord
  belongs_to :admin_user
end
