extends Node

const ResourceBundle = Resources.Bundle


enum Upgrades {
	ROBOT_SPEED,
	PLATFORM_SPEED,
	SALVAGER_SPEED,
	SALVAGER_SIZE,
	CRUSHER_SPEED,
	CRUSHER_SIZE,
	SHREDDER_SPEED,
	SHREDDER_SIZE,
	EXTRACTOR_SPEED,
	EXTRACTOR_SIZE,
}

const TITLE: int = 0
const UNIT: int = 1
const GET_CURRENT: int = 2
const GET_NEXT: int = 3
const GET_COST: int = 4
const INCREASE: int = 5

func bundle_all(x: int, y: int = -1) -> ResourceBundle:
	if y == -1:
		return ResourceBundle.new(x, x, x, x)
	else:
		return ResourceBundle.new(x, y, y, y)

#region mover speeds
var _robot_speeds: Array = [
	[10.0, bundle_all(5, 0)],
	[9.0, bundle_all(10, 0)],
	[8.0, bundle_all(20, 0)],
	[7.0, bundle_all(30, 0)],
	[6.0, bundle_all(40, 5)],
	[5.0, bundle_all(50, 10)],
	[4.5, bundle_all(60, 20)],
	[4.0, bundle_all(70, 25)],
	[3.5, bundle_all(80, 50)],
	[3.0, bundle_all(90, 75)],
	[2.5, bundle_all(100, 100)],
	[2.0, null],
]
signal mover_speed_changed(prev: float, curr: float)

@onready var _robot_speed_state: Array = [_robot_speeds, 0, mover_speed_changed]
@onready var _robot_speed_upgrade: Array = [
	"Mover Speed",
	"s",
	get_v.bind(_robot_speed_state),
	get_next_v.bind(_robot_speed_state),
	get_cost_v.bind(_robot_speed_state),
	increase_v.bind(_robot_speed_state),
]

func get_mover_speed() -> float:
	return _robot_speed_upgrade[GET_CURRENT].call()
#endregion

#region mover count
var _platform_speeds: Array = [
	[1, bundle_all(1)],
	[2, bundle_all(10)],
	[3, bundle_all(25)],
	[4, null],
]
signal mover_count_changed(prev: float, curr: float)

@onready var _platform_speed_state: Array = [_platform_speeds, 0, mover_count_changed]
@onready var _platform_speed_upgrade: Array = [
	"Mover Count",
	"s",
	get_v.bind(_platform_speed_state),
	get_next_v.bind(_platform_speed_state),
	get_cost_v.bind(_platform_speed_state),
	increase_v.bind(_platform_speed_state),
]

func get_mover_count() -> int:
	return int(_platform_speed_upgrade[GET_CURRENT].call())
#endregion

#region salvager speed
signal salvager_speed_changed(prev: float, curr: float)

@onready var _salvager_speed_state = [_recycler_speeds(0,0,0), 0, salvager_speed_changed]
@onready var _salvager_speed_upgrade: Array = [
	"Salvage Speed",
	"s",
	get_v.bind(_salvager_speed_state),
	get_next_v.bind(_salvager_speed_state),
	get_cost_v.bind(_salvager_speed_state),
	increase_v.bind(_salvager_speed_state),
]

func get_salvager_speed() -> float:
	return _salvager_speed_upgrade[GET_CURRENT].call()
#endregion

#region salvager size
var _salvager_size: Array = [
	[1.0, bundle_all(1, 0)],
	[2.0, bundle_all(5, 0)],
	[3.0, bundle_all(10, 0)],
	[4.0, bundle_all(15, 0)],
	[5.0, bundle_all(20, 5)],
	[6.0, bundle_all(40, 10)],
	[7.0, bundle_all(60, 20)],
	[8.0, bundle_all(80, 30)],
	[9.0, bundle_all(100, 40)],
	[10.0, null],
]
signal salvager_size_changed(prev: float, curr: float)

