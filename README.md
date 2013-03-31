**NOTE: This library is pretty new and still has a lot of things that aren't finished or could be improved. Expect bugs and interface changes. Pull requests or feedback very much appreciated.**

# Sandal [![Build Status](https://travis-ci.org/gregbeech/sandal.png?branch=master)](https://travis-ci.org/gregbeech/sandal) [![Coverage Status](https://coveralls.io/repos/gregbeech/sandal/badge.png?branch=master)](https://coveralls.io/r/gregbeech/sandal) [![Code Climate](https://codeclimate.com/github/gregbeech/sandal.png)](https://codeclimate.com/github/gregbeech/sandal)

A Ruby library for creating and reading [JSON Web Tokens (JWT) drfat-06](http://tools.ietf.org/html/draft-ietf-oauth-json-web-token-06), supporting [JSON Web Signatures (JWS) draft-08](http://tools.ietf.org/html/draft-ietf-jose-json-web-signature-08) and [JSON Web Encryption (JWE) draft-08](http://tools.ietf.org/html/draft-ietf-jose-json-web-encryption-08). See the [CHANGELOG](CHANGELOG.md) for version history.

## Installation

Add this line to your application's Gemfile:

    gem 'sandal'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install sandal

## Signed Tokens

The signing part of the library is a lot smaller and easier to implement than the encryption part, so I focused on that first. All the JWA signature methods are supported:

- ES256, ES384, ES512 (note: not supported on jruby)
- HS256, HS384, HS512
- RS256, RS384, RS512
- none

Signing example:

```ruby
require 'openssl'
require 'sandal'

claims = { 
  'iss' => 'example.org',
  'sub' => 'user@example.org',
  'exp' => (Time.now + 3600).to_i
}
key = OpenSSL::PKey::EC.new(File.read('/path/to/private_key.pem'))
signer = Sandal::Sig::ES256.new(key)
token = Sandal.encode_token(claims, signer, { 
  'kid' => 'my key identifier' 
})
```

Decoding and validating example:

```ruby
require 'openssl'
require 'sandal'

claims = Sandal.decode_token(token) do |header|
  if header['kid'] == 'my key identifier'
    key = OpenSSL::PKey::EC.new(File.read('/path/to/public_key.pem'))
    Sandal::Sig::ES256.new(key)
  end
end
```

Keys for these examples can be generated by executing:

    $ openssl ecparam -out private_key.pem -name prime256v1 -genkey
    $ openssl ec -out public_key.pem -in private_key.pem -pubout

## Encrypted Tokens

This part of the library still needs a lot of work. The current version supports the AES/CBC algorithms and RSA1_5 key protection, but expect a lot of changes here. I'd avoid it for now.

## Validation Options

You can change the default validation options, for example if you only want to accept tokens from 'example.org' with a maximum clock skew of one minute:

```ruby
Sandal.default! valid_iss: ['example.org'], max_clock_skew: 60
```

Sometimes while developing it can be useful to turn off some validation options just to get things working (don't do this in production!):

```ruby
Sandal.default! validate_signature: false, validate_exp: false
```

These options can also be configured on a per-token basis by using a second `options` parameter in the block passed to the `decode` method.

## Contributing

1. Fork it
2. Create your feature branch: `git checkout -b my-new-feature`
3. Commit your changes: `git commit -am 'Add some feature'`
4. Push to the branch: `git push origin my-new-feature`
5. Create a new Pull Request



