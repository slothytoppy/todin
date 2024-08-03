package todin

import "core:fmt"
import "core:log"
import "core:os"
import "core:strings"

@(init)
init :: proc() {
	enable_raw_mode()
}

get_keypress :: proc() -> byte {
	data := make([]byte, 1)
	os.read(os.stdin, data[:])
	return data[0]
}

Key :: struct {
	keyname: string,
	control: bool,
}

Event :: union {
	Key,
}

parse_control_character :: proc(key: byte) -> Maybe(Key) {
	switch key {
	case 0:
		return nil
	case 1:
		return Key{"control+a", true}
	case 2:
		return Key{"control+b", true}
	case 3:
		return Key{"control+c", true}
	case 4:
		return Key{"control+d", true}
	case 5:
		return Key{"control+e", true}
	case 6:
		return Key{"control+f", true}
	case 7:
		return Key{"control+g", true}
	case 8:
		return Key{"control+h", true}
	case 9:
		return Key{"control+i", true}
	case 10:
		return Key{"control+j", true}
	case 11:
		return Key{"control+k", true}
	case 12:
		return Key{"control+l", true}
	case 13:
		return Key{"control+m", true}
	case 14:
		return Key{"control+n", true}
	case 15:
		return Key{"control+o", true}
	case 16:
		return Key{"control+p", true}
	case 17:
		return Key{"control+q", true}
	case 18:
		return Key{"control+r", true}
	case 19:
		return Key{"control+s", true}
	case 20:
		return Key{"control+t", true}
	case 21:
		return Key{"control+u", true}
	case 22:
		return Key{"control+v", true}
	case 23:
		return Key{"control+w", true}
	case 24:
		return Key{"control+x", true}
	case 25:
		return Key{"control+y", true}
	case 26:
		return Key{"control+z", true}
	}
	return nil
}

poll :: proc() -> (event: Maybe(Event)) {
	key := get_keypress()
	switch key {
	case 1 ..= 26:
		event = parse_control_character(key).?
	}
	return event
}
