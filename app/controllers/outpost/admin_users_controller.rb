class Outpost::AdminUsersController < Outpost::ResourceController
  outpost_controller

  define_list do |l|
    l.default_order = "name"
    l.default_sort_mode = "asc"

    l.column :username
    l.column :email
    l.column :name, sortable: true, default_sort_mode: "asc"
    l.column :is_superuser, header: "Superuser?"
    l.column :can_login, header: "Can Login?"

    l.filter :is_superuser, collection: :boolean
    l.filter :can_login, collection: :boolean
  end

  #---------------
  # Override this method from Outpost::ResourceController
  # Users should always be able to see and update their
  # own profile.
  def authorize_resource
    if @record
      if current_user == @record && %w{show edit update activity}.include?(action_name)
        return true
      end
    end

    super
  end
  
  #---------------

  def activity
    get_record
    breadcrumb @record.to_title, @record.admin_edit_path, "Activity"
    list = Outpost::VersionsController.list
    @versions = @record.activities.order("#{list.default_order} #{list.default_sort_mode}").page(params[:page]).per(list.per_page)
    render '/outpost/versions/index', locals: { list: list }
  end
end
