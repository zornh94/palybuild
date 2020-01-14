package main

import (
	"flag"
	"fmt"
	"log"
	"net/http"
	"time"

	"github.com/gorilla/mux"
)

var port = flag.Int("port", 8000, "port to serve to")

func init() {
	flag.Parse()
}

func sayHello(w http.ResponseWriter, r *http.Request) {
	// Extract params from the request
	params := mux.Vars(r)
	// Extract the name
	name, found := params["name"]
	// If name param was not supplied, set default value to world
	if !found {
		name = "World"
	}
	w.WriteHeader(http.StatusOK)
	fmt.Fprintf(w, "Hello %s!!\n", name)
}

var (
	Version string
)
func main() {
	fmt.Printf("Version:%s\nAuthor:%s\n", Version)
	// Build the address:port, if nothing was passed we have 8000 at
	// port and it would result in "127.0.0.1:8000"
	addr := fmt.Sprintf("127.0.0.1:%d", *port)
	srv := &http.Server{
		Addr: addr,
		// Good practice: enforce timeouts for servers you create!
		WriteTimeout: 15 * time.Second,
		ReadTimeout:  15 * time.Second,
	}

	// The router
	r := mux.NewRouter()

	// Handle everything that comes through "/"
	r.HandleFunc("/", sayHello)
	// Handle route with name provided
	r.HandleFunc("/{name}", sayHello)

	// Set the server handler to our mux router
	srv.Handler = r

	// Tell folks what address are we listning to
	fmt.Printf("Listining at %s\n", addr)
	// Log failures (if any)
	log.Fatal(srv.ListenAndServe())
}
