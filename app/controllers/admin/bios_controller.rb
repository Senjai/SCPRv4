class Admin::BiosController < Admin::ResourceController
  #---------------
  # Outpost
  self.model = Bio

  define_list do
    list_order "last_name"
    
    column :name
    column :email
    column :is_public, header: "Show on Site?"
  end

  #---------------
  # Override this method from Admin::ResourceController
  # Users should always be able to see and update their
  # own bio.
  def authorize_resource
    if admin_user.bio.present? && 
      admin_user.bio == @record && 
      %w{show edit update}.include?(action_name)
      return true
    end
    
    super
  end
end
