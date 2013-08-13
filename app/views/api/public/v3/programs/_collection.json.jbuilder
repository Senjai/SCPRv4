json.array! programs do |program|
  json.partial! api_view_path("programs", "program"), program: program
end
