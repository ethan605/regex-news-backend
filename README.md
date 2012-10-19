# regex-news-backend

e-News reader system using Regular Expression

## APIs

The system uses [HMAC](http://en.wikipedia.org/wiki/Hash-based_message_authentication_code) method to secure APIs. A request should include:

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

We have message: <code>/sites/rules|GET|abcdef123456|id|123456|email|test@domain.com|test2@domain.com|obj|pass|123|word|456</code>

## Progress
#### Added sites:

<table>
  <tr>
    <td><strong>Site</strong></td>
    <td><strong>Rule Progress</strong></td>
    <td><strong>Rule (Lite) Progress</strong></td>
    <td><strong>Index Progress (Pure)</strong></td>
    <td><strong>Index Progress (Hybrid)</strong></td>
  </tr>
  <tr>
    <td>http://24h.com.vn</td>
    <td><center>[90%]</center></td>
    <td><center>[100%]</center></td>
    <td><center>[0%]</center></td>
    <td><center>[0%]</center></td>
  </tr>
  <tr>
    <td>http://bongdaplus.vn</td>
    <td><center>[99%]</center></td>
    <td><center>[100%]</center></td>
    <td><center>[0%]</center></td>
    <td><center>[0%]</center></td>
  </tr>
  <tr>
    <td>http://dantri.com.vn</td>
    <td><center>[99%]</center></td>
    <td><center>[100%]</center></td>
    <td><center>[100%]</center></td>
    <td><center>[100%]</center></td>
  </tr>
  <tr>
    <td>http://kenh14.vn</td>
    <td><center>[99%]</center></td>
    <td><center>[100%]</center></td>
    <td><center>[100%]</center></td>
    <td><center>[100%]</center></td>
  </tr>
  <tr>
    <td>http://news.zing.vn</td>
    <td><center>[99%]</center></td>
    <td><center>[100%]</center></td>
    <td><center>[0%]</center></td>
    <td><center>[0%]</center></td>
  </tr>
  <tr>
    <td>http://ngoisao.net</td>
    <td><center>[99%]</center></td>
    <td><center>[100%]</center></td>
    <td><center>[100%]</center></td>
    <td><center>[0%]</center></td>
  </tr>
  <tr>
    <td>http://tuoitre.vn</td>
    <td><center>[90%]</center></td>
    <td><center>[100%]</center></td>
    <td><center>[0%]</center></td>
    <td><center>[0%]</center></td>
  </tr>
  <tr>
    <td>http://vietnamnet.vn</td>
    <td><center>[99%]</center></td>
    <td><center>[100%]</center></td>
    <td><center>[0%]</center></td>
    <td><center>[0%]</center></td>
  </tr>
  <tr>
    <td>http://vnexpress.net</td>
    <td><center>[99%]</center></td>
    <td><center>[100%]</center></td>
    <td><center>[100%]</center></td>
    <td><center>[100%]</center></td>
  </tr>
</table>

#### Pending sites:

- http://genk.vn
- http://laodong.com.vn
- http://tienphongonline.com.vn
- http://tuanvietnam.net
- http://vn.news.yahoo.com
- http://vtc.vn