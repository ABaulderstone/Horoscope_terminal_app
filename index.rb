require "httparty"
require "json"
require "zodiac"
require "date"
require "artii"





def validate_birthday(dob)
    !!dob[/\d{2}\/\d{2}\/\d{4}/]
end

def wait_clear
    puts "."
    sleep(1)
    puts "."
    sleep(1)
    puts "."
    sleep(1)
    system "clear"
end

class HoroscopeModel
    
    attr_accessor  :name , :sign
    def initialize(name = "default", sign = Date.today.zodiac_sign)
        @name = name
        @sign = sign
    end
    
    def get_horoscope (sign)
        response = HTTParty.get "http://horoscope-api.herokuapp.com/horoscope/today/#{sign}"
        reading = response.body
        hash = JSON.parse reading
        puts hash["horoscope"]
    end



end

class HoroscopeView
    attr_reader :art
    def initialize
        @art = Artii::Base.new
       
    end
    def greeting
        puts @art.asciify("Daily Horoscope")
    end
    
    def get_name
        puts "Enter your name:"
        name= gets.chomp.capitalize
    end 
    
    def get_sign
        puts "Enter your sign:"
        sign = gets.chomp.capitalize
    end 

    def dont_know
        system "clear"
        puts "It looks like you don't know your star sign. That's okay we can figure it out"
    end
    
    def get_birthday
        puts "Please enter your birthday dd/mm/yyy:"
        dob = gets.chomp
        until validate_birthday (dob)
        puts "Please enter your birthday dd/mm/yyy:"
        dob = gets.chomp
        end
        dob
    end

    def repeat_name(name)
        puts "Hi #{name}, fetching your horoscope for #{Date.today}"
        wait_clear
    end



end

class HoroscopeController
    def initialize
        @horoscopeView = HoroscopeView.new
        @horoscopeModel = HoroscopeModel.new 
        @signs_array = [ "Aries", "Taurus", "Gemini", "Cancer", "Leo", "Virgo", "Libra", "Scorpio", "Sagittarius", "Capricorn", "Aquarius", "Pisces"]  
    end
    
    def birthday_to_sign
       birthday = @horoscopeView.get_birthday
       birthday = birthday.split("/")
       birthday.map!(&:to_i)
       sign = Date.new(birthday[-1], birthday[-2], birthday[-3]).zodiac_sign
       end


    
    def run 
        @horoscopeView.greeting
        @horoscopeModel.name = @horoscopeView.get_name
        sign = @horoscopeView.get_sign
        @horoscopeView.repeat_name(@horoscopeModel.name)
        if @signs_array.include? sign
            puts @horoscopeView.art.asciify(sign)
           @horoscopeModel.get_horoscope sign
        else 
            @horoscopeView.dont_know
            sign = self.birthday_to_sign
            wait_clear
            puts "You're a:"
            puts @horoscopeView.art.asciify(sign)
            @horoscopeModel.get_horoscope sign
        end

    end

end


test = HoroscopeController.new
 test.run
 
