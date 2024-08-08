package todin

import "core:log"
import "core:os"
import "core:slice"
import "core:strings"
import "core:unicode/utf8"

EscapeKey :: struct {}
FunctionKey :: struct {}

Event :: union {
	Key,
	ArrowKey,
	EscapeKey,
	FunctionKey,
	BackSpace,
}

get_keypress :: proc() -> []rune {
	data := make([]byte, 512)
	bytes_read, err := os.read(os.stdin, data[:])
	if bytes_read <= 0 {
		return nil
	}
	return utf8.string_to_runes(string(data[:bytes_read]))
}

poll :: proc() -> (event: Maybe(Event)) {
	return parse(get_keypress())
}

key_to_string :: proc(event: Event) -> string {
	switch e in event {
	case ArrowKey:
		switch e {
		case .up:
			return "up"
		case .down:
			return "down"
		case .left:
			return "left"
		case .right:
			return "right"
		}
	case EscapeKey:
		return "escape"
	case FunctionKey:
	case BackSpace:
		return "backspace"
	case Key:
		key_string := utf8.runes_to_string([]rune{e.keyname})
		if e.control {
			if e.keyname == 'm' {
				return "enter"
			}
			s: strings.Builder
			strings.write_string(&s, "<c-")
			strings.write_string(&s, key_string)
			strings.write_string(&s, ">")
			return strings.to_string(s)
		}
		return key_string
	}
	return ""
}
