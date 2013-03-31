require 'helper'
require 'openssl'

describe Sandal::Sig::RS256 do
  it 'can sign data and verify signatures' do
    data = 'Hello RS256'
    private_key = OpenSSL::PKey::RSA.generate(2048)
    signer = Sandal::Sig::RS256.new(private_key)
    signature = signer.sign(data)
    validator = Sandal::Sig::RS256.new(private_key.public_key)
    validator.valid?(signature, data).should == true
  end
end

describe Sandal::Sig::RS384 do
  it 'can sign data and verify signatures' do
    data = 'Hello RS384'
    private_key = OpenSSL::PKey::RSA.generate(2048)
    signer = Sandal::Sig::RS384.new(private_key)
    signature = signer.sign(data)
    validator = Sandal::Sig::RS384.new(private_key.public_key)
    validator.valid?(signature, data).should == true
  end
end

describe Sandal::Sig::RS512 do
  it 'can sign data and verify signatures' do
    data = 'Hello RS512'
    private_key = OpenSSL::PKey::RSA.generate(2048)
    signer = Sandal::Sig::RS512.new(private_key)
    signature = signer.sign(data)
    validator = Sandal::Sig::RS512.new(private_key.public_key)
    validator.valid?(signature, data).should == true
  end
end