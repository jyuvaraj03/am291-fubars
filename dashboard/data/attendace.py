import json

with open('allocation.json','r') as f:
	data = json.load(f)

d = {}

for datum in data:
	d[datum['ID']] = datum

with open('allocation_final.json','w') as f:
	json.dump(d,f)