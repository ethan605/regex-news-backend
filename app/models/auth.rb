class Auth
  include Mongoid::Document

  field :private_key
  field :public_key

  scope :key, ->(_key) { return self.where(public_key: _key) }

  def self.generate_keys
    private_key = Digest::SHA2.new(384) << 'regex-news-backend'
    public_key = Digest::SHA2.new(256) << 'regex-news-backend'

    auth = Auth.new(private_key: private_key.to_s, public_key: public_key.to_s)
    auth.save
  end
end
