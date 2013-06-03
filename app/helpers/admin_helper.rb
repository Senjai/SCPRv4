module AdminHelper
  # Pass in a path to the JSON file, get back pure JSON
  def render_json(path, locals={})
    raw(j(render(partial: path, formats: [:json], locals: locals)))
  end
end
