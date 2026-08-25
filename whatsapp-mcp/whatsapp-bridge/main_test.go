package main

import (
	"os"
	"path/filepath"
	"strconv"
	"strings"
	"testing"
	"time"

	waLog "go.mau.fi/whatsmeow/util/log"
)

func TestShouldTriggerIncoming(t *testing.T) {
	t.Setenv("WSP_EVENT_TRIGGER", "/tmp/evento-wsp")
	t.Setenv("WSP_JID", "objetivo@lid")

	tests := []struct {
		name     string
		chatJID  string
		fromMe   bool
		isNew    bool
		expected bool
	}{
		{"incoming new target", "objetivo@lid", false, true, true},
		{"other chat", "otro@lid", false, true, false},
		{"outgoing", "objetivo@lid", true, true, false},
		{"replayed", "objetivo@lid", false, false, false},
	}

	for _, test := range tests {
		t.Run(test.name, func(t *testing.T) {
			got := shouldTriggerIncoming(test.chatJID, test.fromMe, test.isNew)
			if got != test.expected {
				t.Fatalf("shouldTriggerIncoming() = %v, want %v", got, test.expected)
			}
		})
	}
}

func TestShouldTriggerCanBeDisabled(t *testing.T) {
	t.Setenv("WSP_EVENT_TRIGGER", "")
	t.Setenv("WSP_JID", "objetivo@lid")
	if shouldTriggerIncoming("objetivo@lid", false, true) {
		t.Fatal("empty WSP_EVENT_TRIGGER must disable event wakes")
	}
}

// El watcher es lo unico que queda vigilando la salud del bridge, asi que no puede ser
// hijo suyo: un bridge que muere se lleva a sus hijos y apagaria el aviso justo cuando
// hace falta. Se comprueba sobre el proceso real y no sobre la config.
func TestEventWatcherSurvivesTheBridge(t *testing.T) {
	dir := t.TempDir()
	marker := filepath.Join(dir, "sid")
	script := filepath.Join(dir, "watcher.sh")
	// Con Setsid el hijo es lider de su propia sesion, o sea que su SID es su propio PID.
	body := "#!/bin/sh\nprintf '%s %s' \"$$\" \"$(ps -o sid= -p $$)\" > " + marker + "\nsleep 5\n"
	if err := os.WriteFile(script, []byte(body), 0o755); err != nil {
		t.Fatalf("no se pudo escribir el watcher falso: %v", err)
	}
	t.Setenv("WSP_EVENT_TRIGGER", script)

	startEventWatcher(waLog.Noop)

	var raw []byte
	for i := 0; i < 100; i++ {
		if data, err := os.ReadFile(marker); err == nil && len(strings.Fields(string(data))) == 2 {
			raw = data
			break
		}
		time.Sleep(50 * time.Millisecond)
	}
	if raw == nil {
		t.Fatal("el watcher no llego a arrancar")
	}
	fields := strings.Fields(string(raw))
	if len(fields) != 2 {
		t.Fatalf("marca ilegible %q", raw)
	}
	pid, err := strconv.Atoi(fields[0])
	if err != nil {
		t.Fatalf("pid ilegible %q: %v", fields[0], err)
	}
	sid, err := strconv.Atoi(fields[1])
	if err != nil {
		t.Fatalf("sid ilegible %q: %v", fields[1], err)
	}
	if sid != pid {
		t.Fatalf("el watcher no es lider de sesion (pid %d, sid %d): moriria con el bridge", pid, sid)
	}
}

func TestEventWatcherDoesNotStartWhenDisabled(t *testing.T) {
	t.Setenv("WSP_EVENT_TRIGGER", "")
	// No debe reventar ni dejar nada corriendo: es la valvula de escape documentada
	startEventWatcher(waLog.Noop)
}
