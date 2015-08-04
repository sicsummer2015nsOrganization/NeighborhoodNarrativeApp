require 'rubygems'
require 'json'
require 'net/http'
require 'net/https'
require 'uri'




def fetch(url)
	schoolsArray = Array.new()
	resp = Net::HTTP.get_response(URI.parse(url))
    data = resp.body
    downloadedData = JSON.parse(data)
end


def createHighSchoolDictionary(zip)
	data = fetch("https://data.cityofchicago.org/resource/2m8w-izji.json")
	schools = Array.new
	for school in data
		if (school["zip"] == zip)
			modSchool = Hash.new("")
			modSchool["safe"] = school["safe"]
			modSchool["name_of_school"] = school["name_of_school"]
			modSchool["location"] = school["location"]
			modSchool["street_address"] = school["street_address"]
			modSchool["zip_code"] = school["zip"]
			modSchool["website"] = school["website"]
			modSchool["effective_leaders"] = school["effective_leaders"]
			modSchool["_4_year_graduation_rate_percentage_2013"] =  school["_4_year_graduation_rate_percentage_2013"]
			schools.push modSchool
		end
	end
	return schools
end

def createElementarySchoolDictionary(zip)
	data = fetch("https://data.cityofchicago.org/resource/tj8h-mnuv.json")
	schools = Array.new
	for school in data
	if (school["zip_code"] == zip)
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
	end
	return schools
end

def createEarlyChildhoodDictionary(zip)
	data = fetch("https://data.cityofchicago.org/resource/ck29-hb9r.json")
	schools = Array.new
	for school in data
	if (school["zip"] == zip)
		modSchool = Hash.new("")
		modSchool["weekday_availability"] = school["weekday_availability"]
		modSchool["site_name"] = school["site_name"]
		modSchool["location"] = school["location"]
		modSchool["street_address"] = school["address"]
		modSchool["zip_code"] = school["zip"]
		modSchool["url"] = school["url"]
		modSchool["duration_hours"] = school["duration_hours"]
		modSchool["program_information"] =  school["program_information"]
		modSchool["quality_rating"] = school["quality_rating"]
		schools.push modSchool
	end
	end
	return schools
end

def createParkDictionary(zip)
	data = fetch("https://data.cityofchicago.org/resource/wwy2-k7b3.json")
	parks = Array.new
	for park in data
	if(park["zip"] == zip)
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
	end
	return parks
end



def collectAllData (personna, zip)
	allData = Hash.new("")
	allData["personna"] = personna
	allData["parks"] = createParkDictionary zip
	allData["highSchools"] = createHighSchoolDictionary zip
	allData["elementarySchools"] = createElementarySchoolDictionary zip
	allData["earlyChildHoodPrograms"] = createEarlyChildhoodDictionary zip
	puts allData.to_json
	return allData.to_json
end


def post(zip, personna)
	url = "https://api.narrativescience.com/v4/editorial/55b135718ff57d597c2fb6e6/story/"
	uri = URI.parse(url)
	https = Net::HTTP.new(uri.host, uri.port)
	https.use_ssl = true
	https.verify_mode = OpenSSL::SSL::VERIFY_NONE
	request = Net::HTTP::Post.new(uri.path, initheader = {'content-type' =>'application/json', 'x-ns-api-token' => '55b13546374bb105eefa0d69', 'x-ns-accepts' => 'html', 'x-ns-template' => '55ba57a218c29f773c073cb5'})
	request.body = collectAllData(personna,zip)
	
	response = https.request(request)
	puts response.body
end





post("60613", "child")


