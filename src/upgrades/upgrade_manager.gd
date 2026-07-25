extends Node

const ResourceType = Resources.Types
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

#region robot speeds
var _robot_speeds: Array = [
	[10.0, ResourceBundle.new(10, 0, 0, 0)],
	[9.0, ResourceBundle.new(0, 10, 0, 0)],
	[8.0, ResourceBundle.new(0, 0, 10, 0)],
	[7.0, ResourceBundle.new(0, 0, 0, 10)],
	[6.0, ResourceBundle.new(10, 10, 0, 0)],
	[5.0, ResourceBundle.new(10, 0, 10, 0)],
	[4.5, ResourceBundle.new(10, 0, 0, 10)],
	[4.0, ResourceBundle.new(25, 25, 25, 25)],
	[3.5, ResourceBundle.new(50, 50, 50, 50)],
	[3.0, ResourceBundle.new(75, 75, 75, 75)],
	[2.5, ResourceBundle.new(100, 100, 100, 100)],
	[2.0, null],
]
var _robot_speed_current: int = 0
signal robot_speed_changed(prev: float, curr: float)

@onready var _robot_speed_state: Array = [_robot_speeds, _robot_speed_current, robot_speed_changed]
@onready var _robot_speed_upgrade: Array = [
	"Robot Speed",
	"s",
	get_v.bind(_robot_speed_state),
	get_next_v.bind(_robot_speed_state),
	get_cost_v.bind(_robot_speed_state),
	increase_v.bind(_robot_speed_state),
]

func get_robot_speed() -> float:
	return _robot_speed_upgrade[GET_CURRENT].call()
#endregion

#region platform speeds
var _platform_speeds: Array = [
	[10.0, ResourceBundle.new(10, 0, 0, 0)],
	[9.0, ResourceBundle.new(0, 10, 0, 0)],
	[8.0, ResourceBundle.new(0, 0, 10, 0)],
	[7.0, ResourceBundle.new(0, 0, 0, 10)],
	[6.0, ResourceBundle.new(10, 10, 0, 0)],
	[5.0, ResourceBundle.new(10, 0, 10, 0)],
	[4.5, ResourceBundle.new(10, 0, 0, 10)],
	[4.0, ResourceBundle.new(25, 25, 25, 25)],
	[3.5, ResourceBundle.new(50, 50, 50, 50)],
	[3.0, ResourceBundle.new(75, 75, 75, 75)],
	[2.5, ResourceBundle.new(100, 100, 100, 100)],
	[2.0, null],
]
var _platform_speed_current: int = 0
signal platform_speed_changed(prev: float, curr: float)

@onready var _platform_speed_state: Array = [_platform_speeds, _platform_speed_current, platform_speed_changed]
@onready var _platform_speed_upgrade: Array = [
	"Platform Speed",
	"s",
	get_v.bind(_platform_speed_state),
	get_next_v.bind(_platform_speed_state),
	get_cost_v.bind(_platform_speed_state),
	increase_v.bind(_platform_speed_state),
]

func get_platform_speed() -> float:
	return _platform_speed_upgrade[GET_CURRENT].call()
#endregion

#region salvager speed
var _salvager_speeds: Array = [
	[2.0, ResourceBundle.new(10, 0, 0, 0)],
	[1.5, ResourceBundle.new(10, 0, 0, 0)],
	[1.0, ResourceBundle.new(10, 0, 0, 0)],
	[0.5, ResourceBundle.new(10, 0, 0, 0)],
	[0.25, null],
]
var _salvager_speed_current: int = 0
signal salvager_speed_changed(prev: float, curr: float)

@onready var _salvager_speed_upgrade: Array = [
	"Salvage Speed",
	"s",
	get_v.bind([_salvager_speeds, _salvager_speed_current, salvager_speed_changed]),
	get_next_v.bind([_salvager_speeds, _salvager_speed_current, salvager_speed_changed]),
	get_cost_v.bind([_salvager_speeds, _salvager_speed_current, salvager_speed_changed]),
	increase_v.bind([_salvager_speeds, _salvager_speed_current, salvager_speed_changed]),
]

func get_salvager_speed() -> float:
	return _salvager_speed_upgrade[GET_CURRENT].call()
#endregion

