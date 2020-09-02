Gem::Specification.new do |s|
  s.name = 'drb_reg_client'
  s.version = '0.2.0'
  s.summary = 'Provides a DWS_registry service using DRb; ' + 
      'Requires a drb_reg_server to be running.'
  s.authors = ['James Robertson']
  s.files = Dir['lib/drb_reg_client.rb']
  s.add_runtime_dependency('rexle', '~> 1.5', '>=1.5.8')
  s.signing_key = '../privatekeys/drb_reg_client.pem'
  s.cert_chain  = ['gem-public_cert.pem']
  s.license = 'MIT'
  s.email = 'james@jamesrobertson.eu'
  s.homepage = 'https://github.com/jrobertson/drb_reg_client'
end
