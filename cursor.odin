package todin

import "core:fmt"
import "core:os"
import "core:strconv"

reset_cursor :: proc() {
	os.write_string(os.stdin, "\e[H")
}

move :: proc(#any_int y, x: i32) {
	fmt.printf("\e[%d;%dH", y, x)
}

move_up :: proc() {
	fmt.printf("\e[1A")
}

move_down :: proc() {
	fmt.printf("\e[1B")
}

move_right :: proc() {
	fmt.printf("\e[1C")
}

move_left :: proc() {
	fmt.printf("\e[1D")
}

move_to_start_of_next_line :: proc() {
	fmt.printf("\e[1E")
}

scroll_up :: proc() {
	fmt.printf("\e[1S")
}

scroll_down :: proc() {
	fmt.printf("\e[1T")
}

save_cursor_pos :: proc() {
	fmt.printf("\e[7")
}

restore_cursor_pos :: proc() {
	fmt.printf("\e[8")
}

get_cursor_pos :: proc() -> (lines, columns: int) {
	buf: [20]byte
	os.write_string(os.stdin, "\e[6n")
	os.read(os.stdin, buf[:])
	if string(buf[:2]) != "\e[" {
		panic("could not find the proper escape sequence: \"\\e[\"")
	}
	start, start_idx: int
	for b, i in buf {
		if b == '[' {
			start_idx = i + 1
			break
		}
	}
	i := start_idx
	for b in buf[start_idx:] {
		i += 1
		if b == ';' {
			lines = strconv.atoi(string(buf[start_idx:i]))
			start = i
		} else if b == 'R' {
			columns = strconv.atoi(string(buf[start:i]))
			break
		}
	}
	return lines, columns
}

get_max_cursor_pos :: proc() -> (max_lines, max_columns: i32) {
	max_lines = GLOBAL_WINDOW_SIZE.cols
	max_columns = GLOBAL_WINDOW_SIZE.rows
	return max_lines, max_columns
}
