module APN
  module Connection
    
    class << self
      
      # Yields up an SSL socket to write notifications to.
      # The connections are close automatically.
      # 
      #  Example:
      #   APN::Configuration.open_for_delivery do |conn|
      #     conn.write('my cool notification')
      #   end
      # 
      # Configuration parameters are:
      # 
      #   configatron.apn.passphrase = ''
      #   configatron.apn.port = 2195
      #   configatron.apn.host = 'gateway.sandbox.push.apple.com' # Development
      #   configatron.apn.host = 'gateway.push.apple.com' # Production
      #   configatron.apn.cert = File.join(rails_root, 'config', 'apple_push_notification_development.pem')) # Development
      #   configatron.apn.cert = File.join(rails_root, 'config', 'apple_push_notification_production.pem')) # Production
      def open_for_delivery(options = {}, &block)
        open(options, &block)
      end
      
      # Yields up an SSL socket to receive feedback from.
      # The connections are close automatically.
      # Configuration parameters are:
      # 
      #   configatron.apn.feedback.passphrase = ''
      #   configatron.apn.feedback.port = 2196
      #   configatron.apn.feedback.host = 'feedback.sandbox.push.apple.com' # Development
      #   configatron.apn.feedback.host = 'feedback.push.apple.com' # Production
      #   configatron.apn.feedback.cert = File.join(rails_root, 'config', 'apple_push_notification_development.pem')) # Development
      #   configatron.apn.feedback.cert = File.join(rails_root, 'config', 'apple_push_notification_production.pem')) # Production
      def open_for_feedback(options = {}, &block)
        options = {:cert => configatron.apn.feedback.cert,
                   :passphrase => configatron.apn.feedback.passphrase,
                   :host => configatron.apn.feedback.host,
                   :port => configatron.apn.feedback.port}.merge(options)
        open(options, &block)
      end
      
      private
      def open(options = {}, &block) # :nodoc:
        options = {:cert => configatron.apn.cert,
                   :passphrase => configatron.apn.passphrase,
                   :host => configatron.apn.host,
                   :port => configatron.apn.port}.merge(options)
        cert = File.read(options[:cert])
        ctx = OpenSSL::SSL::SSLContext.new
        ctx.key = OpenSSL::PKey::RSA.new(cert, options[:passphrase])
        ctx.cert = OpenSSL::X509::Certificate.new(cert)
  
        sock = TCPSocket.new(options[:host], options[:port])
        ssl = OpenSSL::SSL::SSLSocket.new(sock, ctx)
        ssl.sync = true
        ssl.connect
  
        yield ssl, sock if block_given?
  
        ssl.close
        sock.close
      end
      
    end
    
  end # Connection
end # APN