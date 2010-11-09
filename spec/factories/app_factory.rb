module AppFactory
  
  class << self
    
    def new(options = {})
      options = {:apn_dev_cert => AppFactory.random_cert, 
                 :apn_prod_cert => AppFactory.random_cert}.merge(options)
      return APN::App.new(options)
    end
    
    def create(options = {})
      app = AppFactory.new(options)
      app.save
      return app
    end
    
    def random_cert
      tok = []
      tok << String.randomize(50)
      tok.join('').downcase
    end
    
  end
  
end

AppFactory.create