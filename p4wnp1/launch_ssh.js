// Launches ssh session on host Windows machine
// Intended to be run automatically on startup

delay(10000)

typingSpeed(0,0)

press("WIN R")
delay(100)
type("cmd")
press("ENTER")

delay(500)

type("ssh root")
press("SHIFT 2")
type("172.16.0.1")
press("ENTER")
delay(1000)
type("toor")
press("ENTER")