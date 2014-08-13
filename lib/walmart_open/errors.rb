module WalmartOpen
  class WalmartOpenError < ::StandardError
  end

  class ServerError < WalmartOpenError
  end

  class ItemNotFoundError < WalmartOpenError
  end
end
