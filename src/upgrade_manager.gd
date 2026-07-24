extends Node

const ResourceType = Resources.Types
const ResourceBundle = Resources.Bundle

enum Upgrades {
	ROBOT_SPEED,
	SALVAGER_SPEED,
	SALVAGER_PARALLELS,
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
signal robot_speed_changed(prev: float, curr: float)
var _robot_speed_current: int = 0

@onready var _robot_state: Array = [_robot_speeds, _robot_speed_current, robot_speed_changed]

func get_robot_speed() -> float: return get_v(_robot_state)
#endregion

#region salvager speed
var _salvager_speeds: Array = [
	[2.0, ResourceBundle.new(10, 0, 0, 0)],
	[1.5, ResourceBundle.new(10, 0, 0, 0)],
	[1.0, ResourceBundle.new(10, 0, 0, 0)],
	[0.5, ResourceBundle.new(10, 0, 0, 0)],
	[0.25, null],
]
signal salvager_speed_changed(prev: float, curr: float)
var _salvager_speed_current: int = 0

@onready var _salvager_speeds_state: Array = [_salvager_speeds, _salvager_speed_current, salvager_speed_changed]
#endregion

#region salvager parallels
var _salvager_parallels: Array = [
	[1.0, ResourceBundle.new(10, 0, 0, 0)],
	[2.0, ResourceBundle.new(10, 0, 0, 0)],
	[4.0, ResourceBundle.new(10, 0, 0, 0)],
	[8.0, ResourceBundle.new(10, 0, 0, 0)],
	[16.0, null],
]
signal salvager_parallels_changed(prev: float, curr: float)
var _salvager_parallels_current: int = 0

@onready var _salvager_parallels_state: Array = [_salvager_parallels, _salvager_parallels_current, salvager_parallels_changed]
#endregion

## returns [title, unit, get_current, get_next, get_cost, increase]
func get_upgrade(t: Upgrades) -> Array[Variant]:
	match t:
		Upgrades.ROBOT_SPEED:
			return [
				"Robot Speed",
				"s",
				get_v.bind(_robot_state),
				get_next_v.bind(_robot_state),
				get_cost_v.bind(_robot_state),
				increase_v.bind(_robot_state),
			]
		Upgrades.SALVAGER_SPEED:
			return [
				"Salvage Speed",
				"s",
				get_v.bind(_salvager_speeds_state),
				get_next_v.bind(_salvager_speeds_state),
				get_cost_v.bind(_salvager_speeds_state),
				increase_v.bind(_salvager_speeds_state),
			]
		Upgrades.SALVAGER_PARALLELS:
			return [
				"Salvage Rate",
				"x",
				get_v.bind(_salvager_parallels_state),
				get_next_v.bind(_salvager_parallels_state),
				get_cost_v.bind(_salvager_parallels_state),
				increase_v.bind(_salvager_parallels_state),
			]
	push_error("upgrade not set up", Upgrades.keys()[t])
	return []


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
