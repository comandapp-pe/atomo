require 'openssl'

params = { "SALEDATE" => "2021-06-21 23:00:40", "REFNO" => "155450194", "REFNOEXT" => "", "ORDERNO" => "63", "ORDERSTATUS" => "COMPLETE", "PAYMETHOD" => "Visa/MasterCard", "FIRSTNAME" => "John", "LASTNAME" => "Doe", "COMPANY" => "", "REGISTRATIONNUMBER" => "", "FISCALCODE" => "", "CBANKNAME" => "", "CBANKACCOUNT" => "", "ADDRESS1" => "-", "ADDRESS2" => "", "CITY" => "-", "STATE" => "-", "ZIPCODE" => "-", "COUNTRY" => "Peru", "PHONE" => "", "FAX" => "", "CUSTOMEREMAIL" => "waterquarks@gmail.com", "FIRSTNAME_D" => "John", "LASTNAME_D" => "Doe", "COMPANY_D" => "", "ADDRESS1_D" => "-", "ADDRESS2_D" => "", "CITY_D" => "-", "STATE_D" => "-", "ZIPCODE_D" => "-", "COUNTRY_D" => "Peru", "PHONE_D" => "", "IPADDRESS" => "179.6.215.254", "CURRENCY" => "PEN", "IPN_PID" => ["35891230"], "IPN_PNAME" => ["RPTSA - Institucional"], "IPN_PCODE" => ["GVL30G5E7P"], "IPN_INFO" => [""], "IPN_QTY" => ["1"], "IPN_PRICE" => ["98.09"], "IPN_VAT" => ["0.00"], "IPN_VER" => ["1"], "IPN_DISCOUNT" => ["0.00"], "IPN_PROMONAME" => [""], "IPN_DELIVEREDCODES" => [""], "IPN_TOTAL" => ["98.09"], "IPN_TOTALGENERAL" => "98.09", "IPN_SHIPPING" => "0.00", "IPN_SHIPPING_TAX" => "0.00", "IPN_COMMISSION" => "8.2396", "IPN_CUSTOM_35891230_TEXT" => ["Format", "Length"], "IPN_CUSTOM_35891230_VALUE" => ["vertical", "15"], "IPN_DATE" => "20210621230559", "HASH" => "5121ce5260194bc984fe9c267b701522" }

pid = params["IPN_PID"].first
pname = params["IPN_PNAME"].first
ipn_date params["IPN_DATE"]

pid = "1"
pname = "Software program"
ipn_date = "20050303123434"
date = "20050303123434"

key = 'm&fsBk(ZxhMe)D%!|WqJ'

data = [pid, pname, ipn_date, date].map {|value| "#{value.bytesize}#{value}"}.join.to_s

result = OpenSSL::HMAC.hexdigest("md5", key, data)

output = "<EPAYMENT>#{date}|#{result}</EPAYMENT>"

puts output



