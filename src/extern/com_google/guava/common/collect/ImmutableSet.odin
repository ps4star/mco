package guava_collect
import "core:intrinsics"

@private
verify_unique_items :: proc(a: []$T) -> (bool)
{
	duplicate_items := false
	for i, idx in a {
		for idx2 in (idx+1)..<len(a) {
			if (a[idx] == a[idx2]) && (idx != idx2) {
				duplicate_items = true
				break
			}
		}
	}
	return duplicate_items
}

// Replaces ImmutableSet_copy_of
create_immutable_set_from_slice :: proc(items: []$T) -> (out: []T)
{
	out = nil
	if err := #force_inline verify_unique_items(items); err { return }
	out = items
	return
}