@onready var _salvager_size_state = [_salvager_size, 0, salvager_size_changed]
@onready var _salvager_size_upgrade: Array = [
	"Salvage Count",
	"x",
	get_v.bind(_salvager_size_state),
	get_next_v.bind(_salvager_size_state),
	get_cost_v.bind(_salvager_size_state),
	increase_v.bind(_salvager_size_state),
]

func get_salvager_size() -> float:
	return _salvager_size_upgrade[GET_CURRENT].call()
#endregion

func _recycler_speeds(m: int, p: int, c: int) -> Array:
	return [
	[20.0, ResourceBundle.new(1, m * 0, p * 0, c * 0)],
	[15.0, ResourceBundle.new(3, m * 0, p * 0, c * 0)],
	[10.0, ResourceBundle.new(6, m * 0, p * 0, c * 0)],
	[9.0, ResourceBundle.new(10, m * 1, p * 1, c * 1)],
	[8.0, ResourceBundle.new(15, m * 2, p * 2, c * 2)],
	[7.0, ResourceBundle.new(20, m * 5, p * 5, c * 5)],
	[6.0, ResourceBundle.new(25, m * 10, p * 10, c * 10)],
	[5.0, ResourceBundle.new(30, m * 20, p * 20, c * 20)],
	[4.0, ResourceBundle.new(40, m * 40, p * 40, c * 40)],
	[3.0, ResourceBundle.new(50, m * 50, p * 50, c * 50)],
	[2.5, ResourceBundle.new(60, m * 60, p * 60, c * 60)],
	[2.0, ResourceBundle.new(70, m * 70, p * 70, c * 70)],
	[1.5, ResourceBundle.new(80, m * 80, p * 80, c * 80)],
	[1.0, ResourceBundle.new(90, m * 90, p * 90, c * 90)],
	[0.5, ResourceBundle.new(100, m * 100, p * 100, c * 100)],
	[0.25, null],
]

#region crusher speed
signal crusher_speed_changed(prev: float, curr: float)

@onready var _crusher_speed_state: Array = [_recycler_speeds(1,0,0), 0, crusher_speed_changed]
@onready var _crusher_speed_upgrade: Array = [
	"Crusher Speed",
	"s",
	get_v.bind(_crusher_speed_state),
	get_next_v.bind(_crusher_speed_state),
	get_cost_v.bind(_crusher_speed_state),
	increase_v.bind(_crusher_speed_state),
]

func get_crusher_speed() -> float:
	return _crusher_speed_upgrade[GET_CURRENT].call()
#endregion

#region shredder speed
signal shredder_speed_changed(prev: float, curr: float)

@onready var _shredder_speed_state: Array = [_recycler_speeds(0,1,0), 0, shredder_speed_changed]
@onready var _shredder_speed_upgrade: Array = [
	"Shredder Speed",
	"s",
	get_v.bind(_shredder_speed_state),
	get_next_v.bind(_shredder_speed_state),
	get_cost_v.bind(_shredder_speed_state),
	increase_v.bind(_shredder_speed_state),
]

func get_shredder_speed() -> float:
	return _shredder_speed_upgrade[GET_CURRENT].call()
#endregion

#region extractor speed
signal extractor_speed_changed(prev: float, curr: float)

@onready var _extractor_speed_state = [_recycler_speeds(0,0,1), 0, extractor_speed_changed]
@onready var _extractor_speed_upgrade: Array = [
	"Extractor Speed",
	"s",
	get_v.bind(_extractor_speed_state),
	get_next_v.bind(_extractor_speed_state),
	get_cost_v.bind(_extractor_speed_state),
	increase_v.bind(_extractor_speed_state),
]

func get_extractor_speed() -> float:
	return _extractor_speed_upgrade[GET_CURRENT].call()
#endregion

var _queue_size: Array = [
	[1, bundle_all(5, 1)],
	[2, bundle_all(6, 3)],
	[3, bundle_all(8, 6)],
	[4, bundle_all(11, 10)],
	[5, bundle_all(15, 15)],
	[10, bundle_all(25, 25)],
	[15, bundle_all(50, 50)],
	[20, bundle_all(100, 100)],
	[25, null],
]

