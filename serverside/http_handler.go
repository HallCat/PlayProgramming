package main

import (
  "log"
  "net/http"
  "io/ioutil"
  "os"
  "os/exec"
  "fmt"
  //"time"
  "bufio"
)

type pythonHandler struct {
  string
}

type readFileHelper struct {
  string
}

func (reader *readFileHelper) ServeHTTP(w http.ResponseWriter, r *http.Request) {

	filename := r.URL.Query().Get("file")
	dat, err := ioutil.ReadFile(filename)
    if err != nil {
		log.Fatal(err)
	}


    response := string(dat)
    if f, ok := w.(http.Flusher); ok {
     f.Flush()
 	}

	os.Remove(filename)

    w.Write([]byte(response))


}	

func (ph *pythonHandler) ServeHTTP(w http.ResponseWriter, r *http.Request) {


	filename := r.URL.Query().Get("file")

    log.Println(filename)

	body, err := ioutil.ReadAll(r.Body)

	if err != nil {
		log.Fatal(err)
	}


	bodyStr := string(body)

	runStr := fmt.Sprint("sudo docker run --rm=true --name ", filename,
	 " python:2 python -c '", bodyStr,	 "'")// &> ", filename)

	exitStr := fmt.Sprint("sudo docker kill ", filename)
	log.Println(exitStr)

	log.Println(runStr)
	cmd := exec.Command("/bin/sh", "-c", runStr)
    out, err := cmd.CombinedOutput()

    log.Println(out)


    f, err := os.Create(filename)
    writer := bufio.NewWriter(f)
 	writer.WriteString(string(out))
    writer.Flush()
    /*
	done := make(chan error, 1)
	go func() {
	    done <- cmd.Wait()
	}()
	select {
	    case <-time.After(3* time.Second):
	        if err := cmd.Process.Kill(); err != nil {
	            log.Fatal("failed to kill: ", err)
	        }

	        exec.Command("/bin/sh", "-c", exitStr).Start()
	        <-done // allow goroutine to exit
	        log.Println("process killed")
	    case err := <-done:
	            if err!=nil{
	                log.Printf("process done with error = %v", err)
	            }
	}
	*/
	
}

func main() {
  mux := http.NewServeMux()

  dh := &pythonHandler{"building"}
  mux.Handle("/python", dh)

  uh := &readFileHelper{"upload"}
  mux.Handle("/read", uh)

  log.Println("Listening...")
  http.ListenAndServe(":4243", mux)

}