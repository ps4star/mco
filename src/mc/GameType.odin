package mc
import "core:fmt"
import "core:strings"

GameType_SURVIVAL := GameType_new(0, "survival")
GameType_CREATIVE := GameType_new(1, "creative")
GameType_ADVENTURE := GameType_new(2, "adventure")
GameType_SPECTATOR := GameType_new(3, "spectator")

GameType_DEFAULT_MODE := GameType_SURVIVAL
GameType_NOT_SET :: -1
GameType :: struct {
	id: int,
	name: string,
	short_name: ^Component,
	long_name: ^Component,
}

GameType_new :: proc(id: int, name: string) -> (this: GameType) // @LingeringAlloc
{
	this.id = id
	this.name = name
	this.short_name = Component_translatable(strings.concatenate({ "selectWorld.gameMode.", name }))
	this.long_name = Component_translatable(strings.concatenate({ "gameMode.", name }))
	return
}

GameType_get_id :: proc(this: ^GameType) -> (int)
{
	return this.id
}

// TODO
GameType_get_long_display_name :: proc(this: ^GameType) -> (^Component)
{
	return nil
}

GameType_is_creative :: proc(this: ^GameType) -> (bool)
{
	return this.id == GameType_CREATIVE.id
}