	
extends Node2D


var SERVER_IP = "http://54.77.203.93"
var PORT = 4243
var http = null

func http_connect():
	http = HTTPClient.new()
	var err = http.connect(SERVER_IP, PORT)
	var attempts = 0
	
	while(( http.get_status()==HTTPClient.STATUS_CONNECTING or http.get_status()==HTTPClient.STATUS_RESOLVING) and 
	attempts < 25):
		#Wait until resolved and connected
		http.poll()
		OS.delay_msec(30)
		attempts+= 1
		
	if(attempts == 25 or err != OK):
		return false
	else:
		return true

func http_get(filename):
	if(http_connect()):
	
		var headers=[
			"Accept: */*"
		]
	
		http.request(HTTPClient.METHOD_GET,"/read?file="+filename,headers)
	
		while (http.get_status() == HTTPClient.STATUS_REQUESTING):
			# Keep polling until the request is going on
			http.poll()
			OS.delay_msec(30)
			
		var text = ""
		if (http.has_response()):
	
			var response = http.read_response_body_chunk()
			text = response.get_string_from_ascii()
				#rb = rb + chunk
			
			if(text.find("Traceback") != -1):
				text = "ERROR : \n" + text
			
			if text.length() < 1 :
				text = "ERROR \n: Did you forget to print?"
				
		
		return text

func http_post_request(code):
	if(http_connect()):
		
		var header=[
			"Content-Type: text/plain"
		]
		
		var filename = str(randi()) + str(randi())
	
		http.request( HTTPClient.METHOD_POST, "/python?file=" + filename, header, code)
		while (http.get_status() == HTTPClient.STATUS_REQUESTING):
			http.poll()
			OS.delay_msec(30)
			
		return http_get(filename)
	else:
		return "ERROR: \nUNABLE TO CONNECT TO SERVER. Check Network Configurations!"


