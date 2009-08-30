namespace :extractor do
  desc "Extract LACMA Current Exhibitions"
  task :lacma => :environment do
    agent = WWW::Mechanize.new
    page = agent.get('http://www.lacma.org/art/ExhibCurrent.aspx')
    page.root.xpath("//td[@class='contentcolumn' and position()=2]/table/tbody/tr/td/table/tbody/tr[*]/td[2]/a").each do |link|
      exhibition = Exhibition.new
      exhibition[:url] = link['href']
      exhibition[:title] = link.text

      datepage  = agent.click link
      datepage.root.xpath("//table//tr/td[1]/p/span/span[@class='BODY_criticsChoice_creditName']").each do |date|
        date, foo = date.text.split(" | ")
        date_open, date_close = date.split("â")
        exhibition[:date_open] = Date.parse(date_open)
        exhibition[:date_close] = Date.parse(date_close)
      end
      datepage.root.xpath("//table//tr/td[1]/p/span[@class='BODY_criticsChoice_creditName']").each do |date|
        date, foo = date.text.split(" | ")
        date_open, date_close = date.split("â")
        exhibition[:date_open] = Date.parse(date_open)
        exhibition[:date_close] = Date.parse(date_close)
      end
      exhibition[:museum_id] = "1"
      exhibition.save
    end
  end
  
  desc "Extract Hammer Current Exhibitions"
  task :hammer => :environment do
    agent = WWW::Mechanize.new
    page = agent.get('http://hammer.ucla.edu/exhibitions/exhibitions')
    page.root.xpath("//ul[@id='current-exhibitions']/li[*]/dl/dd[*]/a").each do |link|
      exhibition = Exhibition.new
      exhibition[:url] = "http://hammer.ucla.edu" + link['href']
      exhibition[:title] = link.text

      detailspage = agent.click link
      detailspage.root.xpath("//div[1]/div[2]/div[2]/div[2]/h3").each do |date|
        date_open, date_close = date.text.split(" - ")
        exhibition[:date_open] = Date.parse(date_open)
        exhibition[:date_close] = Date.parse(date_close)
      end
      exhibition[:museum_id] = "2"
      exhibition.save
    end
  end

  task :ocma => :environment do
    agent = WWW::Mechanize.new
    page = agent.get('http://www.ocma.net/index.html?page=current')
    page.root.xpath("//tr/td/p/a[@class='ex_link']").each_with_index do |title, i|
      exhibition = Exhibition.new
      exhibition[:title]  = title.text
      exhibition[:url] = "http://www.ocma.net/#{title['href']}"
      date_open, date_close = title.xpath("//tr[1]/td[#{i + 1}]/p/span[3]").text.split(" - ")
      exhibition[:date_open] = Date.parse(date_open)
      exhibition[:date_close] = Date.parse(date_close)
      exhibition[:museum_id] = "5"
      exhibition.save
    end
    # for 1.8: Date.strptime('May 3, 09', "%b %d, %C"). Not needed in 1.9
  end

  task :nortonSimon => :environment do
    agent = WWW::Mechanize.new
    page = agent.get('http://www.nortonsimon.org/exhibitions.aspx?id=6')
    page.root.xpath("//div[@class='ExhibitionSummary']").each_with_index do |event, i|
      exhibition = Exhibition.new
      event.xpath("//div[@class='ExhibitionSummary' and position()=#{i + 1}]/a[2]").each do |text|
        exhibition[:url] = "http://www.nortonsimon.org/exhibitions.aspx?id=6#{text['href']}"
      end
      exhibition[:title]  = event.xpath("//div[@class='ExhibitionSummary' and position()=#{i + 1}]/a[2]").text
      date_open, date_close = event.xpath("//div[@class='ExhibitionSummary' and position()=#{i + 1}]/div[@class='Dates']").text.split("\xE2\x80\x93")
      exhibition[:date_open] = Date.parse(date_open)
      exhibition[:date_close] = Date.parse(date_close)
      exhibition[:museum_id] = "3"
      exhibition.save
    end
  end
  
  task :skirball => :environment do
    agent = WWW::Mechanize.new
    page = agent.get('http://www.skirball.org/index.php?option=com_ccevents&scope=exbt&task=summary&ccmenu=d2hhdcdzig9u')
    page.root.xpath("//div[1]/table//tr/td/h4/a").each do |event|
      exhibition = Exhibition.new
      exhibition[:title] = event.text
      exhibition[:url] = "http://www.skirball.org/#{event['href']}"
      detailspage = agent.click event
      detailspage.root.xpath("//div[@class='event']/div[@class='event_info' and position()=2]/div[@class='time' and position()=1]/p").each do |date|
        date_open, date_close = date.text.gsub(/\s+/, ' ').split(" through ")
        if date_open == "Ongoing ":  date_open = nil  end
        if date_open != nil:  date_open = Date.parse(date_open)  end
        if date_close != nil:  date_close = Date.parse(date_close)  end
        exhibition[:date_open] = date_open
        exhibition[:date_close] = date_close
      end
      exhibition[:museum_id] = "4"
      exhibition.save
    end
  end
  
  task :cafam => :environment do
    agent = WWW::Mechanize.new
    page = agent.get('http://www.cafam.org/exhibitions.html')
    page.root.xpath("//span[@class='style30']/a[1]").each do |event|
      exhibition = Exhibition.new
      exhibition[:title] = event.text.split(/\s+/).each{ |word| word.capitalize! }.join(' ')
      exhibition[:url] = "http://www.cafam.org/#{event['href']}"
      detailspage = agent.click event
      detailspage.root.xpath("//table//tr/td[1]/p[1]/span[@class='body']").each do |date|
        date_open, date_close = date.text.gsub(/(\s\s).*/, '\1').gsub(/\s+/, ' ').split(" ")
        exhibition[:date_open] = Date.parse(date_open)
        exhibition[:date_close] = Date.parse(date_close)
      end
      exhibition[:museum_id] = "6"
      exhibition.save
    end
  end

  task :gettyCenter => :environment do
    extractorgettycenter = Scrubyt::Extractor.define do
      fetch          'http://www.getty.edu/museum/exhibitions'

        title "//td[1]/div/table[2]//tr/td//p/a[1]"
    end
    data_hash = extractorgettycenter.to_hash
  end
      
  task :fowler => :environment do
    extractor = Scrubyt::Extractor.define do
      fetch          'http://www.fowler.ucla.edu/incEngine/?content=cm&cm=exhibitions'

      exhibition  "//blockquote/table//tr/td/table//tr[1]/td[2]", :generalize => false do
        title "/strong"
      end
    end
  end
  
  task :all => [:lacma, :hammer, :ocma, :nortonSimon, :skirball, :cafam]
  
  task :mecha => :environment do
  end
end