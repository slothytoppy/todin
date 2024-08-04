package todin

foreign import c_ffi "./lib/c_ffi.a"

foreign c_ffi {
	init :: proc() ---
	deinit :: proc() ---
	enable_no_echo :: proc() ---
	disable_no_echo :: proc() ---
	enable_raw_mode :: proc() ---
	disable_raw_mode :: proc() ---
	handle_resize :: proc() ---
}
