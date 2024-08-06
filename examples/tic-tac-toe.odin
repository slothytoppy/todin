package tic_tac_toe

import tui "../"
import "core:log"
import "core:os"

Board :: struct {
	data: [9]bool,
}

main :: proc() {
	fd, _ := os.open("log", os.O_RDWR | os.O_TRUNC | os.O_CREATE, 0o644)
	context.logger = log.create_file_logger(fd)
	tui.init()
	tui.enter_alternate_screen()
	board: Board
	current_turn := true
	loop: for {
		switch v in tui.poll() {
		case tui.Event:
			switch e in v {
			case tui.Key:
				log.info(e.keyname)
				if e.keyname == 'q' && e.control == true {
					log.fatal("QUITING")
					break loop
				}
			}
		}
	}
	tui.leave_alternate_screen()
	tui.deinit()
}
