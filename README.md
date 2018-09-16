I have used two models here Url and ClickStat
Url model stores information about the user provided long_url and generate short_url and sanitized_url

I have given explanation about how i generate short 6 character alphanumeric
sanitize url is for not duplicating records like www.example.com,http://www.example.com, https://www.example.com,
example.com all the above url will be saved as http://google.com in sanitize_url column

ClickStat gives statistics about how many times the short url is called and from where it is called and the time of click 

UrlController has method to accept long_url and generate short url and redirect short url to original url.
UrlController also has an API method 'url_stats' which json data about the stats of the url

test cases core functionality are written in rspec for models and controller 

