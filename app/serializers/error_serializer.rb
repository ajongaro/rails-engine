class ErrorSerializer
  attr_reader :error_message, :status, :code

  def initialize(message, status = 404, code = 404)
    @error_message = message
    @status = status
    @code = code
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

  def compiled_json
    { 
      "data": {
        "errors": error_message,
        "status": status,
        "code": code }
    }
  end
end