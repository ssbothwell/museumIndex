class MuseumsController < ApplicationController
  before_filter [:ExtractorLacma, :ExtractorHammer, :ExtractorOCMA, :ExtractorNortonSimon, :extractorGettyCenter, :extractorSkirball],
    :only => [:index]
    

  # GET /museums
  # GET /museums.xml
  def index
    @museums = Museum.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @museums }
    end
  end

  # GET /museums/1
  # GET /museums/1.xml
  def show
    @museum = Museum.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @museum }
    end
  end

  # GET /museums/new
  # GET /museums/new.xml
  def new
    @museum = Museum.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @museum }
    end
  end

  # GET /museums/1/edit
  def edit
    @museum = Museum.find(params[:id])
  end

  # POST /museums
  # POST /museums.xml
  def create
    @museum = Museum.new(params[:museum])

    respond_to do |format|
      if @museum.save
        flash[:notice] = 'Museum was successfully created.'
        format.html { redirect_to(@museum) }
        format.xml  { render :xml => @museum, :status => :created, :location => @museum }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @museum.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /museums/1
  # PUT /museums/1.xml
  def update
    @museum = Museum.find(params[:id])

    respond_to do |format|
      if @museum.update_attributes(params[:museum])
        flash[:notice] = 'Museum was successfully updated.'
        format.html { redirect_to(@museum) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @museum.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /museums/1
  # DELETE /museums/1.xml
  def destroy
    @museum = Museum.find(params[:id])
    @museum.destroy

    respond_to do |format|
      format.html { redirect_to(museums_url) }
      format.xml  { head :ok }
    end
  end
  
  private
  
  def ExtractorLacma
    @ExtractorLacma = Scrubyt::Extractor.define do
      fetch          'http://www.lacma.org/art/ExhibCurrent.aspx'
      
      link_title "//td[@class='contentcolumn' and position()=2]/table/tbody/tr/td/table/tbody/tr[*]/td[2]/a[1]", :write_text => true do
        url 'href', :type => :attribute
        end
      end
      @LACMA = @ExtractorLacma.to_hash
  end
  
  def ExtractorHammer
    @ExtractorHammer = Scrubyt::Extractor.define do
      fetch          'http://hammer.ucla.edu/exhibitions/exhibitions'

        link_title "//ul[@id='current-exhibitions']/li[*]/dl/dd[*]/a[*]", :write_text => true do
          url "href", :type => :attribute
        end
      end
    @Hammer = @ExtractorHammer.to_hash
    @Hammer.each do |l|
      l[:url] = "http://hammer.ucla.edu/" + l[:url]
    end
  end
  
  def ExtractorOCMA 
    @ExtractorOCMA = Scrubyt::Extractor.define do
    fetch          'http://www.ocma.net/index.html?page=current'

      link_title "//td/p/a", :write_text => true do
        url "href", :type => :attribute
      end
    end
    @OCMA = @ExtractorOCMA.to_hash
    @OCMA.each do |l|
      l[:url] = "http://www.ocma.net/" + l[:url]
    end
  end

  def ExtractorNortonSimon
    @ExtractorNortonSimon = Scrubyt::Extractor.define do
      fetch          'http://www.nortonsimon.org/exhibitions.aspx?id=6'

        link_title "//div[@id='maincol']/div/a[2]", :write_text => true do
          url "href", :type => :attribute
        end
    end
    @NortonSimon = @ExtractorNortonSimon.to_hash
    @NortonSimon.each do |l|
      l[:url] = "http://www.nortonsimon.org/exhibitions.aspx?id=6" +l[:url]
    end
  end
  
  def extractorGettyCenter
    @ExtractorGettyCenter = Scrubyt::Extractor.define do
      fetch          'http://www.getty.edu/museum/exhibitions'

        link_title "//td[1]/div/table[2]//tr/td//p/a[1]"
    end
    @GettyCenter = @ExtractorGettyCenter.to_hash
  end
  
  def extractorSkirball
    @ExtractorSkirball = Scrubyt::Extractor.define do
      fetch          'http://www.skirball.org/index.php?option=com_ccevents&scope=exbt&task=summary&ccmenu=d2hhdcdzig9u'

        link_title "//div[1]/table//tr/td/h4/a", :write_text => true do
          url "href", :type => :attribute
        end
    end
    @Skirball = @ExtractorSkirball.to_hash
    @Skirball.each do |l|
      l[:url] = "http://www.skirball.org/" + l[:url]
    end
  end
end
