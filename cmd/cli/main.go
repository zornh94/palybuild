package main

import (
	"fmt"
	"playbuild/pkg/zorntool1"
	"playbuild/pkg/zorntool2"
)


var (
	// Following variables will be statically linked at the time of compiling

   // GitCommit holds short commit hash of source tree
    GitCommit string

   // GitBranch holds current branch name the code is built off
    GitBranch string

   // GitState shows whether there are uncommitted changes
    GitState string

   // GitSummary holds output of git describe --tags --dirty --always
    GitSummary string

   // BuildDate holds RFC3339 formatted UTC date (build time)
    BuildDate string

   // Version holds contents of ./VERSION file, if exists, or the value passed via the -version option
    Version string
)

func main() {
fmt.Printf(`
   GitCommit: %s
   GitBranch: %s
    GitState: %s
  GitSummary: %s
   BuildDate: %s
     Version: %s
	`, GitCommit, GitBranch, GitState, GitSummary, BuildDate, Version)
fmt.Println()
	zorntool1.Exec("yamazawa")
	zorntool2.Exec()

}
