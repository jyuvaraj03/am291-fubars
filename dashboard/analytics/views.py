from django.shortcuts import render, redirect
import json

# Create your views here.
def index(req):
	obj = {'data':[],'labels':[],'title':''}

	if req.method == 'POST':
		filename = '../data/'+req.POST['type']+req.POST['year']+'.json'
		with open(filename,'r') as f:
			obj = json.load(f)

		# context = {
		# 	'title':'Schools Report Monitoring Dashboard',
		# 	'data':obj['data'],
		# 	'labels':obj['labels'],
		# 	'label':obj['title'],
		# 	'email':'authority@fubars.com'
		# }

		return redirect('index')

	else:
		with open('../data/mis13.json','r') as f:
			obj = json.load(f)
		
	context = {
		'title':'Schools Report Monitoring Dashboard',
		'data':obj['data'],
		'labels':obj['labels'],
		'label':obj['title'],
		'email':'authority@fubars.com'
	}

	return render(req,'analytics/dashboard.html',context)
