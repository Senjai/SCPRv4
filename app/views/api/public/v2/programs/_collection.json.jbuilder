json.array! programs do |program|
  json.partial! "api/public/v2/programs/program", program: program
end
