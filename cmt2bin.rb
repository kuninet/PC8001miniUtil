# PC-8001機械語のCMT形式ファイルをバイナリ形式ファイルへ
require 'bindata'

class Header < BinData::Record
    endian  :little
    uint8   :id       
    uint16  :addr
    uint8   :checksum
end

class MainData < BinData::Record
    class DataRecord < BinData::Record
        endian  :little
        uint8   :id      
        uint8   :len
        array   :body, :type => :uint8, :initial_length => :len
        uint8   :checksum
    end
    array   :cmt_data, :type => DataRecord, :read_until => :eof
end


if ARGV.length != 2 then
    puts "usage : ruby cmt2bin.rb cmt_filename bin_filename"
    exit
end

File.open(ARGV[0], "rb"){|infile|
    head_data = Header.read(infile.read(4))
    if head_data.id != 0x3A
        puts "!! error : NOT CMT FORMAT FILE !!"
        exit
    end

    puts "START ADDRESS : " + head_data["addr"].to_i.to_s(16)

    main_data = MainData.read(infile.read())
    File.open(ARGV[1], "wb"){|outfile|
        main_data["cmt_data"].each{|data|
            data["body"].each{|c|
                wdata=[]
                wdata[0]=c
                outfile.write(wdata.pack("C")) 
            }
        }
    }
}

