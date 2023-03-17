package j_util
import "core:fmt"
import "core:strings"
import "core:time"

// Emulates java.util.Date
Date :: time.Time

Date_new_from_current_time :: #force_inline proc() -> (Date)
{
	return time.now()
}