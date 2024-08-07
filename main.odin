package todin

import "core:log"
import "core:os"

main :: proc() {
	fd, _ := os.open("log", os.O_RDWR | os.O_TRUNC | os.O_CREATE, 0o644)
	context.logger = log.create_file_logger(fd)
	init()
	enter_alternate_screen()
	move(0, 0)
	print("hello")
	event_loop: for {
		key := poll()
		if key == nil {
			continue
		}
		key_str := key_to_string(key.?)
		log.info(key_str)
		if key_str == "<c-q>" {
			break event_loop
		}
	}
	leave_alternate_screen()
	deinit()
}
