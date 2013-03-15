class Outpost::AdminUsersController < Outpost::ResourceController
  #---------------
  # Outpost
  self.model = AdminUser

  define_list do
    list_default_order "name"
    list_default_sort_mode "asc"

    column :username
    column :email
    column :name, sortable: true, default_sort_mode: "asc"
    column :is_superuser, header: "Superuser?"
    column :can_login, header: "Can Login?"

    filter :is_superuser, collection: :boolean
    filter :can_login, collection: :boolean
  end

  #---------------
  # Override this method from Outpost::ResourceController
  # Users should always be able to see and update their
  # own profile.
  def authorize_resource
    if current_user == @record && %w{show edit update activity}.include?(action_name)
      return true
    end
    
    super
  end
  
  #---------------

  def activity
    get_record
    breadcrumb @record.to_title, @record.admin_edit_path, "Activity"
    list = Outpost::VersionsController.list
    @versions = @record.activities.order(list.default_order).page(params[:page]).per(list.per_page)
    render '/outpost/versions/index', locals: { list: list }
  end
end
