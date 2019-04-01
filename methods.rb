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