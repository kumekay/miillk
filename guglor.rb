require 'rubygems'
require 'vendor/sinatra/lib/sinatra.rb'
require 'nokogiri'
require 'open-uri'
require 'haml'
#require 'ruby-debug'

#configure :production, :development do
  not_found do
    haml "We're so sorry, but we don't what this is"
  end

  error do
    haml "Something really nasty happened.  We're on it!" + request.env['sinatra.error'].message
  end
#end

#error CouldNotCheck do
#  'So what happened was...' + request.env['sinatra.error'].message
#end

get '/' do
  if params[:q] 
    redirect '/' + params[:q].strip
  else
    haml ""
  end
end

get '/:word' do
  @word= params[:word]
  q=URI.escape(@word,Regexp.new("[^#{URI::PATTERN::UNRESERVED}]")) # escape url
  
  # analyze google
  urlGoogle='http://www.google.ru/search?q=' + q +'&ie=utf-8&oe=utf-8' # combine full url
  # debugger
  begin 
    correctGoogleWord = ""
    rGoogle = Nokogiri::HTML(open(urlGoogle), nil, 'UTF-8') # get page
    zGoogle = rGoogle.xpath('/html/body/div[5]/div[3]/p[1]/a/b/i') # parse page
    correctGoogleWord = zGoogle[0].content unless zGoogle[0].nil?
  rescue
    correctGoogleWord = nil
  end
 
  # analyze Yandex
  urlYandex='http://yandex.ru/yandsearch?text=' + q
  begin
    correctYandexWord = ""
    rYandex = Nokogiri::HTML(open(urlYandex), nil, 'UTF-8')
    zYandexMean= rYandex.xpath('/html/body/div[2]/div/div[1]/div[1]/div/div/a') # 'Возможно вы имели ввиду'
    if zYandexMean[0].any?
      correctYandexWord = zYandexMean[0].content
    else
      zYandexNil = rYandex.xpath('/html/body/table/tr[2]/td[4]/div/a[1]')
      correctYandexWord = rYandex.xpath("//input[@name='text']/@value")[0].content unless zYandexNil[0].nil?
    end
  rescue
    correctYandexWord = nil
  end
  @correctWord =  [correctGoogleWord, correctYandexWord].uniq  # combine google and yandex results
 #debugger
  if @correctWord.any?
    @correctWord -= ['', nil]
    if @correctWord.empty?
      haml :right
    else
      haml :notright
    end
  else
    raise  503
  end
end



