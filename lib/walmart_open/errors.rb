module WalmartOpen
  class WalmartOpenError < ::StandardError
  end

  class AuthenticationError < WalmartOpenError
  end

  class ItemNotFoundError < WalmartOpenError
  end

  class OrderError < WalmartOpenError
  end
end