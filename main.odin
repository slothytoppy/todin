package todin

import "core:log"
import "core:os"

main :: proc() {
	init()
	disable_no_echo()
	disable_raw_mode()
	fd, _ := os.open("log", os.O_RDWR | os.O_TRUNC | os.O_CREATE, 0o644)
	context.logger = log.create_file_logger(fd)
	event_loop: for {
		key := poll()
		switch v in key {
		case Event:
			switch e in v {
			case Key:
				if e.keyname == 'q' && e.control == true {
					break event_loop
				}
				log.info(e.keyname)
			}
		}
	}
	deinit()
}
