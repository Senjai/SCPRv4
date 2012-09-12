class PeopleController
  include AdminResource::Helpers::Controller
  
  def params
    {
      controller: "admin/people"
    }
  end
end
