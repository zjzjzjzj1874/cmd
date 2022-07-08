package version

import "testing"

func TestName(t *testing.T) {
	t.Run("#embed Test", func(t *testing.T) {
		t.Log(Version)
	})
}
