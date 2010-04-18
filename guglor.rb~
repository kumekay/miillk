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
  result =0
  q=URI.escape(@word,Regexp.new("[^#{URI::PATTERN::UNRESERVED}]")) # escape url
  # analyze google
  urlGoogle='http://www.google.ru/search?q=' + q +'&ie=utf-8&oe=utf-8' # combine full url
  rGoogle = Nokogiri::HTML(open(urlGoogle), nil, 'UTF-8') # get page
  zGoogle = rGoogle.xpath('/html/body/div[5]/div[3]/p[1]/a/b/i') # parse page
  if zGoogle[0] != nil 
    @correctGoogleWord = zGoogle[0].content 
    result = 3
#    haml :notright  
  else
#    haml :right
    result = 0
  end 
  # analyze Yandex
  urlYandex='http://yandex.ru/yandsearch?text=' + q
  rYandex = Nokogiri::HTML(open(urlYandex), nil, 'UTF-8')
  zYandexMean= rYandex.xpath('/html/body/div[2]/div/div[1]/div[1]/div/div/a') # 'Возможно вы имели ввиду'
  if zYandexMean[0] != nil
    @correctYandexWord = zYandexMean[0].content
    result += 1
  else
    zYandexNil = rYandex.xpath('/html/body/table/tr[2]/td[4]/div/a[1]')
    if zYandexNil[0] != nil
      zYandexCorr = rYandex.xpath("//input[@name='text']/@value")
      @correctYandexWord = zYandexCorr[0].content
      result += 2
#    else
#      result += 0
    end
  end
  @correctWord = case result 
    when 0 then @word # If no result both for Yandex and Google
    when 1..2, 5 then @correctYandexWord # If only yandex result 
    when 3 then @correctGoogleWord #If only Google result
    when 4 then  # if both Yandex and Goggle results are present
      if @correctGoogleWord == @correctYandexWord 
        @correctGoogleWord
      else
        @correctGoogleWord +' или '+ @correctYandexWord
      end
#    end
#    when 5 then @correctYandexWord #If Yandex autocorrect search string
  end
  if result == 0 
    haml :right
  else
    haml :notright
  end
  
end
  
# 'исправлена опечатка' /html/body/table/tbody/tr[2]/td[4]/div
# правильно .//*[@id='b-head-search']/table/tbody/tr[1]/td[1]/div/input[1]/@value 

# Имели ввиду /html/body/table/tbody/tr[2]/td[4]/div/div/a
