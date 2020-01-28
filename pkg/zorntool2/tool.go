package zorntool2

import (
	"fmt"
	"math/rand"
	"time"
)

var (
	_src = rand.New(rand.NewSource(time.Now().UnixNano()))
	
)

func Exec(){
	for i:=0;i<5;i++{
		fmt.Printf("tool2: %d\n", _src.Intn(10))
	}
}

func Cicd() string {
	return "hello"
}

func Cdci(msg string) string {
	return fmt.Sprintf("%s %s", msg,msg)
}


