package todin

foreign import c_ffi "./lib/c_ffi.a"

foreign c_ffi {
	enable_no_echo :: proc() ---
	disable_no_echo :: proc() ---
	enable_raw_mode :: proc() ---
	disable_raw_mode :: proc() ---
	handle_resize :: proc() ---
}
