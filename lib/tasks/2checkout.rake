namespace :'2checkout' do

  desc 'Sample 2Checkout rake task with description'
  task :sample do
    puts 'Hello, world!'
  end

  desc 'Connects to the 2Checkout API'
  task :api do
    vendor_code = '251019015085'

    request_date_time = Time.now.utc.strftime '%Y-%m-%d %H:%M:%S'

    secret_key = 'm&fsBk(ZxhMe)D%!|WqJ'

    hashable = vendor_code.length.to_s + vendor_code + request_date_time.length.to_s + request_date_time

    hash = OpenSSL::HMAC.hexdigest("md5", secret_key, hashable)

    response = Faraday.get('https://api.2checkout.com/rest/6.0/products/GVL30G5E7P', nil, {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'X-Avangate-Authentication': "code=\"#{vendor_code}\" date=\"#{request_date_time}\" hash=\"#{hash}\""
    })

    puts response.body
  end

end

