class Admin::AdminUsersController < Admin::ResourceController
  #---------------
  # Outpost
  self.model = AdminUser

  define_list do
    list_order "last_name"
    
    column :username
    column :email
    column :first_name
    column :last_name
    column :is_superuser
    column :is_staff
  end

  #---------------
  # Override this method from Admin::ResourceController
  # Users should always be able to see and update their
  # own profile.
  def authorize_resource
    if admin_user == @record && %w{show edit update activity}.include?(action_name)
      return true
    end
    
    super
  end
  
  #---------------

  def activity
    get_record
    breadcrumb @record.to_title, @record.admin_edit_path, "Activity"
    list = Admin::VersionsController.list
    @versions = @record.activities.order(list.order).page(params[:page]).per(list.per_page)
    render '/admin/versions/index', locals: { list: list }
  end
end
