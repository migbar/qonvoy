
namespace :restaurants do
  namespace :geocode do
    desc "geocode all the restaurants in the DB"
    task :all => :environment do
      count = 0
      Place.find_each do |place|
        puts "About to geocode #{place.name}"
        sleep 5
        place.geocode
        count += 1
        puts "...Done!"
      end
      puts "done geocoding #{count} restaurants!"
    end
    
    desc "geocode only those restaurants that have not been geocoded yet"
    task :empty => :environment do
      # todo 
    end
  end
end
