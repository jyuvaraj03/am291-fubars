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
		# print(finders.searched_locations)
		with open(result,'r') as f:
			obj = json.load(f)

		data = [(o or 0) for o in obj['data']]
		labels = [ str(label) for label in obj['labels'] ]
		
	context = {
		'title':'Schools Report Monitoring Dashboard',
		'data':data,
		'labels':labels,
		'label':obj['title'],
		'email':'authority@fubars.com'
	}

	return render(req,'analytics/dashboard.html',context)

def complaints(req):
	result = finders.find('analytics/mis13.json')
	with open(result,'r') as f:
		obj = json.load(f)

	data = [(o or 0) for o in obj['data']]
	labels = [ str(label) for label in obj['labels'] ]
	context = {
		'title':'Schools Report Monitoring Dashboard',
		'data':data,
		'labels':labels,
		'label':obj['title'],
		'email':'authority@fubars.com'
	}

	return render(req,'analytics/dashboard.html',context)

def attendance(req):

	result = finders.find('analytics/attendance.json')
		# print(finders.searched_locations)
	with open(result,'r') as f:
		obj = json.load(f)

	data_feb = [(o or 0) for o in obj['data_feb']]
	data_jan = [(o or 0) for o in obj['data_jan']]
	labels = [str(label) for label in obj['labels'] ]
	print(labels)
		
	context = {
		'title':'Schools Report Monitoring Dashboard',
		'data_feb':data_feb,
		'data_jan':data_jan,
		'labels':labels,
		'label':obj['title'],
		'email':'authority@fubars.com'
	}

	return render(req,'analytics/attendance.html',context)
	
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