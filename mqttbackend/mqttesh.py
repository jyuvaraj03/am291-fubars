import paho.mqtt.client as mqtt 
import time
import json
from configparser import ConfigParser
import requests
from datetime import date

#Update report base url
url = "http://localhost:8000/api/estimate/reports/"

#Setting for_date
today = date.isoformat(date.today())

#For the food topic
food_set = set({})

#For the main topic
max_persons = 0

#Data object to be sent to the backend
data = {
	"school": 2,
	"student_count": max_persons,
	"for_date": today,
	"items": []
}

#The congif_mqtt.ini file is used
config = ConfigParser()
config.read('config_mqtt.ini')
broker_address, port, main_topic, food_topic = (
    config.get('mqtt','broker'),
    int(config.get('mqtt','port')),
    config.get('mqtt','main_topic'),
    config.get('mqtt','food_topic')
)


print("Creating new instance")
client = mqtt.Client("",userdata = {'max_p':max_persons ,'food':food_set})



def on_connect(client, userdata, flags, rc):
    if rc == 0:
        print("Connected to the broker")
        client.subscribe(food_topic)
        client.subscribe(main_topic)
    else:
        print(f"Bad connection returned code {rc}")

def  on_log(client, userdata, level, buf):
    print(f"[LOG] {buf}")

def on_disconnect(client, userdata, flags, rc=0):
    client.loop_stop()
    print(f"Disconnected result code {str(rc)}")

def on_message(client, userdata, message):
	topicesh = message.topic
	msg = message.payload.decode("utf-8")
	record = json.loads(msg)
	
	if topicesh == main_topic:
		temp = record.get("counts")
		no_of_persons = int(temp.get("person")) 
		userdata["max_p"] = max(no_of_persons,userdata["max_p"])
		client.user_data_set(userdata)
		# # if no_of_persons > max_persons:
		# userdata_set(max_persons) = max(no_of_persons,max_persons)
		# print(no_of_persons)
		# 	data["student_count"] = max_persons
		# 	requests.post(url,data = data)
	elif topicesh == food_topic:
		food_items = record.get("objects")
		for food_item in food_items:
			if food_item not in userdata["food"]:
				userdata["food"].add(food_item)
			client.user_data_set(userdata)
				# data['items'].append({"item":food_item})
				# requests.post(url,data = data)
	print(userdata)

client.on_connect = on_connect
client.on_log = on_log
client.on_disconnect = on_disconnect
client.on_message=on_message

client.connect(broker_address,port)	

# client.subscribe("/merakimv/Q2GV-7HEL-HC6C/0")

client.loop_forever()
