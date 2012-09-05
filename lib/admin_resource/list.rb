module AdminResource
  module List
    DEFAULTS = {
      order:            "id desc",
      per_page:         25,
      excluded_fields:  ["id", "created_at", "updated_at"]
    }
  end
end
