from configparser import ConfigParser
from Meraki.utils import snapshot
from DetectionTools.ops import load_model, get_detected_classes
import numpy as np
import random
import paho.mqtt.client as mqtt
import json
import os
import time

config = ConfigParser()

config.read('config.ini')

serial, api_key, network_id, model_dir, broker, port, topic, json_dir = (
	config.get('credentials','camera_serial'),
    config.get('credentials','api_key'),
    config.get('credentials','network_id'),
    config.get('model','model_dir'),
    config.get('mqtt','broker'),
    int(config.get('mqtt','port')),
    config.get('mqtt','topic'),
    config.get('model','classes_json_dir')
)

if __name__ == '__main__':

    dir = os.listdir('static/test/')

    # load model
    print("[INFO] Loading model...",end="\n")
    detect_fn = load_model(model_dir)
    print("[INFO] Model has been loaded.",end="\n")

    with open(os.path.join(os.getcwd(),json_dir),'r') as f:
        category_index = json.load(f)
    
    #mqtt client
    client = mqtt.Client()

    def  on_connect(client, userData, flags, rc):
        if rc == 0:
            print("[INFO] Connected to the broker. OK")
        else:
            print(f"[INFO] Bad connection returned code {rc}")

    def  on_log(client, userData, level, buf):
        print(f"[LOG] {buf}")

    def on_disconnect(client, userData, flags, rc=0):
        client.loop_stop()
        client.disconnect()
        print(f"[INFO] Disconnected result code {str(rc)}")
        
    client.on_connect = on_connect
    client.on_log = on_log
    client.on_disconnect = on_disconnect

    print("[INFO] Connecting to the broker")
    client.connect(broker,port,60)
    client.loop_start()

    #keeps fetching images
    while True:

        #fetch image
        # print("[INFO] Loading Image....")
        image_loc, timestamp = snapshot(network_id,serial, api_key)
        print("[INFO] Image Loaded")

        image_loc = '/static/test/' + random.choice(dir)

        #detect images
        print(f"[INFO] Detecting Objects in {image_loc}")
        classes = get_detected_classes(detect_fn, category_index, image_loc, threshold=0.75)

        data = json.dumps({
            "ts": timestamp,
            "objects": classes
        })
        client.publish(topic,payload=data)
        print(f"[SENT] {data}")
