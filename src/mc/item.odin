package mc
import global "mco:odin/global"

AsItemProc :: #type proc(this: rawptr) -> (^Item)
ItemLike :: struct { as_item: AsItemProc }
Item :: struct
{
	using icomp: global.InstanceComparable, // for instanceof comparisons
	using item_like: ItemLike,

	max_damage: int,
}

Item_init_props :: proc(this: ^Item, props: ^Item_Properties)
{
	/*this.category = p_41383_.category;
      this.rarity = p_41383_.rarity;
      this.craftingRemainingItem = p_41383_.craftingRemainingItem;
      this.maxDamage = p_41383_.maxDamage;
      this.maxStackSize = p_41383_.maxStackSize;
      this.foodProperties = p_41383_.foodProperties;
      this.isFireResistant = p_41383_.isFireResistant;
      if (SharedConstants.IS_RUNNING_IN_IDE) {
         String s = this.getClass().getSimpleName();
         if (!s.endsWith("Item")) {
            LOGGER.error("Item classes should end with Item and {} doesn't.", (Object)s);
         }
    }*/
}
Item_init :: proc{
	Item_init_props,
}

Item_can_be_depleted :: proc(this: ^Item) -> (bool)
{
	return this.max_damage > 0
}

Item_Properties :: struct
{
	max_stack_size: int, // @Default (64)
	max_damage: int,
}

Item_Properties_init :: proc(this: ^Item_Properties)
{
	this.max_stack_size = 64
}

Item_Properties_new_instance :: #force_inline proc() -> (this: ^Item_Properties)
{
	this = new(Item_Properties)
	Item_Properties_init(this)
	return
}

AirItem :: struct
{
	using item: Item,
	block: Block,
}

AirItem_init :: proc(this: ^AirItem, block: ^Block, props: ^Item_Properties)
{
	Item_init(&(this.item), props)
	this.block = block^
}

ItemStack_EMPTY: ^ItemStack
ItemStack :: struct
{
	count: int,
	pop_time: int,
	empty_cache_flag: bool,

	item: ^Item,
}

ItemStack_init_item :: proc(this: ^ItemStack, item_like: ^ItemLike)
{

}
ItemStack_init_item_count :: proc(this: ^ItemStack, item_like: ^ItemLike, count: int)
{
	this.item = nil if item_like == nil else item_like.as_item((rawptr)(item_like))
	this.count = count
	if this.item != nil && Item_can_be_depleted(this.item) {
		ItemStack_set_dmg_value(this, ItemStack_get_dmg_value(this))
	}

	ItemStack_update_empty_cache_flag(this)
}
ItemStack_init :: proc{
	ItemStack_init_item,
	ItemStack_init_item_count,
}

ItemStack_get_item :: proc(this: ^ItemStack) -> (^Item)
{
	return nil
}

// IMPL
ItemStack_get_or_create_tag :: proc(this: ^ItemStack) -> (^CompoundTag)
{
	return nil
}

// IMPL
ItemStack_get_dmg_value :: proc(this: ^ItemStack) -> (int)
{
	return 1
}

ItemStack_set_dmg_value :: proc(this: ^ItemStack, val: int)
{

}

ItemStack_update_empty_cache_flag :: proc(this: ^ItemStack)
{
	this.empty_cache_flag = false // ???
	this.empty_cache_flag = ItemStack_is_empty(this)
}

ItemStack_is_item :: #force_inline proc(this: ^ItemStack, i: ^Item) -> (bool)
{
	return this.item == i
}
ItemStack_is :: proc{
	ItemStack_is_item,
}

ItemStack_is_empty :: proc(this: ^ItemStack) -> (bool)
{
	if this == ItemStack_EMPTY {
		return true
	} else if ItemStack_get_item(this) != nil && !ItemStack_is_item(this, Items_get(.Air)) {
		return this.count <= 0
	} else {
		return true
	}
}

/*
ITEMS DATABASE
*/
Items :: enum
{
	Air,
	Stone,
	Granite,
	PolishedGranite,
	Diorite,
	PolishedDiorite,
	Andesite,
	PolishedAndesite,
	Deepslate,
	CobbledDeepslate,
	PolishedDeepslate,
	Calcite,
	Tuff,
	DripstoneBlock,
	GrassBlock,
	Dir,
	CoarseDirt,
	Podzol,
	RootedDirt,
	Mud,
	CrimsonNylium,
	WarpedNylium,
	Cobblestone,
	OakPlanks,
}

ItemsValue :: Item
ItemsValues := [Items]^ItemsValue{}

Items_get :: #force_inline proc(key: Items) -> (^Item)
{
	return ItemsValues[key]
}

// @Protected
// @Static
@private
register_block_block_item :: proc(block: ^Block, item: ^Item) -> (^Item)
{
	// return register_item_resloc_item()
	return nil
}

@private
register_block :: proc{
	register_block_block_item,
}

Items_INIT :: proc()
{
	ItemStack_EMPTY = new(ItemStack)
	ItemStack_init(ItemStack_EMPTY, (^Item)(nil))

	//ItemsValues[.Air] = register_block(.Air, AirItem_new_instance(Blocks_get(.Air), Item_Properties_new_instance()))
}