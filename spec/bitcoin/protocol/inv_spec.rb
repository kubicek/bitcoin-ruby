require_relative '../spec_helper.rb'

describe 'Bitcoin::Protocol::Parser - Inventory Vectors' do

  class Test_Handler < Bitcoin::Protocol::Handler
    attr_reader :tx_inv
    attr_reader :block_inv
    def on_inv_transaction(hash); (@tx_inv ||= []) << hth(hash); end
    def on_get_transaction(hash); (@tx_inv ||= []) << hth(hash); end
    def on_inv_block(hash); (@block_inv ||= []) << hth(hash); end
    def on_get_block(hash); (@block_inv ||= []) << hth(hash); end
  end


  it 'parses inv (transaction)' do
    pkt = [
    "f9 be b4 d9 69 6e 76 00 00 00 00 00 00 00 00 00 49 00 00 00 11 ea 1c 91 02 01 00 00 00 e0 41 c2 38 f7 32 1a 68 0a 34 06 bf fd 72 12 e3 d1 2c b5 12 2a 8c 0b 52 76 de 82 30 b1 00 7a 42 01 00 00 00 33 00 09 71 a9 70 7b 6c 6d 6e 77 aa 2e ac 43 f3 e5 67 84 cb 61 b2 35 fb 8d fe e0 86 8b 40 7c f3"
      .split(" ").join].pack("H*")

    parser = Bitcoin::Protocol::Parser.new( handler = Test_Handler.new )
    parser.parse(pkt + "AAAA").should == "AAAA"

    handler.tx_inv.should == [
      "427a00b13082de76520b8c2a12b52cd1e31272fdbf06340a681a32f738c241e0",
      "f37c408b86e0fe8dfb35b261cb8467e5f343ac2eaa776e6d6c7b70a971090033"
    ]
  end


  it 'parses getdata (transaction)' do
    # 000013C4  f9 be b4 d9 67 65 74 64  61 74 61 00 00 00 00 00 ....getd ata.....
    # 000013D4  25 00 00 00 c5 38 cd bb  01 01 00 00 00 b4 02 2d %....8.. .......-
    # 000013E4  9f e5 28 fb 90 70 50 01  16 4b 0c c3 a8 f5 a1 9c ..(..pP. .K......
    # 000013F4  b8 ed 02 bf d4 fc 2c b6  25 66 d1 9d 6e          ......,. %f..n

    pkt = [
    "f9 be b4 d9 67 65 74 64 61 74 61 00 00 00 00 00 25 00 00 00 c5 38 cd bb 01 01 00 00 00 b4 02 2d 9f e5 28 fb 90 70 50 01 16 4b 0c c3 a8 f5 a1 9c b8 ed 02 bf d4 fc 2c b6 25 66 d1 9d 6e"
      .split(" ").join].pack("H*")

    parser = Bitcoin::Protocol::Parser.new( handler = Test_Handler.new )
    parser.parse(pkt + "AAAA").should == "AAAA"

    handler.tx_inv.should == [
      "6e9dd16625b62cfcd4bf02edb89ca1f5a8c30c4b1601507090fb28e59f2d02b4"
    ]
  end


  it 'parses inv (block)' do
    # 00003C27  f9 be b4 d9 69 6e 76 00  00 00 00 00 00 00 00 00 ....inv. ........
    # 00003C37  25 00 00 00 ae 13 a1 04  01 02 00 00 00 9d b9 c4 %....... ........
    # 00003C47  e2 7c 5b cd 3f 62 e1 af  18 fd 9d 81 6d 6c 6b c7 .|[.?b.. ....mlk.
    # 00003C57  b2 26 0a 39 c5 49 39 00  00 00 00 00 00          .&.9.I9. .....
    pkt = [
    "f9 be b4 d9 69 6e 76 00 00 00 00 00 00 00 00 00 25 00 00 00 ae 13 a1 04 01 02 00 00 00 9d b9 c4 e2 7c 5b cd 3f 62 e1 af 18 fd 9d 81 6d 6c 6b c7 b2 26 0a 39 c5 49 39 00 00 00 00 00 00"
      .split(" ").join].pack("H*")

    parser = Bitcoin::Protocol::Parser.new( handler = Test_Handler.new )
    parser.parse(pkt + "AAAA").should == "AAAA"
    handler.block_inv.should == [
      "0000000000003949c5390a26b2c76b6c6d819dfd18afe1623fcd5b7ce2c4b99d"
    ]
  end


  it 'parses getdata (block)' do
    #   000039E3  f9 be b4 d9 67 65 74 64  61 74 61 00 00 00 00 00 ....getd ata.....
    #   000039F3  25 00 00 00 ae 13 a1 04  01 02 00 00 00 9d b9 c4 %....... ........
    #   00003A03  e2 7c 5b cd 3f 62 e1 af  18 fd 9d 81 6d 6c 6b c7 .|[.?b.. ....mlk.
    #   00003A13  b2 26 0a 39 c5 49 39 00  00 00 00 00 00          .&.9.I9. .....
    pkt = [
    "f9 be b4 d9 67 65 74 64 61 74 61 00 00 00 00 00 25 00 00 00 ae 13 a1 04 01 02 00 00 00 9d b9 c4 e2 7c 5b cd 3f 62 e1 af 18 fd 9d 81 6d 6c 6b c7 b2 26 0a 39 c5 49 39 00 00 00 00 00 00"
      .split(" ").join].pack("H*")

    parser = Bitcoin::Protocol::Parser.new( handler = Test_Handler.new )
    parser.parse(pkt + "AAAA").should == "AAAA"

    handler.block_inv.should == [
      "0000000000003949c5390a26b2c76b6c6d819dfd18afe1623fcd5b7ce2c4b99d"
    ]
  end


end
