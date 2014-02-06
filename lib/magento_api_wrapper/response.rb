module MagentoApiWrapper
  class Response

    attr_accessor :document

    #Creates a ruby hash from objects returned by Savon
    def initialize(response)
      @document = response.to_hash
    end

    def self.attr_map
      @attr_map
    end

    def to_hash
      hash = {}
      self.class.attr_map.keys.each do |attr|
        hash[attr] = send(attr)
      end
      hash
    end

  end
end
