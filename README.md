regex-news-backend
==================

e-News reader system using Regular Expression

The system uses HMAC method to secure APIs. A request should include:

- Public key
- Request params
- HMAC of entire request

HMAC of entire request is calculated using private key (which is exclusively
shared between server & client) and message with format:

/request/path|request_method|public_key|request|params

For example, with request:

- path: "/sites/rules"
- method: "GET",
- public key: "abcdef123456"
- params:
{
  "id" => "123456",
  "email" => [
    "test@domain.com",
    "test2@domain.com"
  ],
  "obj" => {
    "pass" => "123",
    "word" => "456"
  }
}

We have message: "/sites/rules|GET|abcdef123456|id|123456|email|test@domain.com|test2@domain.com|obj|pass|123|word|456"

Added sites:

- http://24h.com.vn       [90%]
- http://bongdaplus.vn    [99%]
- http://dantri.com.vn    [99%]
- http://kenh14.vn        [99%]
- http://news.zing.vn     [99%]
- http://ngoisao.net      [99%]
- http://tiin.vn          [99%]
- http://tuoitre.vn       [90%]
- http://vietnamnet.vn    [99%]
- http://vnexpress.net    [99%]

Pending sites:

- http://genk.vn
- http://laodong.com.vn
- http://tienphongonline.com.vn
- http://tuanvietnam.net
- http://vn.news.yahoo.com
- http://vtc.vn