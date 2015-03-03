
extends Node2D


var SERVER_IP = "http://54.77.203.93"
var http = null

func http_connect():
	http = HTTPClient.new()
	var err = http.connect(SERVER_IP, 4243)
	
	while( http.get_status()==HTTPClient.STATUS_CONNECTING or http.get_status()==HTTPClient.STATUS_RESOLVING):
	#	#Wait until resolved and connected
		http.poll()
		print("Connecting..")	
		OS.delay_msec(30)



func http_get(filename):

	http_connect()

	var headers=[
		"Accept: */*"
	]

	http.request(HTTPClient.METHOD_GET,"/read?file="+filename,headers) # Request a page from the site (this one was chunked..)
	#assert( err == OK ) # Make sure all is OK

	while (http.get_status() == HTTPClient.STATUS_REQUESTING):
		# Keep polling until the request is going on
		http.poll()
		OS.delay_msec(30)


	assert( http.get_status() == HTTPClient.STATUS_BODY or http.get_status() == HTTPClient.STATUS_CONNECTED ) # Make sure request finished well.

	if (http.has_response()):
		#If there is a response..

		var rb = RawArray() #array that will hold the data

		while(http.get_status()==HTTPClient.STATUS_BODY):
			http.poll()
			var chunk = http.read_response_body_chunk()
			rb = rb + chunk
			
		var text = rb.get_string_from_ascii()
		
		if text.length() < 1 :
			text = "ERROR: \nDid you forget to print?"
		
		return text

func http_post_request(code):
	http_connect()
	
	var header=[
		"Content-Type: text/plain"
	]
	
	var filename = str(randi())

	http.request( HTTPClient.METHOD_POST, "/python?file=" + filename, header, code)
	while (http.get_status() == HTTPClient.STATUS_REQUESTING):
		# Keep polling until the request is going on
		http.poll()
		OS.delay_msec(30)
		
	return http_get(filename)
		

func _init():
	pass

func _ready():

	pass

