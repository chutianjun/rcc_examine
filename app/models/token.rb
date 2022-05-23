class Token
  #生成token值
  def self.encode(payload)
    #  添加过期时间为 一天
    # hash 值   exp: (Time.now.to_i + 3600)
    payload.merge!(exp: (Time.now.to_i + 3600 * 12))
    # payload  {:user_id=>1, :exp=>1652806189}
    JWT.encode(payload, Rails.application.secrets.secret_key_base)
  end

  #解密,获取token中的 用户信息
  def self.decode(token)
    begin
      HashWithIndifferentAccess.new(JWT.decode(token, Rails.application.secrets.secret_key_base)[0])
    rescue JWT::ExpiredSignature
      # 抛出 token 过期异常
      raise JWT::ExpiredSignature
    end
  end
end
