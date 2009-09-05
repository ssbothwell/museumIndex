namespace :extractor do
  desc "Extract LACMA Current Exhibitions"
  task :lacma => :environment do
    museum = Museum.find_by_name("Los Angeles County Museum Of Art")
    agent = WWW::Mechanize.new
    page = agent.get('http://www.lacma.org/art/ExhibCurrent.aspx')
    page.root.xpath("//td[@class='contentcolumn' and position()=2]/table/tbody/tr/td/table/tbody/tr[*]/td[2]/a").each do |link|
      exhibition = museum.exhibitions.new
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
      exhibition.save
    end
  end
  
  desc "Extract Hammer Current Exhibitions"
  task :hammer => :environment do
    museum = Museum.find_by_name("Hammer Museum")
    agent = WWW::Mechanize.new
    page = agent.get('http://hammer.ucla.edu/exhibitions/exhibitions')
    page.root.xpath("//ul[@id='current-exhibitions']/li[*]/dl/dd[*]/a").each do |link|
      exhibition = museum.exhibitions.new
      exhibition[:url] = "http://hammer.ucla.edu" + link['href']
      exhibition[:title] = link.text

      detailspage = agent.click link
      detailspage.root.xpath("//div[1]/div[2]/div[2]/div[2]/h3").each do |date|
        date_open, date_close = date.text.split(" - ")
        exhibition[:date_open] = Date.parse(date_open)
        exhibition[:date_close] = Date.parse(date_close)
      end
      exhibition.save
    end
  end

  task :ocma => :environment do
    museum = Museum.find_by_name("Orange County Museum Of Art")
    agent = WWW::Mechanize.new
    page = agent.get('http://www.ocma.net/index.html?page=current')
    page.root.xpath("//tr/td/p/a[@class='ex_link']").each_with_index do |title, i|
      exhibition = museum.exhibitions.new    
      exhibition[:title]  = title.text
      exhibition[:url] = "http://www.ocma.net/#{title['href']}"
      date_open, date_close = title.xpath("//tr[1]/td[#{i + 1}]/p/span[3]").text.split(" - ")
      exhibition[:date_open] = Date.parse(date_open)
      exhibition[:date_close] = Date.parse(date_close)
      exhibition.save
    end
    # for 1.8: Date.strptime('May 3, 09', "%b %d, %C"). Not needed in 1.9
  end

  task :nortonSimon => :environment do
    museum = Museum.find_by_name("Norton Simon Museum")
    agent = WWW::Mechanize.new
    page = agent.get('http://www.nortonsimon.org/exhibitions.aspx?id=6')
    page.root.xpath("//div[@class='ExhibitionSummary']").each_with_index do |event, i|
      exhibition = museum.exhibitions.new    
      event.xpath("//div[@class='ExhibitionSummary' and position()=#{i + 1}]/a[2]").each do |text|
        exhibition[:url] = "http://www.nortonsimon.org/exhibitions.aspx?id=6#{text['href']}"
      end
      exhibition[:title]  = event.xpath("//div[@class='ExhibitionSummary' and position()=#{i + 1}]/a[2]").text
      date_open, date_close = event.xpath("//div[@class='ExhibitionSummary' and position()=#{i + 1}]/div[@class='Dates']").text.split("\xE2\x80\x93")
      exhibition[:date_open] = Date.parse(date_open)
      exhibition[:date_close] = Date.parse(date_close)
      exhibition.save
    end
  end
  
  task :skirball => :environment do
    museum = Museum.find_by_name("Skirball Cultural Center")
    agent = WWW::Mechanize.new
    page = agent.get('http://www.skirball.org/index.php?option=com_ccevents&scope=exbt&task=summary&ccmenu=d2hhdcdzig9u')
    page.root.xpath("//div[1]/table//tr/td/h4/a").each do |event|
      exhibition = museum.exhibitions.new    
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
      exhibition.save
    end
  end
  
  task :cafam => :environment do
    museum = Museum.find_by_name("Craft And Folk Art Museum Los Angeles")
    agent = WWW::Mechanize.new
    page = agent.get('http://www.cafam.org/exhibitions.html')
    page.root.xpath("//span[@class='style30']/a[1]").each do |event|
      exhibition = museum.exhibitions.new    
      exhibition[:title] = event.text.split(/\s+/).each{ |word| word.capitalize! }.join(' ')
      exhibition[:url] = "http://www.cafam.org/#{event['href']}"
      detailspage = agent.click event
      detailspage.root.xpath("//table//tr/td[1]/p[1]/span[@class='body']").each do |date|
        date_open, date_close = date.text.gsub(/(\s\s).*/, '\1').gsub(/\s+/, ' ').split(" ")
        exhibition[:date_open] = Date.parse(date_open)
        exhibition[:date_close] = Date.parse(date_close)
      end
      exhibition.save
    end
  end

  task :gettycenter => :environment do
    museum = Museum.find_by_name("Getty Center Los Angeles")
    agent = WWW::Mechanize.new
    page = agent.get('http://www.getty.edu/museum/exhibitions')
    i = 0
    page.root.xpath("//table//tr[1]/td[1]/div/table[2]//tr/td[2]/p/a").each do |event|
      exhibition = museum.exhibitions.new
      exhibition[:title]  =  event.text
      exhibition[:url] = "http://www.getty.edu#{event['href']}"
      i = i + 2 
      date_open, date_close = event.xpath("//table//tr[1]/td[1]/div/table[2]//tr[#{i}]/td[2]/p").text.gsub(event.text,'').split("–")
      if date_open == "Ongoing":  date_open = nil  end
      if date_close == "Ongoing":  date_close = nil  end
      if date_open != nil:  date_open = Date.parse(date_open)  end
      if date_close != nil:  date_close = Date.parse(date_close)  end
      exhibition[:date_open] = date_open
      exhibition[:date_close] = date_close
      exhibition.save
    end
  end
  
  task :molaa => :environment do
    museum = Museum.find_by_name("Museum Of Latin American Art")
    exhibition = museum.exhibitions.new
    agent = WWW::Mechanize.new
    page = agent.get('http://www.molaa.org/Art/exhibitions.aspx')
    page.root.xpath("//div[@class='infoModule']/p/b/a").each do |event|
      exhibition = museum.exhibitions.new
      exhibition[:title] = event.text
      exhibition[:url] = "http://www.molaa.org#{event['href']}"
      detailspage = agent.click event
        detailspage.root.xpath("//div[3]/div[3]/h2").each do |date|
          if date.text.downcase.include? "permanent": date = nil else date = date.text end 
          if date != nil: 
            date_open, date_close = date.split(" – ") 
            exhibition[:date_open] = Date.parse(date_open)
            exhibition[:date_close] = Date.parse(date_close)
          end
        end
        exhibition.save
    end
  end
  
  task :janm => :environment do
    museum = Museum.find_by_name("Japanese American National Museum")
    agent = WWW::Mechanize.new
    page = agent.get('http://www.janm.org/exhibits/')

    page.root.xpath("//div[@class='exhibition']/p[1]/strong//a").each do |event|
      exhibition = museum.exhibitions.new
      exhibition[:title] = event.text
      exhibition[:url] = "http://www.janm.org#{event['href']}"
      date_open, date_close = event.xpath("//div[@class='exhibition' and position()=1]/p[1]/em").text.split(" - ")
      exhibition[:date_open] = Date.parse(date_open)
      exhibition[:date_close] = Date.parse(date_close)
      exhibition.save
    end
  end
  
  task :bowers => :environment do
    museum = Museum.find_by_name("Bowers Museum")
    agent = WWW::Mechanize.new
    page = agent.get('http://www.bowers.org/explore/exhibitions.jsp')
    
    page.root.xpath("//table[@class='exhTBL' and position()=1]//tr[3]/td[@class='exhTDArt' and position()=2]/p[1]/span[@class='red14B']").each do |event|
      exhibition = museum.exhibitions.new
      exhibition[:title] = event.text
      exhibition[:url] = "http://www.bowers.org/explore/exhibitions.jsp"

      date_open, date_close = event.xpath("//table[@class='exhTBL' and position()=1]//tr[3]/td[@class='exhTDArt' and position()=2]/p[1]/strong").text.split(" – ")
      if date_open == "ongoing": date_open = nil else date_open = Date.parse(date_open) end
      if date_close == "ongoing": date_close = nil else date_close = Date.parse(date_close) end
      exhibition[:date_open] =  date_open
      exhibition[:date_close] = date_close
      exhibition.save
    end

    page = agent.get('http://www.bowers.org/explore/upcomingExhibitions.jsp')
    i = 1
    page.root.xpath("//table[@class='exhTBL']//tr/td[@class='exhTDArt' and position()=2]/p[1]/span[@class='red14B' and position()=1]").each do |event|
      exhibition = museum.exhibitions.new
      exhibition[:title] = event.text
      exhibition[:url] = "http://www.bowers.org/explore/exhibitions.jsp"
      puts event.text
      date_open, date_close = event.xpath("//table[@class='exhTBL']//tr[#{i}]/td[@class='exhTDArt' and position()=2]/p[1]/span[@class='spon12B' and position()=2]").text.split(" - ")
      i = i + 2
      if date_open == "ongoing": date_open = nil else date_open = Date.parse(date_open) end
      if date_close == "ongoing": date_close = nil else date_close = Date.parse(date_close) end
      exhibition[:date_open] = date_open
      exhibition[:date_close] = date_close
      exhibition[:museum_id] = "10"
      exhibition.save
    end
  end
  
  task :fowler => :environment do
    museum = Museum.find_by_name("Fowler Museum")
    exhibition = museum.exhibitions.new    
    agent = WWW::Mechanize.new
    page = agent.get('http://www.fowler.ucla.edu/incEngine/?content=cm&cm=exhibitions')
    page.root.xpath("//blockquote/table//tr/td/table//tr[1]/td[2]/strong").each do |event|
      puts event.text
    #  foo, bar = event.xpath("//blockquote/table//tr/td/table//tr[1]/td[2]").text.split(event.text)
    #  puts bar
    end
  end
  
  task :wildling => :environment do
    museum = Museum.find_by_name("Wildling Art Museum")
    exhibition = museum.exhibitions.new
    agent = WWW::Mechanize.new
    page = agent.get('http://wildlingmuseum.org/exhibitionCur.html')
    page.root.xpath("//div[@class='scroll' and position()=3]/p/strong[1]").each do |event|
      exhibition = Exhibition.new
      exhibition[:title] = event.text.gsub(/\s+/, ' ')
      exhibition[:url] = "http://wildlingmuseum.org/exhibitionCur.html"
      date_open, date_close = event.xpath("//div[@class='scroll' and position()=3]/p/strong[2]").text.split(" through ")
      exhibition[:date_open] = Date.parse(date_open)
      exhibition[:date_close] = Date.parse(date_close)
      exhibition[:museum_id] = "69"
      exhibition.save
    end
  end
  
  task :all => [:lacma, :hammer, :ocma, :nortonSimon, :skirball, :cafam, :gettycenter, :molaa, :janm, :bowers]
  
end