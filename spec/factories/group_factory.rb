module GroupFactory
  
  class << self
    
    def new(options = {})
      app = APN::App.first
      options = {:app_id => app.id, :name => GroupFactory.random_name}.merge(options)
      return APN::Group.new(options)
    end
    
    def create(options = {})
      group = GroupFactory.new(options)
      group.save
      return group
    end
    
    def random_name
      tok = []
      tok << String.randomize(8)
      tok.join(' ').downcase
    end
    
  end
  
end

GroupFactory.create