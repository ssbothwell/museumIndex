namespace :extractor do
  desc "Extract LACMA Current Exhibitions"
  task :lacma => :environment do
    extractorlacma = Scrubyt::Extractor.define do
      fetch          'http://www.lacma.org/art/ExhibCurrent.aspx'

      exhibition "//td[@class='contentcolumn' and position()=2]/table/tbody/tr/td/table/tbody/tr[*]/td[2]/a[1]", :generalize => false do
        url 'href', :type => :attribute
        exhibition_details do
          title "//table//tr/td[1]/p[2]/span[@class='BODY_exhTitle']"
          title "//table[2]//tr/td[1]/p[3]/span[@class='BODY_exhTitle']"
          title "//table[2]//tr/td[1]/p[3]/span/span[@class='BODY_exhTitle']"
          date "//table//tr/td[1]/p/span/span[@class='BODY_criticsChoice_creditName']"
          date "//table//tr/td[1]/p/span[@class='BODY_criticsChoice_creditName']"
        end
      end
    end

    data_hash = extractorlacma.to_hash
    data_hash.each do |site_data|
      # Cleanup dates
      site_data[:date], foo = site_data[:date].split(" | ")
      site_data[:date_open], site_data[:date_close] = site_data[:date].split("\xE2\x80\x93")
      site_data.delete(:date)
      site_data[:date_open] = Date.parse(site_data[:date_open])
      site_data[:date_close] = Date.parse(site_data[:date_close])      
      site_data[:museum_id] = "1"
    end
  
    data_hash.each do |site_data|
      exhibition = Exhibition.create(site_data)
      exhibition.save
    end
  end
  
  desc "Extract Hammer Current Exhibitions"
  task :hammer => :environment do
    extractorhammer = Scrubyt::Extractor.define do
      fetch          'http://hammer.ucla.edu/exhibitions/exhibitions'

      exhibition "//ul[@id='current-exhibitions']/li[*]/dl/dd[*]/a[*]", :generalize => false do
        url "href", :type => :attribute
        exhibition_details do
          title "//div[1]/div[2]/div[2]/div[2]/h1"
          date "//div[1]/div[2]/div[2]/div[2]/h3"
        end
      end
    end
    
    data_hash = extractorhammer.to_hash
    data_hash.each do |site_data|
      # Cleanup dates
      site_data[:url] = "http://hammer.ucla.edu/" + site_data[:url]
      site_data[:date_open], site_data[:date_close] = site_data[:date].split(" - ")
      site_data.delete(:date)
      site_data[:date_open] = Date.parse(site_data[:date_open])
      site_data[:date_close] = Date.parse(site_data[:date_close])
      site_data[:museum_id] = "2"
    end
    
    data_hash.each do |site_data|
      exhibition = Exhibition.create(site_data)
      exhibition.save
    end
  end

  task :ocma => :environment do
    extractorocma = Scrubyt::Extractor.define do
      fetch          'http://www.ocma.net/index.html?page=current'

        exhibition "//table[3]//tr/td[4]/table[1]//tr/td", :generalize => false do
          title "//p/a[@class='ex_link']"
          date "//p/span[3]"
        end
    end
    
    data_hash = extractorocma.to_hash
    data_hash.each do |site_data|
      # Cleanup dates
      site_data[:url] = "http://www.ocma.net/index.html?page=current"
      site_data[:date_open], site_data[:date_close] = site_data[:date].split(" - ")
      site_data.delete(:date)
      site_data[:date_open] = Date.parse(site_data[:date_open])
      site_data[:date_close] = Date.parse(site_data[:date_close])
      site_data[:museum_id] = "5"
    end
    
    data_hash.each do |site_data|
      exhibition = Exhibition.create(site_data)
  
      exhibition.save
    end
  end

  task :nortonSimon => :environment do
    extractornortonsimon = Scrubyt::Extractor.define do
      fetch          'http://www.nortonsimon.org/exhibitions.aspx?id=6'

        exhibition "//div[@class='ExhibitionSummary']" do
          title "//a[2]"
          date "//div[@class='Dates']"
        end
    end
    
    data_hash = extractornortonsimon.to_hash
    data_hash.each do |site_data|
      # Cleanup dates
      site_data[:url] = "http://www.nortonsimon.org/exhibitions.aspx?id=6"
      site_data[:date_open], site_data[:date_close] = site_data[:date].split("\xE2\x80\x93")
      site_data.delete(:date)
      site_data[:date_open] = Date.parse(site_data[:date_open])
      site_data[:date_close] = Date.parse(site_data[:date_close])
      site_data[:museum_id] = "3"
    end
    
    data_hash.each do |site_data|
      exhibition = Exhibition.create(site_data)
      exhibition.save
    end
  end
  
  task :skirball => :environment do
    extractorskirball = Scrubyt::Extractor.define do
      fetch          'http://www.skirball.org/index.php?option=com_ccevents&scope=exbt&task=summary&ccmenu=d2hhdcdzig9u'
      exhibition "//div[1]/table//tr/td/h4/a", :generalize => false do
        url "href", :type => :attribute
        exhibition_details do
          title "//h4[@class='program']"
          date "//div[@class='event']/div[@class='event_info']/div[@class='time']/p[1]"
        end
      end
    end
    data_hash = extractorskirball.to_hash
    data_hash.each do |site_data|
      # Cleanup dates
      site_data[:url] = "http://www.skirball.org/" + site_data[:url]
      site_data[:date_open], site_data[:date_close] = site_data[:date].split(" through ")
      site_data.delete(:date)
      if site_data[:date_open] != "Ongoing"
      site_data[:date_open] = Date.parse(site_data[:date_open])
      site_data[:date_close] = Date.parse(site_data[:date_close])   
      end   
      site_data[:museum_id] = "4"
    end

    data_hash.each do |site_data|
      exhibition = Exhibition.create(site_data)
      exhibition.save
    end
  end
  
  task :cafam => :environment do
    extractorcafam = Scrubyt::Extractor.define do
      fetch          'http://www.cafam.org/exhibitions.html'

      exhibition "//span[@class='style30']/a[1]", :generalize => false do
        url "href", :type => :attribute
        exhibition_details do
          title "//table//tr/td[1]/p[1]/span[@class='head']"
          date "//table//tr/td[1]/p[1]/span[@class='body']"
        end
      end
    end
    
    data_hash = extractorcafam.to_hash
    data_hash.each do |site_data|
      # Cleanup dates
      site_data[:date] = site_data[:date].gsub(/(\s\s).*/, '\1')
      site_data[:date] = site_data[:date].gsub(/\s+/, ' ')
      site_data[:date_open], site_data[:date_close] = site_data[:date].split(" &#150; ")
      site_data.delete(:date)
      site_data[:date_open] = Date.parse(site_data[:date_open])
      site_data[:date_close] = Date.parse(site_data[:date_close])
      # Prepend URL domains
      site_data[:url] = "http://www.cafam.org/" + site_data[:url]
      site_data[:museum_id] = "6"
      

      # Write data to db
      exhibition = Exhibition.create(site_data)
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

end