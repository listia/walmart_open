module WalmartOpen
  class ShippingAddress

    attr_accessor :street1, :street2, :city, :state, :zipcode, :country

    def initialize(params)
      @street1 = params[:street1]
      @street2 = params[:street2]
      @city = params[:city]
      @state = params[:state]
      @zipcode = params[:zipcode]
      @country = params[:country]
    end

    def valid?
      street1 && city && state && zipcode && country
    end
  end
end
