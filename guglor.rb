require 'rubygems'
require 'sinatra'
require 'nokogiri'
require 'open-uri'
require 'haml'

get '/' do
 haml ""
end


#get  %r{/\/search\?q=(.+)} do |q|
get '/search' do
  if params[:q] 
    redirect '/' + params[:q] 
  else
    redirect '/'
  end
end

get '/:word' do
  @word= params[:word]
  q=URI.escape(@word,Regexp.new("[^#{URI::PATTERN::UNRESERVED}]")) # escape url
  urlGoogle='http://www.google.ru/search?q=' + q +'&ie=utf-8&oe=utf-8' # combine full url
#  urlYandex='http://yandex.ru/yandsearch?text=' + q
  rGoogle = Nokogiri::HTML(open(urlGoogle), nil, 'UTF-8') # get page
  zGoogle = rGoogle.xpath('/html/body/div[5]/div[3]/p[1]/a/b/i') # parse page
  if zGoogle[0] != nil 
    @correctWord = zGoogle[0].content 
    haml :notright  
  else
    haml :right
  end 
#    rYandex = Nokogiri::HTML(open(urlYandex), nil, 'UTF-8')
#    zYandexMistake= rYandex.xpath('/html/body/table/tbody/tr[2]/td[4]/div/div/a')[0].content
#    'Правильно: ' +zGoogle[0].content unless !zGoogle[0]
#    zYandexMean= rYandex.xpath('/html/body/table/tbody/tr[2]/td[4]/div/div/a')[0].content
#    word + " " + zYandexMean + " " + zYandexMean + " " + zGoogle
end
  
# 'исправлена опечатка' /html/body/table/tbody/tr[2]/td[4]/div
# правильно .//*[@id='b-head-search']/table/tbody/tr[1]/td[1]/div/input[1]/@value 

# Имели ввиду /html/body/table/tbody/tr[2]/td[4]/div/div/a
