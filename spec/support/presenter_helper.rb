module PresenterHelper
  extend self
  
  def presenter(object)
    described_class.new(object, view)
  end
end