import requests

base_url = "https://floating-badlands-95462.herokuapp.com/api/estimate/reports/"

response = requests.patch(base_url + '7', data ={
	"school": 3,
	"student_count": 98,
	"for_date": "2020-08-04",
	"items": [{"item":"rice"},{"item":"idly"}]
} )

print(response.status_code)
print(response.json())

