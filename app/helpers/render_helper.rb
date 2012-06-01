module RenderHelper
  def submit_row(record)
    render('admin/shared/submit_row', record: record)
  end
end