package main

import (
  "log"
  "net/http"
  "io/ioutil"
  "os"
  "os/exec"
  "fmt"
  "time"
  "bufio"
  "bytes"
)

// Constant Store the error for timeout
const TIMEOUT_ERR = "TIMEOUT. Your code ran too long. \n" +
      				"Do you have an infinite loop?"

// Function for handling reading of files
func readFileHandler(w http.ResponseWriter, r *http.Request) {

	// Retrieve the filename
	filename := r.URL.Query().Get("file")
	// Read the file name
	response, _ := ioutil.ReadFile(filename)

	// Init flusher
    flusher := w.(http.Flusher)
    // Flush ResponseWriter
    flusher.Flush()

    // Remove file
	os.Remove(filename)

	// Write the response
    w.Write(response)
}	

func pythonHandler(w http.ResponseWriter, r *http.Request) {
	filename := r.URL.Query().Get("file")

	// Get body from request
	body, _ := ioutil.ReadAll(r.Body)
	bodyString := string(body)

	// prepare run string
	runString := fmt.Sprint("sudo docker run --rm=true --name ", filename,
	 					 " python:2 python -c '", bodyString,	 "'")

	// prepare kill string
	exitString := fmt.Sprint("sudo docker kill ", filename)
	command := exec.Command("/bin/sh", "-c", runString)
 
 	// Init output
    output := &bytes.Buffer{}
    error_stream := &bytes.Buffer{}
    // connect the output of the command and the output var
    command.Stdout = output
    command.Stderr = error_stream

    command.Start()

    // Initialize result output
    result_output := ""

    // Make a channel for connecting/comparing the two sub routines.
	execution_finished := make(chan error)

	// Create a goroutine that will wait for the execution to finish
	go func() {
	    execution_finished <- command.Wait()
	}()

	// Select statement, chooses which operation has been received 
	select {
		// If the timeout of 1 second has been received
	    case <-time.After(time.Second):
	    	// Kill the command
	        command.Process.Kill()
	        // Kill the docker container
	        exec.Command("/bin/sh", "-c", exitString).Start()

	        result_output = TIMEOUT_ERR

	    // If the execution of the command has finished
	    case <-execution_finished:
	    	result_output = string(output.Bytes())

	}

	// Create file
    file, _ := os.Create(filename)
    // Write output to file
    writer := bufio.NewWriter(file)
 	writer.WriteString(result_output)
 	writer.WriteString(string(error_stream.Bytes()))

    // Flush writer
    writer.Flush()
}

func main() {
	// Create multiplexer for checking incoming requests
	request_multiplexer := http.NewServeMux()

	// Tell multiplexer how to handler /python and /read requests
	// by linking them to the respective handlers
	request_multiplexer.HandleFunc("/python", pythonHandler)
	request_multiplexer.HandleFunc("/read", readFileHandler)
	
	// Listen on port 4243
	log.Println("Listening...")
	http.ListenAndServe(":4243", request_multiplexer)

}