module RenderHelper
  def submit_row(record)
    render('admin/shared/submit_row', record: record)
  end
  
  def index_header(resource_class)
    render('admin/shared/index_header', resource_class: resource_class)
  end
end