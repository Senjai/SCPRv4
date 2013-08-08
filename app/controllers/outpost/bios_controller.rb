class Outpost::BiosController < Outpost::ResourceController
  outpost_controller

  define_list do |l|
    l.default_order       = "name"
    l.default_sort_mode   = "asc"

    l.column :name, sortable: true
    l.column :email
    l.column :title
    l.column :is_public, header: "Public?"

    l.filter :is_public, title: "Public?", collection: :boolean
  end

  #---------------
  # Override this method from Outpost::ResourceController
  # Users should always be able to see and update their
  # own bio.
  def authorize_resource
    if current_user.bio.present? &&
      current_user.bio == @record &&
      %w{show edit update}.include?(action_name)
      return true
    end

    super
  end
end
