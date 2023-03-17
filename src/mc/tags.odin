package mc
import j_io "mco:java/io"

ByteArrayTag :: struct
{

}

ByteTag :: struct
{

}

CollectionTag :: struct
{

}

CompoundTag :: struct
{
	
}

DoubleTag :: struct
{

}

EndTag :: struct
{

}

FloatTag :: struct
{

}

IntArrayTag :: struct
{

}

IntTag :: struct
{

}

ListTag :: struct
{

}

LongArrayTag :: struct
{

}

LongTag :: struct
{

}

NumericTag :: struct
{

}

ShortTag :: struct
{

}

StringTag :: struct
{

}

Tag :: union
{
	ByteArrayTag,
	ByteTag,
	CompoundTag,
	IntTag,
	IntArrayTag,
	ShortTag,
	StringTag,
	EndTag,
	NumericTag,
	LongTag,
	LongArrayTag,
	ListTag,
	FloatTag,
	DoubleTag,
	CollectionTag,
}

Tag_write :: proc(this: ^Tag, data_out: j_io.File)
{
	#partial switch t in this {
		case CompoundTag:
		/*for k, v in this.tags {
			Tag_write_named_tag(k, v, data_out)
		}*/
	}
}

// @Static
@private
write_named_tag :: proc(name: string, tag: ^Tag, data_out: j_io.File)
{

}