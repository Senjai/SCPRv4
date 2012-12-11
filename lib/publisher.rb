module Publisher
  extend self
  
  def publish(args={})
    object  = args[:object]
    action  = args[:action]
    options = (args[:options] || {}).stringify_keys!

    data = {
      :key       => object.obj_key,
      :action    => action,
      :headline  => object.to_title,
      :url       => object.remote_link_path,
      :admin_url => object.admin_edit_path,
      :status    => object.status
    }.merge(options)
    
    $redis.publish("scprcontent", data.to_json)
  end
end
