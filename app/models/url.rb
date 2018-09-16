class Url < ApplicationRecord
  validates :long_url, presence: true
  validates :long_url, format: {with: /\A(?:(?:http|https):\/\/)?([-a-zA-Z0-9.]{2,256}\.[a-z]{2,4})\b(?:\/[-a-zA-Z0-9@,!:%_\+.~#?&\/\/=]*)?\z/,
  :message => "invalid url format" }

  before_save :sanitize_url
  before_save :generate_short_url

  has_many :click_stats

  SHORT_URL_LENGTH = 5

  def sanitize_url
    url = (self.long_url || "").gsub("(http://)|(https://)|(www\.)","")
    self.sanitize_url = "http://#{url}"
  end

  def duplicate
    Url.find_by_sanitize_url(self.sanitize_url)
  end

  def is_duplicate?
    duplicate.present?
  end

  def generate_short_url(clash_count=0)
    raise "Too many short URL clashes. Please increase the short url length" if clash_count == 10
    url = self.sanitize_url
    shortened_url = Digest::MD5.hexdigest(url)[(0+clash_count)..(SHORT_URL_LENGTH+clash_count)]
    url_present = Url.find_by_short_url(shortened_url)
    if(url_present)
      generate_short_url(clash_count+1)
    else
      self.short_url = shortened_url
    end
  end
end
