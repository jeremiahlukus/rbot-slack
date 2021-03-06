# Stocks
class Stock < SlackRubyBot::Commands::Base
  def self.parse_quote(body)
    require "csv"
    s = CSV.parse(body).first
    symbol = s[0]
    price = s[1]
    date = s[2]
    time = s[3]
    change = s[4]
    changepc = s[5]
    stockname = s[6]

    return nil if s[0] == "MISSING SYMBOLS LIST."
    return nil if s[4] == "N/A"

    "#{stockname} (#{symbol.upcase}): #{price} #{change} #{changepc} last trade #{date} #{time}"
  end

  match(/^!stock($|\s(?<args>.+$))/i) do |client, data, match|
    body = open("http://finance.yahoo.com/d/quotes.csv?f=sl1d1t1c1p2n&s=#{match[:args]}").read
    #symbol,price,date,time,change,pct,name
    #"GOOG", "820.34", "3/14/2013", "1:02pm", "-4.97", "-0.60%", "Google Inc."] 
    if (quote = parse_quote(body))
      out = quote
    else
      out = "Error parsing quote for #{$args}"
    end
    client.message text: out, channel: data.channel
  end
end
