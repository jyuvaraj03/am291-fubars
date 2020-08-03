import json
import random

labels = ["DALIGUMMADI","GES HUKUMPETA","GES NEELAMPUTTU","GES SUKURU"]

data_feb = [ random.randint(400,700) for _ in range(4) ]

data_jan = [ data+random.randint(-20,20) for data in data_feb ]

d = {
		'title':'Attendance of Students in Feb and Jan 2020',
		'data_feb':data_feb,
		'data_jan':data_jan,
		'labels':labels
	}

with open('attendance.json','w') as f:
	json.dump(d,f)
