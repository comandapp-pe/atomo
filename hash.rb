require 'json'
require 'faraday'
require 'openssl'

time = Time.now.utc.strftime "%Y-%m-%d %H:%M:%S"

merchant_code = '251018994895'

hashable = merchant_code.length.to_s + merchant_code + time.length.to_s + time

merchant_secret_key = '~o^76=q+zaZSDue5CLc%'

hash = OpenSSL::HMAC.hexdigest("MD5", merchant_secret_key, hashable)

url = 'https://webhook.site/7f1209c6-2255-44c9-bc41-8e5abdaf22e6'

# url = 'https://api.2checkout.com/rpc/6.0'

res = Faraday.post(
  url,
  {
    id: 1,
    jsonrpc: '2.0',
    method: 'login',
    params: {
      merchantCode: merchant_code,
      date: time,
      hash: hash
    }
  }.to_json,
  {
    'Content-Type': 'application/json',
    'Accept': 'application/json'
  }
)

puts res.body
