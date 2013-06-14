module Publisher
  extend self
  
  # Publish a message to redis
  #
  # Takes a hash of:
  # * object
  # * action
  # * options
  #
  def publish(args)
    object  = args[:object]
    action  = args[:action]
    options = (args[:options] || {}).stringify_keys!

    data = {
      :key       => object.obj_key,
      :action    => action,
      :headline  => object.to_title,
      :url       => object.public_url,
      :admin_url => File.join("http://scpr.org", object.admin_edit_path),
      :status    => object.status
    }.merge(options)
    
    $redis.publish("scprcontent", data.to_json)
  end
end
