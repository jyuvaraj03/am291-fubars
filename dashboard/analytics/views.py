from django.shortcuts import render, redirect
import json
from django.contrib.staticfiles import finders
import os

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
		result = finders.find('analytics/mis13.json')
		print(finders.searched_locations)
		# with open(,'r') as f:
		# 	obj = json.load(f)
		
	context = {
		'title':'Schools Report Monitoring Dashboard',
		'data':obj['data'],
		'labels':obj['labels'],
		'label':obj['title'],
		'email':'authority@fubars.com'
	}

	return render(req,'analytics/dashboard.html',context)
# from django.shortcuts import render
# import json

# # Create your views here.
# def index(req):
# 	with open('../data/mis13.json','r') as f:
# 		obj = json.load(f)

# 	context = {
# 		'title':'Dashboard',
# 		'data':obj['data'],
# 		'labels':obj['labels'],
# 		'label':obj['title']
# 	}
# 	return render(req,'analytics/dashboard.html',context)

def complaints(req):
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
		with open('./data/mis13.json','r') as f:
			obj = json.load(f)
		
	context = {
		'title':'Schools Report Monitoring Dashboard',
		'data':obj['data'],
		'labels':obj['labels'],
		'label':obj['title'],
		'email':'authority@fubars.com'
	}

	return render(req,'analytics/Dashboard_index.html',context)

def attendance(req):
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
		with open('./data/mis13.json','r') as f:
			obj = json.load(f)
		
	context = {
		'title':'Schools Report Monitoring Dashboard',
		'data':obj['data'],
		'labels':obj['labels'],
		'label':obj['title'],
		'email':'authority@fubars.com'
	}

	return render(req,'analytics/Dashboard_index.html',context)
def allotment(req):
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
		with open('./data/mis13.json','r') as f:
			obj = json.load(f)
		
	context = {
		'title':'Schools Report Monitoring Dashboard',
		'data':obj['data'],
		'labels':obj['labels'],
		'label':obj['title'],
		'email':'authority@fubars.com'
	}

	return render(req,'analytics/Dashboard_index.html',context)

def live(req):
	pass