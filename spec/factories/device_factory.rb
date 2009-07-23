module DeviceFactory
  
  class << self
    
    def new(options = {})
      options = {:token => DeviceFactory.random_token}.merge(options)
      return APN::Device.new(options)
    end
    
    def create(options = {})
      device = DeviceFactory.new(options)
      device.save
      return device
    end
    
    def random_token
      tok = []
      8.times do
        tok << String.randomize(8)
      end
      tok.join(' ').downcase
    end
    
  end
  
end

DeviceFactory.create