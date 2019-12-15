# ファイルをHexダンプしてみる

if ARGV.length != 1 then
    puts "usage : ruby dump.rb filename"
    exit
end

File.open(ARGV[0], "rb"){|io|
    sampn = io.read()              
    m = sampn.unpack("C*") 

    puts ""
    puts "+0 +1 +2 +3 +4 +5 +6 +7 +8 +9 +A +B +C +D +E +F  ## ASCII CHAR ##"
    puts "-----------------------------------------------------------------"

    m.each_slice(16){|line|
        ascii_str = ""
        line.each{|c|
            printf "%02X ",c
            if c >= 0x20 and c <= 0x7E
                ascii_str << c
            else
                ascii_str << " "
            end
        }
        (16 - ascii_str.length).times{print "   "} if ascii_str.length < 16
        puts " " + ascii_str
    }

    puts ""
}
