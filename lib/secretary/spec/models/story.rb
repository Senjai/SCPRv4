module Secretary
  module Test
    class Story < ActiveRecord::Base
      attr_accessible :headline, :body, :logged_user_id
      outpost_model
      has_secretary
    end
  end
end
