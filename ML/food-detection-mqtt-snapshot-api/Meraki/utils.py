import requests
import time, datetime, dateutil.parser
import json
import os

#source:https://github.com/CiscoDevNet/Object-detection-via-Meraki-Camera/blob/master/meraki/util.py
#I acknowledge that the below code snippets were taken from the above source
#I take no ownership of the following code snippets

def get_response(uri, api_key, payload=None, method="GET"):
    """Get video link"""

    url = "https://api.meraki.com/api/v0{0}".format(uri)

    headers = {
        'X-Cisco-Meraki-API-Key': api_key
    }

    if method == "GET":
        resp = requests.request(method, url, headers=headers, params=payload)

    if method == "POST":
        resp = requests.request(method, url, headers=headers, data=payload)

    if int(resp.status_code / 100) == 2:
        return resp.json()
    else:
        return None

def get_snapshot(ts, serial, network_id,api_key):
    """Get snapshot from endpoint and save it locally in static folder"""

    uri = f"/networks/{network_id}/cameras/{serial}/snapshot"

    querystring = {"timestamp": ts}

    resp = get_response(uri, api_key, json.dumps(querystring), "POST")

    if resp:

        url = resp["url"]

        snapshot_loc = "/static/{0}.jpeg".format(ts)
        snapshot_file = os.path.join(os.getcwd(), "." + snapshot_loc)

        # attempt to fetch the image for 20 times

        for i in range(0, 50):
            resp = requests.request("GET", url, stream=True)
            if int(resp.status_code / 100) == 2:
                # print("[LOG] {0} time succeed".format(i))
                with open(snapshot_file, 'wb') as f:
                    for chunk in resp:
                        f.write(chunk)

                break
            else:
                # print("[LOG] {0} time failed".format(i))
                # pass

        return snapshot_loc
    else:
        return None

def snapshot(networkId, serial, api_key ):
    """get current timestamp"""
    
    utc_offset_sec = time.altzone if time.localtime().tm_isdst else time.timezone
    utc_offset = datetime.timedelta(seconds=-utc_offset_sec)
    timestamp = datetime.datetime.now().replace(tzinfo=datetime.timezone(offset=utc_offset)).isoformat()

    #get snapshot
    snapshot_loc = get_snapshot(timestamp, serial, networkId, api_key)

    return (snapshot_loc, timestamp)