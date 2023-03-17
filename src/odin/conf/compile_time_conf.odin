package odin_conf
import "core:mem"

// This pkg/file contains additional stuff not related to the base MCO
// It's mostly just compile-time configs
PANIC_MSG :: "FATAL :: One or more -define compile flags has an invalid value :: "

// Typedefs
YesNoType :: bool
IntType :: int
FloatType :: f64
PathType :: string

RngAlgType :: string

YES : YesNoType : true
NO : YesNoType : false

RNG_WH :: "WICHMANN_HILL"
RNG_XS :: "XORSHIFT128PLUS"

// Global
DEBUG : YesNoType : #config(DEBUG, YES)

// Testing/"which branch of main()"
ActionType :: string
ACTION_MINECRAFT : ActionType : "minecraft"
ACTION_MEMTEST : ActionType : "memtest"
ACTION : ActionType : #config(ACTION, ACTION_MINECRAFT)

// Math
USE_NATIVE_UUID : YesNoType : #config(USE_NATIVE_UUID, NO)
RNG_ALGORITHM : RngAlgType : #config(RNG_ALGORITHM, RNG_XS)
FLOAT_EQUIV_TOLERANCE : FloatType : #config(FLOAT_EQUIV_TOLERANCE, 0.0005)

// Java Emulation
UNBOUNDED_EXCEPTION_STACK : YesNoType : #config(UNBOUNDED_EXCEPTION_STACK, NO)
EXCEPTION_STACK_SIZE : IntType : #config(EXCEPTION_STACK_SIZE, 128)

RUNNABLE_MAX_ARGS : IntType : #config(RUNNABLE_MAX_ARGS, 8)

// Memory
MemAllocType :: string
MEM_DEBUG : MemAllocType : "debug"
MEM_STD : MemAllocType : "std"
MEM_FAST : MemAllocType : "fast"
ALLOC_TYPE : MemAllocType : #config(ALLOC_TYPE, MEM_STD)

	// (talloc; should be same as MEM_ALLOC unless otherwise specified)
	TAllocType :: MemAllocType
	TALLOC_TYPE : TAllocType : #config(TALLOC_TYPE, ALLOC_TYPE)
	
	TALLOC_SIZE : IntType : #config(TALLOC_SIZE, 512 * mem.Kilobyte) // size of context.temp_allocator's ring buffer
	#assert(TALLOC_SIZE >= 128 * mem.Kilobyte, "TALLOC_SIZE must be at least 128KB!")

DEFAULT_BUFFER_BUILDER_CAP : IntType : 1_024

// Caching/pooling
USE_ALL_CACHING : YesNoType : #config(USE_ALL_CACHING, NO)

	// (more specific)
	//USE_COMPONENT_CACHING : YesNoType : #config(USE_COMPONENT_CACHING, YES) || USE_ALL_CACHING

// Accuracy/corruption
ASSUME_ALL_VALID_JAR_FILES : YesNoType : #config(ASSUME_ALL_VALID_JAR_FILES, NO)
ASSUME_ALL_VALID_APP_FILES : YesNoType : #config(ASSUME_ALL_VALID_APP_FILES, NO)

	// (more specific)
	ASSUME_VALID_JAR_LANGUAGE_JSONS : YesNoType : #config(ASSUME_VALID_JAR_LANGUAGE_JSONS, YES)

// Resource Embedding
EMBED_ALL_JAR_RESOURCES : YesNoType : #config(EMBED_ALL_JAR_RESOURCES, NO)
EMBED_ALL_APP_RESOURCES : YesNoType : #config(EMBED_ALL_APP_RESOURCES, NO)

	// (more specific)
	EMBED_JAR_LANGUAGE_JSONS : YesNoType : #config(EMBED_JAR_LANGUAGE_JSONS, NO) || EMBED_ALL_JAR_RESOURCES

// Root extracted jar dir
JAR_ROOT : PathType : #config(JAR_ROOT, "jar_root")
APP_ROOT : PathType : #config(APP_ROOT, "app_root")