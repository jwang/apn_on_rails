module DeviceGroupingFactory
  
  class << self
    
    def new(options = {})
      device = APN::Device.first
      group  = APN::Group.first
      options = {:device_id => device.id, :group_id => group.id}.merge(options)
      return APN::DeviceGrouping.new(options)
    end
    
    def create(options = {})
      device_grouping = DeviceGroupingFactory.new(options)
      device_grouping.save
      return device_grouping
    end
    
  end
  
end

DeviceGroupingFactory.create