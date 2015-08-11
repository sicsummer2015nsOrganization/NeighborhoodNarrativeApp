class UsersController < ApplicationController
	def fetch(url)
		schoolsArray = Array.new()
		resp = Net::HTTP.get_response(URI.parse(url))
	    data = resp.body
	    downloadedData = JSON.parse(data)
	end


	def createHighSchoolDictionary(zip)
		data 	= fetch("https://data.cityofchicago.org/resource/2m8w-izji.json")
		schools = []

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
			modSchool["street_address"] = school["street_address"]
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
		data  = fetch("https://data.cityofchicago.org/resource/wwy2-k7b3.json")
		parks = []

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

	def validZip (userZip)
	zips = [60018, 60068, 60176, 60601, 60602, 60603, 60604, 60605, 60606, 60607, 60608, 60609, 60610, 60611, 60612, 60613, 60614, 60615, 60616, 60617, 60618, 60619, 60620, 60621, 60622, 60623, 60624, 60625, 60626, 60628, 60630, 60631, 60632, 60634, 60636, 60637, 60639, 60640, 60641, 60642, 60643, 60644, 60645, 60646, 60647, 60649, 60651, 60652, 60653, 60654, 60655, 60656, 60657, 60659, 60660, 60661, 60706, 60707, 60714]
	zips.each do |zip|
	    if zip.to_s == userZip
			return true
		end
	end
	return false
end


	def collectAllData (personna, zip)
		allData = Hash.new("")
		if(!validZip(zip))
			allData["error"] = ["zip_not_in_chicago"]
		end
		allData["personna"] = personna
		allData["parks"] = createParkDictionary zip
		allData["highSchools"] = createHighSchoolDictionary zip
		allData["elementarySchools"] = createElementarySchoolDictionary zip
		allData["earlyChildHoodPrograms"] = createEarlyChildhoodDictionary zip

		return allData.to_json
	end


	def new
		@users = User.new
	end


	def home
	end


	def index
	end


	def about 
	end


	def search
	end


	def finalpage
		@personas = params[:persona]
	    @zipcode  = params[:zipcode]
		@result   = post(@zipcode, @personas)
	end


	private
		def post(zip, personas)
		    require "net/http"
		    require "uri"

			url = "https://api.narrativescience.com/v4/editorial/55b135718ff57d597c2fb6e6/story/"
			uri = URI.parse(url)
			https = Net::HTTP.new(uri.host, uri.port)
			https.use_ssl = true
			https.verify_mode = OpenSSL::SSL::VERIFY_NONE
			request = Net::HTTP::Post.new(uri.path, initheader = {'content-type' =>'application/json', 'x-ns-api-token' => Rails.application.secrets.ns_token, 'x-ns-accepts' => 'html', 'x-ns-template' => Rails.application.secrets.ns_template})

			request.body = collectAllData(personas,zip)
			
			response = https.request(request)

			response.body
		end
end