#region priority size
signal priority_size_changed(prev: float, curr: float)

@onready var _crusher_size_state: Array = [_queue_size, 0, priority_size_changed]
@onready var _priority_size_upgrade: Array = [
	"Priority Size",
	"x",
	get_v.bind(_crusher_size_state),
	get_next_v.bind(_crusher_size_state),
	get_cost_v.bind(_crusher_size_state),
	increase_v.bind(_crusher_size_state),
]

func get_priority_size() -> float:
	return _priority_size_upgrade[GET_CURRENT].call()
#endregion

#region generic size
signal generic_size_changed(prev: float, curr: float)

@onready var _shredder_size_state: Array = [_queue_size, 0, generic_size_changed]
@onready var _generic_size_upgrade: Array = [
	"Generic Size",
	"x",
	get_v.bind(_shredder_size_state),
	get_next_v.bind(_shredder_size_state),
	get_cost_v.bind(_shredder_size_state),
	increase_v.bind(_shredder_size_state),
]

func get_generic_size() -> float:
	return _generic_size_upgrade[GET_CURRENT].call()
#endregion

#region bonus count
var _bonus_amounts: Array = [
	[1.0, bundle_all(25)],
	[2.0, bundle_all(50)],
	[3.0, bundle_all(75)],
	[4.0, null],
]
signal extractor_size_changed(prev: float, curr: float)

@onready var _bonus_amount_state = [_bonus_amounts, 0, extractor_size_changed]
@onready var _bonus_amount_upgrade: Array = [
	"Bonus Amount",
	"x",
	get_v.bind(_bonus_amount_state),
	get_next_v.bind(_bonus_amount_state),
	get_cost_v.bind(_bonus_amount_state),
	increase_v.bind(_bonus_amount_state),
]

func get_bonus_amount() -> int:
	return int(_bonus_amount_upgrade[GET_CURRENT].call())
#endregion


## returns [title, unit, get_current, get_next, get_cost, increase]
func get_upgrade(t: Upgrades) -> Array[Variant]:
	match t:
		Upgrades.ROBOT_SPEED:
			return _robot_speed_upgrade
		Upgrades.PLATFORM_SPEED:
			return _platform_speed_upgrade
		Upgrades.SALVAGER_SPEED:
			return _salvager_speed_upgrade
		Upgrades.SALVAGER_SIZE:
			return _salvager_size_upgrade
		Upgrades.CRUSHER_SPEED:
			return _crusher_speed_upgrade
		Upgrades.SHREDDER_SPEED:
			return _shredder_speed_upgrade
		Upgrades.EXTRACTOR_SPEED:
			return _extractor_speed_upgrade
		Upgrades.CRUSHER_SIZE:
			return _priority_size_upgrade
		Upgrades.SHREDDER_SIZE:
			return _generic_size_upgrade
		Upgrades.EXTRACTOR_SIZE:
			return _bonus_amount_upgrade
	push_error("upgrade not set up", Upgrades.keys()[t])
	return []

func restart() -> void:
	_robot_speed_state[1] = 0
	_platform_speed_state[1] = 0
	_salvager_speed_state[1] = 0
	_salvager_size_state[1] = 0
	_crusher_speed_state[1] = 0
	_shredder_speed_state[1] = 0
	_extractor_speed_state[1] = 0
	_crusher_size_state[1] = 0
	_shredder_size_state[1] = 0
	_bonus_amount_state[1] = 0


#region meta
func get_v(state: Array) -> float:
	return state[0][state[1]][0]
func get_next_v(state: Array) -> float:
	if state[1] + 1 >= state[0].size():
		return -1
	return state[0][state[1] + 1][0]
func get_cost_v(state: Array) -> Variant:
	return state[0][state[1]][1]
func increase_v(state: Array) -> void:
	if state[1] + 1 == state[0].size():
		return
	state[1] = state[1] + 1
	state[2].emit(state[0][state[1] - 1][0], state[0][state[1]][0])
#endregion
