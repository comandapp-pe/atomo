<?php

class HashValidationTool
{

    const SHA_256 = 'sha256';
    private $params;
    private $signature;
    private $key;

    /**
     * HashValidationTool constructor.
     *
     * @param string $key
     */
    public function __construct(string $key)
    {
        $this->key = $key;
    }

    /**
     * @return string
     */
    private function encrypt(): string
    {
        $serialized = $this->serializeParameters($this->params);

        if (strlen($serialized) > 0) {
            echo bin2hex(hash_hmac(self::SHA_256, $serialized, $this->key, true)) . PHP_EOL;

            echo 'Success: serialized params - ' . $serialized . PHP_EOL;

            return bin2hex(hash_hmac(self::SHA_256, $serialized, $this->key, true));
        } else {
            echo 'Error: serialization parameters are empty' . PHP_EOL;

            return '';
        }
    }

    /**
     * @param string $url
     *
     * @return bool
     */
    public function validate(string $url): bool
    {
        $this->setUrl($url);

        return $this->encrypt() === $this->signature;
    }

    /**
     * @param array $array
     *
     * @return string
     */
    private function serializeParameters(array $array): string
    {
        ksort($array);

        $serializedString = '';

        foreach ($array as $value) {
            if (is_array($value)) {
                $serializedString .= $this->serializeParameters($value);
            } else {
                $serializedString .= strlen($value) . $value;
            }
        }

        return $serializedString;
    }

    /**
     * @param string $url
     */
    private function setUrl(string $url): void
    {
        $urlParts = parse_url($url);
        parse_str($urlParts['query'], $this->params);
        $this->signature = $this->params['signature'];
        unset($this->params['signature']);
    }
}

$hashValidationTool = new HashValidationTool('P4nS44ff!@NX5bPV8Wkk9xe8Rk3$vgTZxgU4sYUcCEzKS-wYyfAtvcBEAN!yQVA&');

if ($hashValidationTool->validate('https://secure.2checkout.com/checkout/buy?return-url=https%3A%2F%2Fserene-woodland-34280.herokuapp.com&return-type=link&tpl=default&prod=9895TN2P8X&qty=1&signature=0b65c9eb0b48d57044a06c6c2f2fb2a0391cb61c01b1d7fb8d2875c7734b8e87')) {
    echo 'valid';
} else {
    echo 'invalid';
}
