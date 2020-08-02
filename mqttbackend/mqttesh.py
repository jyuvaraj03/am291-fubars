import paho.mqtt.client as mqtt 
import time
import json
from configparser import ConfigParser
import requests
from datetime import date

#Update report base url
url = "https://floating-badlands-95462.herokuapp.com/api/estimate/reports/"

#Setting for_date
# today = date.isoformat(date.today())

#For the food topic
food_set = set({})

#For the main topic
max_persons = 0

#Data object to be sent to the backend
data = {
	"school": 2,
	"student_count": max_persons,
	"for_date": '2020-08-05',
	"items": []
}

response = requests.post(url,data)
report_id = response.json()
report_id = report_id["id"]

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
client = mqtt.Client("",userdata = data)



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
		if no_of_persons > userdata["student_count"]:
			userdata["student_count"] = max(no_of_persons,userdata["student_count"])
			client.user_data_set(userdata)
			requests.put(url+report_id,userdata)

	elif topicesh == food_topic:
		food_items = list(record.get("objects"))
		existing_data = [userdata["items"][i]["item"] for i in range(len(userdata["items"]))]
		for food_item in food_items:
			if food_item not in existing_data:
				existing_data.append(food_item)
				userdata["items"].append({"item":food_item})
				client.user_data_set(userdata)
				requests.put(url+report_id,userdata)
				
	print(userdata)

client.on_connect = on_connect
client.on_log = on_log
client.on_disconnect = on_disconnect
client.on_message=on_message

client.connect(broker_address,port)	

# client.subscribe("/merakimv/Q2GV-7HEL-HC6C/0")

client.loop_forever()
