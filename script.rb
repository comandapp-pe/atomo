# typed: true
require 'sorbet-runtime'

class MyStruct < T::Struct
  const :id, Integer
  const :code, String
  const :name, String
  const :quantity, Integer
  const :price, Float
end

my_struct = MyStruct.new(foo: 40)

params = {
  "SALEDATE" => "2021-06-27 19:02:31",
  "REFNO" => "155703449",
  "REFNOEXT" => "",
  "ORDERNO" => "74",
  "ORDERSTATUS" => "PAYMENT_AUTHORIZED",
  "PAYMETHOD" => "Visa/MasterCard",
  "FIRSTNAME" => "John",
  "LASTNAME" => "Doe",
  "COMPANY" => "",
  "REGISTRATIONNUMBER" => "",
  "FISCALCODE" => "",
  "CBANKNAME" => "",
  "CBANKACCOUNT" => "",
  "ADDRESS1" => "-",
  "ADDRESS2" => "",
  "CITY" => "-",
  "STATE" => "-",
  "ZIPCODE" => "-",
  "COUNTRY" => "Peru",
  "PHONE" => "",
  "FAX" => "",
  "CUSTOMEREMAIL" => "waterquarks@gmail.com",
  "FIRSTNAME_D" => "John",
  "LASTNAME_D" => "Doe",
  "COMPANY_D" => "",
  "ADDRESS1_D" => "-",
  "ADDRESS2_D" => "",
  "CITY_D" => "-",
  "STATE_D" => "-",
  "ZIPCODE_D" => "-",
  "COUNTRY_D" => "Peru",
  "PHONE_D" => "",
  "IPADDRESS" => "179.6.215.254",
  "CURRENCY" => "USD",
  "IPN_PID" => ["35891230"],
  "IPN_PNAME" => ["RPTSA - Institucional"],
  "IPN_PCODE" => ["GVL30G5E7P"],
  "IPN_INFO" => [""],
  "IPN_QTY" => ["1"],
  "IPN_PRICE" => ["20.00"],
  "IPN_VAT" => ["0.00"],
  "IPN_VER" => ["1"],
  "IPN_DISCOUNT" => ["0.00"],
  "IPN_PROMONAME" => [""],
  "IPN_DELIVEREDCODES" => [""],
  "IPN_TOTAL" => ["20.00"],
  "IPN_TOTALGENERAL" => "20.00",
  "IPN_SHIPPING" => "0.00",
  "IPN_SHIPPING_TAX" => "0.00",
  "IPN_COMMISSION" => "1.80",
  "IPN_CUSTOM_35891230_TEXT" => ["Format", "Length"],
  "IPN_CUSTOM_35891230_VALUE" => ["horizontal", "15"],
  "IPN_DATE" => "20210627190241",
  "HASH" => "bd0edbfb95e29a3bcf2d0322f02a6908"
}
