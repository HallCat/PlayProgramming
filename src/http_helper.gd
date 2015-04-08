extends Node2D

# Set the Server IP and Port as constants
const SERVER_IP = "http://54.77.203.93"
const PORT = 4243
const TOTAL_ATTEMPTS = 25

func server_connect():
	var connection = HTTPClient.new()
	connection.connect(SERVER_IP, PORT)
	var attempts = 0
	
	# Keep trying to connect while the connection is connecting or resolving
	# And as long as there have only been less than total attempts  
	while((connection.get_status() == HTTPClient.STATUS_CONNECTING or
		connection.get_status() == HTTPClient.STATUS_RESOLVING) and 
		attempts < TOTAL_ATTEMPTS):
		# Poll the connection
		connection.poll()
		# wait 30 milliseconds
		OS.delay_msec(30)
		# Increment the attempt counter
		attempts+= 1

	# Check the amount of the attempts
	if(attempts < TOTAL_ATTEMPTS):
		# Connection successful, return connection
		return connection
	else:
		# Connection failed
		return false

# Make the get request with the filename passed in
func http_get(filename):
	# Connect to the server
	var server_connection = server_connect()
	if(server_connection):
		
		# Set the headers
		var headers=["Accept: */*"]
	
		# Make the /read get request
		server_connection.request(HTTPClient.METHOD_GET,"/read?file="+filename,headers)
	
		# While still requeting.
		while (server_connection.get_status() == HTTPClient.STATUS_REQUESTING):
			# Poll
			server_connection.poll()
			# Wait 30 milliseconds
			OS.delay_msec(30)
			
		# init result text.
		var result_text = ""
		# Check if the request has a response
		if (server_connection.has_response()):
			# Get the entire response in array form
			var response = server_connection.read_response_body_chunk()
			# Convert array to string
			result_text = response.get_string_from_ascii()
			
			# Check if the result is an error. (ie. it contains the word "Traceback")
			if(result_text.find("Traceback") != -1):
				# Set the text as the error
				result_text = "ERROR : \n" + result_text
			
			# If the response is empty, remind the user to print.
			if result_text.length() < 1 :
				result_text = "ERROR: \nDid you forget to print?"
				
		# Return the result
		return result_text

# Make the HTTP POST /python request
func http_post_request(code):
	# connect to the servers
	var server_connection = server_connect()
	# Check the connection
	if(server_connection):
		# Set the header
		var header=["Content-Type: text/plain"]
		
		# Create the filename string, as two random numbers
		var filename = str(randi()) + str(randi())
	
		# Make the /python request, passing the filename and code.
		server_connection.request( HTTPClient.METHOD_POST, "/python?file=" + filename, header, code)
		
		# Continue while requesting
		while (server_connection.get_status() == HTTPClient.STATUS_REQUESTING):
			# Poll
			server_connection.poll()
			# Wait 30 milliseconds
			OS.delay_msec(30)
			
		# Make the get request
		return http_get(filename)
	else:
		# Unable to connect, give error code to check connection
		return "ERROR: \nUNABLE TO CONNECT TO SERVER. Check Network Configurations!"
