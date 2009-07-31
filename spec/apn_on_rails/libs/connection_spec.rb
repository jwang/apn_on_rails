require File.dirname(__FILE__) + '/../../spec_helper'

describe APN::Connection do

  describe 'open_for_delivery' do
    
    it 'should create a connection to Apple, yield it, and then close' do
      rsa_mock = mock('rsa_mock')
      OpenSSL::PKey::RSA.should_receive(:new).with(apn_cert, '').and_return(rsa_mock)

      cert_mock = mock('cert_mock')
      OpenSSL::X509::Certificate.should_receive(:new).and_return(cert_mock)

      ctx_mock = mock('ctx_mock')
      ctx_mock.should_receive(:key=).with(rsa_mock)
      ctx_mock.should_receive(:cert=).with(cert_mock)
      OpenSSL::SSL::SSLContext.should_receive(:new).and_return(ctx_mock)
      
      tcp_mock = mock('tcp_mock')
      tcp_mock.should_receive(:close)
      TCPSocket.should_receive(:new).with('gateway.sandbox.push.apple.com', 2195).and_return(tcp_mock)
      
      ssl_mock = mock('ssl_mock')
      ssl_mock.should_receive(:sync=).with(true)
      ssl_mock.should_receive(:connect)
      ssl_mock.should_receive(:write).with('message-0')
      ssl_mock.should_receive(:write).with('message-1')
      ssl_mock.should_receive(:close)
      OpenSSL::SSL::SSLSocket.should_receive(:new).with(tcp_mock, ctx_mock).and_return(ssl_mock)
      
      APN::Connection.open_for_delivery do |conn, sock|
        conn.write('message-0')
        conn.write('message-1')
      end
      
    end
    
  end
  
end
