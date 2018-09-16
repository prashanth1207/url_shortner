require 'spec_helper'

describe Url do
  describe 'validations' do
    @url = Url.new
    it "should not have empty values for long_url" do
      url = Url.new
      expect(url).not_to be_valid
    end
    it "long_url should be a valid url" do
      url = Url.new
      url.long_url = "www.facebook.com/#{Faker::Name.first_name}"
      url.save
      expect(url).to be_valid
    end

    it "should not save invalid long_url" do
      url = Url.new
      url.long_url = Faker::Name.name.split(" ").join("_")
      url.save
      expect(url.errors.full_messages.to_s).to  match("Invalid url")
    end

    it "should create short url and sanitize url from long url before save" do
      url = Url.new(long_url: "www.facebook.com")
      url.save
      expect(url).to be_valid
      expect(url.short_url.length).to be < 10
    end
  end
end
