json.id           admin_user.id
json.name         admin_user.name
json.username     admin_user.username
json.email        admin_user.email
json.is_superuser admin_user.is_superuser
json.last_login   admin_user.last_login

if admin_user.bio.present? && admin_user.bio.headshot.present?
  json.headshot admin_user.bio.headshot.thumb.url
end
