from django.shortcuts import render
import json

# Create your views here.
def index(req):
	with open('../data/mis13.json','r') as f:
		obj = json.load(f)
	
	context = {
		'title':'Dashboard',
		'data':obj['data'],
		'labels':obj['labels'],
		'label':obj['title']
	}
	return render(req,'analytics/dashboard.html',context)
