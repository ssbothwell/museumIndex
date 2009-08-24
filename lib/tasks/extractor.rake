namespace :extractor do
  desc "Extract LACMA Current Exhibitions"
  task :lacma => :environment do
    ExtractorLACMA = Scrubyt::Extractor.define do
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

    DataHash = ExtractorLACMA.to_hash
    DataHash.each do |l|
      l[:date], foo = l[:date].split(" | ") 
      l[:museum_id] = "1"
    end
  
    DataHash.each do |l|
      @exhibition = Exhibition.create(l)
      @exhibition.save
    end
  end
  
  desc "Extract Hammer Current Exhibitions"
  task :hammer => :environment do
    ExtractorHammer = Scrubyt::Extractor.define do
      fetch          'http://hammer.ucla.edu/exhibitions/exhibitions'

      exhibition "//ul[@id='current-exhibitions']/li[*]/dl/dd[*]/a[*]", :generalize => false do
        url "href", :type => :attribute
        exhibition_details do
          title "//div[1]/div[2]/div[2]/div[2]/h1"
          date "//div[1]/div[2]/div[2]/div[2]/h3"
        end
      end
    end
    
    DataHash = ExtractorHammer.to_hash
    DataHash.each do |l|
      l[:url] = "http://hammer.ucla.edu/" + l[:url]
      l[:museum_id] = "2"
    end
    
    DataHash.each do |l|
      @exhibition = Exhibition.create(l)
      @exhibition.save
    end
  end

  task :ocma => :environment do
    ExtractorOCMA = Scrubyt::Extractor.define do
      fetch          'http://www.ocma.net/index.html?page=current'

        exhibition "//table[3]//tr/td[4]/table[1]//tr/td", :generalize => false do
          title "//p/a[@class='ex_link']"
          date "//p/span[3]"
        end
    end
    
    DataHash = ExtractorOCMA.to_hash
    DataHash.each do |l|
      l[:url] = "http://www.ocma.net/index.html?page=current"
      l[:museum_id] = "5"
    end
    
    DataHash.each do |l|
      @exhibition = Exhibition.create(l)
      @exhibition.save
    end
  end

  task :nortonSimon => :environment do
    ExtractorNortonSimon = Scrubyt::Extractor.define do
      fetch          'http://www.nortonsimon.org/exhibitions.aspx?id=6'

        exhibition "//div[@class='ExhibitionSummary']" do
          title "//a[2]"
          date "//div[@class='Dates']"
        end
    end
    
    DataHash = ExtractorNortonSimon.to_hash
    DataHash.each do |l|
      l[:url] = "http://www.nortonsimon.org/exhibitions.aspx?id=6"
      l[:museum_id] = "3"
    end
    
    DataHash.each do |l|
      @exhibition = Exhibition.create(l)
      @exhibition.save
    end
  end
  
  task :skirball => :environment do
    ExtractorSkirball = Scrubyt::Extractor.define do
      fetch          'http://www.skirball.org/index.php?option=com_ccevents&scope=exbt&task=summary&ccmenu=d2hhdcdzig9u'
      exhibition "//div[1]/table//tr/td/h4/a", :generalize => false do
        url "href", :type => :attribute
        exhibition_details do
          title "//h4[@class='program']"
          date "//div[@class='event']/div[@class='event_info']/div[@class='time']/p[1]"
        end
      end
    end
    DataHash = ExtractorSkirball.to_hash
    DataHash.each do |l|
      l[:url] = "http://www.skirball.org/" + l[:url]
      l[:museum_id] = "4"
    end

    DataHash.each do |l|
      @exhibition = Exhibition.create(l)
      @exhibition.save
    end
  end
  
  task :gettyCenter => :environment do
    ExtractorGettyCenter = Scrubyt::Extractor.define do
      fetch          'http://www.getty.edu/museum/exhibitions'

        title "//td[1]/div/table[2]//tr/td//p/a[1]"
    end
    DataHash = ExtractorGettyCenter.to_hash
  end
  
  task :all => [:lacma, :hammer, :ocma, :nortonSimon, :skirball]

end