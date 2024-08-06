package todin

import "core:fmt"
import "core:log"
import "core:os"
import "core:testing"
import "core:unicode/utf8"

Key :: struct {
	keyname: rune,
	control: bool,
}

ArrowKey :: enum {
	up,
	down,
	left,
	right,
}


State :: enum {
	initial,
	normal,
	csi,
	escape,
	arrow_key,
}

/* 
state graph:
  initial_state->normal, control, or escape
  normal->normal 
  control->control, control->arrow_key 
  escape->escape
*/

parse :: proc(key: []rune) -> Maybe(Event) {
	state := State.initial
	event: Maybe(Event) = nil
	loop: for b, i in key {
		switch state {
		case .initial:
			event, state = initial_state(b, state)
		case .normal:
			event, state = normal_state(b)
		case .csi:
			event, state = control_state(b)
		case .escape:
			event, state = escape_state(b, state)
		case .arrow_key:
			event, state = arrow_state(b, state)
		}
		log.info(state)
	}
	return event
}

initial_state :: proc(datum: rune, state: State) -> (Event, State) {
	switch datum {
	case 1 ..= 26:
		return control_state(datum)
	case 27:
		return escape_state(datum, .escape)
	case 32 ..= 126:
		return normal_state(datum)
	}
	return nil, .initial
}

normal_state :: proc(datum: rune) -> (Event, State) {
	log.info(datum)
	switch datum {
	case 32 ..= 126:
		return Key{datum, false}, .normal
	case:
		return nil, .initial
	}
	return nil, .initial
}

control_state :: proc(datum: rune) -> (Event, State) {
	switch datum {
	case 1 ..= 26:
		return Key{keyname = datum + 96, control = true}, .csi
	case:
		return nil, .initial
	}
	return nil, .initial
}

escape_state :: proc(datum: rune, state: State) -> (Event, State) {
	log.info(int(datum), state)
	switch datum {
	case 27:
		return EscapeKey{}, .escape
	}
	if state == .escape && datum == 91 {
		return nil, .arrow_key
	}
	return nil, .initial
}

arrow_state :: proc(datum: rune, state: State) -> (Event, State) {
	log.info("here")
	#partial switch state {
	case .escape, .arrow_key:
		switch datum {
		case 65 ..= 68:
			return ArrowKey{}, .arrow_key
		}
	}
	return nil, .initial
}

@(test)
test_normal_key :: proc(t: ^testing.T) {
	data := []rune{65}
	expected := Key{65, false}
	result := parse(data).?
	testing.expect(t, result == expected)
}

@(test)
test_control_key :: proc(t: ^testing.T) {
	data := []rune{1}
	expected := Key{97, true}
	result := parse(data).?
	testing.expect_value(t, result, expected)

}

@(test)
test_arrow_key :: proc(t: ^testing.T) {
	data := []rune{27, 65}
	expected := ArrowKey{}
	result := parse(data).?
	testing.expect_value(t, result, expected)

}
