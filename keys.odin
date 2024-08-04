package todin

import "core:os"

Key :: struct {
	keyname: byte,
	control: bool,
}

Event :: union {
	Key,
}

get_keypress :: proc() -> byte {
	data := make([]byte, 1)
	os.read(os.stdin, data[:])
	return data[0]
}

parse_control_character :: proc(key: byte) -> Maybe(Key) {
	switch key {
	case 1 ..= 26:
		return Key{key + 96, true}
	}
	return nil
}

poll :: proc() -> (event: Maybe(Event)) {
	key := get_keypress()
	switch key {
	case 1 ..= 26:
		event = parse_control_character(key).(Key)
	}
	return event
}
