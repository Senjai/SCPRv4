class AbstractModel
  include Concern::Methods::AbstractModelMethods

  attr_accessor :id, :original_object

  def initialize(attributes={})
    @original_object  = attributes[:original_object]
    @id               = attributes[:id]
  end
end
