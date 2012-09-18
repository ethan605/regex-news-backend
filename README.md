# regex-news-backend

e-News reader system using Regular Expression

## APIs

The system uses HMAC method to secure APIs. A request should include:

- Public key
- Request params
- HMAC of entire request

HMAC of entire request is calculated using private key (which is exclusively
shared between server & client) and message with format:

<code>/request/path|request-method|public-key|request|params</code>

<em>For example, with request:</em>

- path: <code>/sites/rules</code>
- method: <code>GET</code>
- public key: <code>abcdef123456</code>
- params:
<code>
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
</code>

We have message: <code>"/sites/rules|GET|abcdef123456|id|123456|email|test@domain.com|test2@domain.com|obj|pass|123|word|456"</code>

## Progress
#### Added sites:

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

#### Pending sites:

- http://genk.vn
- http://laodong.com.vn
- http://tienphongonline.com.vn
- http://tuanvietnam.net
- http://vn.news.yahoo.com
- http://vtc.vn