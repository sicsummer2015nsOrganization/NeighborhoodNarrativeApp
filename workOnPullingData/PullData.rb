require 'rubygems'
require 'json'
require 'net/http'
#require 'geokit-rails'
#include Geokit::Geocoders




def fetch(url)
	schoolsArray = Array.new()
	resp = Net::HTTP.get_response(URI.parse(url))
    data = resp.body
    downloadedData = JSON.parse(data)
end


def createHighSchoolDictionary(url)
	data = fetch url
	schools = Array.new
	for school in data
		modSchool = Hash.new("")
		modSchool["safe"] = school["safe"]
		modSchool["name_of_school"] = school["name_of_school"]
		modSchool["location"] = school["location"]
		modSchool["street_address"] = school["address"]
		modSchool["zip_code"] = school["zip_code"]
		modSchool["website"] = school["website"]
		modSchool["effective_leaders"] = school["effective_leaders"]
		modSchool["_4_year_graduation_rate_percentage_2013"] =  school["_4_year_graduation_rate_percentage_2013"]
		schools.push modSchool
	end
	return schools
end

def createElementarySchoolDictionary(url)
	data = fetch url
	schools = Array.new
	for school in data
		modSchool = Hash.new("")
		modSchool["safe"] = school["safe"]
		modSchool["name_of_school"] = school["name_of_school"]
		modSchool["location"] = school["location"]
		modSchool["street_address"] = school["address"]
		modSchool["zip_code"] = school["zip_code"]
		modSchool["website"] = school["website"]
		modSchool["effective_leaders"] = school["effective_leaders"]
		modSchool["student_attendance_percentage_2013"] =  school["student_attendance_percentage_2013"]
		schools.push modSchool
	end
	return schools
end

def createEarlyChildhoodDictionary(url)
	data = fetch url
	schools = Array.new
	for school in data
		modSchool = Hash.new("")
		modSchool["weekday_availability"] = school["weekday_availability"]
		modSchool["site_name"] = school["site_name"]
		modSchool["location"] = school["location"]
		modSchool["street_address"] = school["address"]
		modSchool["zip_code"] = school["zip_code"]
		modSchool["url"] = school["url"]
		modSchool["duration_hours"] = school["duration_hours"]
		modSchool["program_information"] =  school["program_information"]
		modSchool["quality_rating"] = school["quality_rating"]
		schools.push modSchool
	end
	return schools
end

def createParkDictionary(url)
	data = fetch url
	parks = Array.new
	for park in data
		modPark = Hash.new("")
		modPark["park_name"] = park["park_name"]
		modPark["zip"] = park["zip"]
		modPark["street_address"] = park["street_address"]
		modPark["dog_friendly"] = park["dog_friendly"]
		modPark["playground_park"] = park["playground_park"]
		modPark["fitness_center"] = park["fitness_center"]
		modPark["pool_outdoor"] =  park["pool_outdoor"]
		modPark["basketball_courts"] = park["basketball_courts"]
		modPark["baseball_jr_softball_t_ball"] = park["baseball_jr_softball_t_ball"]
		modPark["community_garden"] =  park["community_garden"]
		parks.push modPark
	end
	return parks
end



def collectAllData (personna)
	highSchoolProgress = "https://data.cityofchicago.org/resource/2m8w-izji.json"
	elementarySchoolProgress = "https://data.cityofchicago.org/resource/tj8h-mnuv.json"
	park = "https://data.cityofchicago.org/resource/wwy2-k7b3.json"
	earlyChildhoodDevelopment = "https://data.cityofchicago.org/resource/ck29-hb9r.json"
	allData = Hash.new("")
	allData["personna"] = personna
	allData["parks"] = createParkDictionary park
	allData["highSchools"] = createHighSchoolDictionary highSchoolProgress
	allData["elementarySchools"] = createElementarySchoolDictionary elementarySchoolProgress
	allData["earlyChildHoodPrograms"] = createEarlyChildhoodDictionary earlyChildhoodDevelopment
	return allData.to_json
end

puts collectAllData "person"
