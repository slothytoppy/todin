package todin

import "core:fmt"
import "core:log"
import "core:os"
import "core:strings"

main :: proc() {
	fd, _ := os.open("log", os.O_RDWR | os.O_TRUNC | os.O_CREATE, 0o644)
	context.logger = log.create_file_logger(fd)
	enable_raw_mode()
	enable_no_echo()
	event_loop: for {
		key := poll()
		switch v in key {
		case Event:
			switch e in v {
			case Key:
				if e.keyname == "control+q" && e.control == true {
					break event_loop
				}
				log.info(e)
			}
		}
	}
	disable_raw_mode()
}
