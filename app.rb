require 'CSV'

class PhobiaApp < Sinatra::Base
  set :haml, :format => :html5 

  configure do
    set :daily_phobia, { phobia: nil, phobia_descr: nil, crt: nil } 
    set :phobia_list, CSV.open('phobia_list.txt', 'r', col_sep: "\t").to_a.drop(1)  
  end

  def load_phobias
    print "\nLoading phobia file...\n"
    csv = CSV.open('phobia_list.txt', 'r', col_sep: "\t")
    return csv.to_a.drop(1)
  end

  def new_daily_phobia
    rand_phobia = settings.phobia_list.sample;
    phobia_name = rand_phobia[0].split
    phobia_name[0].sub(/-/, "")
    settings.daily_phobia["phobia"] = phobia_name.first 
    settings.daily_phobia["phobia_descr"] = rand_phobia[1]
    settings.daily_phobia["crt"] = Time.now
    print "NEW PHOBIA!!\n"
  end
  
  before do
    headers "Content-Type" => "text/html; charset=uft-8"
  end

  get '/' do
    haml :home
  end

  get '/daily' do 
    curr_time = Time.now
    beginning_day = Time.utc(curr_time.year, curr_time.month,  curr_time.day, 0, 0)
    ending_day = Time.utc(curr_time.year, curr_time.month,  curr_time.day, 23, 59) 
    time_range = beginning_day..ending_day

    #check for first run
    if(settings.daily_phobia["phobia"] == nil) 
      print "first run\n"
      new_daily_phobia()
    end


    #get new phobia if the last phobia's timestamp is outside today's range
    print  
    if (time_range.cover?(settings.daily_phobia["crt"]) == false)
      print "change date....\n"
      new_daily_phobia()
    end

    haml :daily_phobia, :locals => {:daily_phobia => settings.daily_phobia}
    

  end

end
