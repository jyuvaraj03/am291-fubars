import paho.mqtt.client as mqtt
import json
from configparser import ConfigParser

config = ConfigParser()
config.read('config.ini')
broker, port, topic = (
    config.get('mqtt','broker'),
    int(config.get('mqtt','port')),
    config.get('mqtt','topic')
)

#create a client
client = mqtt.Client()

def  on_connect(client, userData, flags, rc):
    if rc == 0:
        print("[INFO] Connected to the broker. OK")
        client.subscribe(topic)
    else:
        print(f"[INFO] Bad connection returned code {rc}")

def  on_log(client, userData, level, buf):
    print(f"[LOG] {buf}")

def on_disconnect(client, userData, flags, rc=0):
    client.loop_stop()
    print(f"[INFO] Disconnected result code {str(rc)}")

def on_message(client, userData, msg):
    topic = msg.topic
    msg = json.loads(msg.payload.decode("utf-8","ignore"))
    print(f"[MSG from topic:{topic}]\n{msg}")

client.on_connect = on_connect
# client.on_log = on_log
client.on_disconnect = on_disconnect
client.on_message = on_message

print("[INFO] Connecting to the broker")
client.connect(broker,port)
client.loop_forever()
