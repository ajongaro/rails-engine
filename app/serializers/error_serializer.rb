class ErrorSerializer
  attr_reader :error_message, :status, :code

  def initialize(message, status = 404, code = 404)
    @error_message = message
    @status = status
    @code = code
  end

  def self.merchant_json 
    {
      "data": {
          "id": nil,
          "type": "merchant",
          "attributes": {}
      }
    }
  end

  def self.le_json 
    {
      "data": {
          "id": nil,
          "type": "merchant",
          "attributes": {}
      }
    }
  end

  def self.item_json 
    {
      "data": {
          "errors": "Item not found",
          "status": 400,
          "code": 400 
      }
    }
  end
end