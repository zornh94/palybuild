package zorntool2
import (
	"testing"
)



func TestCicd(t *testing.T){
	want := "hello"
	got:= Cicd()
	if got != want {
		t.Errorf("got %s but want %s", got, want)
	}
}

func TestCdci(t *testing.T){
	want := "hi hi"
	got := Cdci("hi")
	if got != want {
		t.Errorf("got %s but want %s", got, want)
	}
}
