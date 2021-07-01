json.extract! admin_session, :id, :admin_user, :created_at, :updated_at
json.url admin_session_url(admin_session, format: :json)
