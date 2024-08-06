package todin

import "core:fmt"
import "core:log"
import "core:os"

Color :: struct {
	fg, bg: u8,
}

@(require_results)
set_fg :: proc(arg: string, color: Color) -> Maybe(string) {
	fg := color.fg
	if color.fg == 0 {
		return nil
	}
	return fmt.tprintf("\e[38;5;%dm%s\e[38;0;0m", color.fg, arg)
}
