class Api::CommentsController < ApplicationController
  
  # Return a comment count for each comma-separated key in ?ids=
  def count
    contents = []
    
    params[:ids].split(",").each do |id|
        contents << ContentBase.obj_by_key(id) || {}
    end
    
    render :json => contents.inject({}) { |h,c| h[c.obj_key] = { :obj_key => c.obj_key, :comments => c.comment_count }; h }
  end
end