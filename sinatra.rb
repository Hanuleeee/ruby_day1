require 'sinatra'
require 'sinatra/reloader'
require 'httparty'
require 'nokogiri'
require 'json'

get '/menu' do
    'Hello World'
    #점심에는 ?을 먹고 저녁에는 ?을 드세요
    #조건: sample 함수는 1번만 사용 가능
    menu = ["20층", "김밥카페", "서브웨이", "편의점", "양자강","시골집"]
    new = menu.sample(2)
    
    "점심에는 "+ new[0] + "을 먹고 저녁에는 "+new[1]+"을 드세요"
end

get '/lotto' do
    #num = (1..45).to_a
    num = *(1..45)
    lotto = num.sample(6).sort
    "이번주 추천로또 숫자는 " + lotto.to_s + " 입니다."
end


get '/check_lotto' do
    url= "http://m.nlotto.co.kr/common.do?method=getLottoNumber&drwNo=809"
    lotto = HTTParty.get(url)
    result = JSON.parse(lotto)
    numbers = []
    bonus = result["bnusNo"]
    result.each do |k,v|
        if k.include?("drwtNo")
            numbers << v
        end
    end
    
    my_numbers = *(1..45)
    my_lotto = my_numbers.sample(6).sort
    
    count = 0
    numbers.each do |num|
        count += 1 if my_lotto.include?(num)
    end
    puts "당첨 개수는 "+ count.to_s
    
    count_bs = 0
    count_bs = 1 if my_lotto.include?(bonus)
    
    if count == 6
        "축하합니다! " + count + "개 맞추셨습니다. 1등 입니다."
    elsif count == 5 && count_bs ==1
        "축하합니다! 2등 입니다."
    elsif count ==5 && count_bs !=1
        "축하합니다! " + count + "개 맞추셨습니다. 3등 입니다."
    elsif count == 4
        "축하합니다! " + count + "개 맞추셨습니다. 4등 입니다."
    elsif count ==3
        "축하합니다! " + count + "개 맞추셨습니다. 5등 입니다."
    else
        "Oh! 당첨되지 않았습니다."
    end
    
end



get '/kospi' do
    response = HTTParty.get("http://finance.daum.net/quote/kospi.daum?nil_stock=refresh")
    kospi = Nokogiri::HTML(response)

    result = kospi.css("#hyenCost > b")
    "현재 코스피 지수는 " + result.text + "입니다."
end

get '/html' do
    "<html>
        <head></head>
        <body>
            <h1>안녕하세요?</h1>
        </body>
    </html>"
end

get '/html_file' do
    @name = params[:name]  # 사용자에게 돌려주기위해서 @
    name = "Hoho" # @name과 완전히 다른 변수
    erb :my_first_html  # my_fisrt)html에다가 사용자지정변수 입력
end


get '/calculate' do
   num1 = params[:num1].to_i
   num2 = params[:num2].to_i
   
   @sum = num1 + num2 
   @mul = num1 * num2
   @sub = num1 - num2
   @div = num1 / num2
   erb :my_calculate
   
end