package todin

import "core:fmt"
import "core:os"
import "core:strings"

enter_alternate_screen :: proc() {
	os.write_string(os.stdin, "\e[?1049h")
	clear_screen()
	reset_cursor()
}

leave_alternate_screen :: proc() {
	os.write_string(os.stdin, "\e[?1049l")
}

clear_screen :: proc() {
	os.write_string(os.stdin, "\e[2J")
}

erase_line :: proc() {
	os.write_string(os.stdin, "\e[2K")
}

move_print :: proc(y, x: int, args: ..any) {
	move(y, x)
	print(..args)
}

print :: proc(args: ..any) {
	os.write_string(os.stdin, strings.concatenate({fmt.tprint(..args)}))
}

delch :: proc() {
	os.write_string(os.stdin, "\e[1P")
}