#region salvager size
var _salvager_size: Array = [
	[1.0, ResourceBundle.new(10, 0, 0, 0)],
	[2.0, ResourceBundle.new(10, 0, 0, 0)],
	[5.0, ResourceBundle.new(10, 0, 0, 0)],
	[10.0, ResourceBundle.new(10, 0, 0, 0)],
	[20.0, null],
]
var _salvager_size_current: int = 0
signal salvager_size_changed(prev: float, curr: float)

@onready var _salvager_size_state = [_salvager_size, _salvager_size_current, salvager_size_changed]
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

var _recycler_speeds: Array = [
	[2.0, ResourceBundle.new(10, 0, 0, 0)],
	[1.5, ResourceBundle.new(10, 0, 0, 0)],
	[1.0, ResourceBundle.new(10, 0, 0, 0)],
	[0.5, ResourceBundle.new(10, 0, 0, 0)],
	[0.25, null],
]
var _recycler_size: Array = [
	[1.0, ResourceBundle.new(10, 0, 0, 0)],
	[2.0, ResourceBundle.new(10, 0, 0, 0)],
	[5.0, ResourceBundle.new(10, 0, 0, 0)],
	[10.0, ResourceBundle.new(10, 0, 0, 0)],
	[20.0, null],
]

#region crusher speed
var _crusher_speed_current: int = 0
signal crusher_speed_changed(prev: float, curr: float)

@onready var _crusher_speed_state: Array = [_recycler_speeds, _crusher_speed_current, crusher_speed_changed]
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

#region crusher size
var _crusher_size_current: int = 0
signal crusher_size_changed(prev: float, curr: float)

@onready var _crusher_size_state: Array = [_recycler_size, _crusher_size_current, crusher_size_changed]
@onready var _crusher_size_upgrade: Array = [
	"Crusher Size",
	"x",
	get_v.bind(_crusher_size_state),
	get_next_v.bind(_crusher_size_state),
	get_cost_v.bind(_crusher_size_state),
	increase_v.bind(_crusher_size_state),
]

func get_crusher_size() -> float:
	return _crusher_size_upgrade[GET_CURRENT].call()
#endregion

#region shredder speed
var _shredder_speed_current: int = 0
signal shredder_speed_changed(prev: float, curr: float)

@onready var _shredder_speed_state: Array = [_recycler_speeds, _shredder_speed_current, shredder_speed_changed]
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

#region shredder size
var _shredder_size_current: int = 0
signal shredder_size_changed(prev: float, curr: float)

@onready var _shredder_size_state: Array = [_recycler_size, _shredder_size_current, shredder_size_changed]
@onready var _shredder_size_upgrade: Array = [
	"Shredder Size",
	"x",
	get_v.bind(_shredder_size_state),
	get_next_v.bind(_shredder_size_state),
	get_cost_v.bind(_shredder_size_state),
	increase_v.bind(_shredder_size_state),
]

func get_shredder_size() -> float:
	return _shredder_size_upgrade[GET_CURRENT].call()
#endregion

#region extractor speed
var _extractor_speed_current: int = 0
signal extractor_speed_changed(prev: float, curr: float)

@onready var _extractor_speed_state = [_recycler_speeds, _extractor_speed_current, extractor_speed_changed]
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

#region extractor size
var _extractor_size_current: int = 0
signal extractor_size_changed(prev: float, curr: float)

@onready var _extractor_size_state = [_recycler_size, _extractor_size_current, extractor_size_changed]
@onready var _extractor_size_upgrade: Array = [
	"Extractor Size",
	"x",
	get_v.bind(_extractor_size_state),
	get_next_v.bind(_extractor_size_state),
	get_cost_v.bind(_extractor_size_state),
	increase_v.bind(_extractor_size_state),
]

func get_extractor_size() -> float:
	return _extractor_size_upgrade[GET_CURRENT].call()
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
		Upgrades.CRUSHER_SIZE:
			return _crusher_size_upgrade
		Upgrades.SHREDDER_SPEED:
			return _shredder_speed_upgrade
		Upgrades.SHREDDER_SIZE:
			return _shredder_size_upgrade
		Upgrades.EXTRACTOR_SPEED:
			return _extractor_speed_upgrade
		Upgrades.EXTRACTOR_SIZE:
			return _extractor_size_upgrade
	push_error("upgrade not set up", Upgrades.keys()[t])
	return []


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
