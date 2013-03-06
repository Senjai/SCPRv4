class Outpost::BiosController < Outpost::ResourceController
  #---------------
  # Outpost
  self.model = Bio

  define_list do
    list_default_order "name"
    list_default_sort_mode "asc"

    column :name, sortable: true
    column :email
    column :title
    column :is_public, header: "Public?"

    filter :is_public, title: "Public?", collection: :boolean
  end

  #---------------
  # Override this method from Outpost::ResourceController
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
