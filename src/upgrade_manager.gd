extends Node

const ResourceType = Resources.Types
const ResourceBundle = Resources.Bundle

enum Upgrades {
	ROBOT_SPEED,
}

const TITLE: int = 0
const UNIT: int = 1
const GET_CURRENT: int = 2
const GET_NEXT: int = 3
const GET_COST: int = 4
const INCREASE: int = 5

## returns [title, unit, get_current, get_next, get_cost, increase]
func get_upgrade(t: Upgrades) -> Array[Variant]:
	match t:
		Upgrades.ROBOT_SPEED:
			return [
				"Robot Speed",
				"s",
				get_robot_speed, 
				get_robot_speed_next,
				get_robot_speed_cost,
				robot_speed_increase,
			]
	push_error("upgrade not set up")
	return []


## each val is [value, cost:ResourceBundle]
var _robot_speeds: Array = [
	[10.0, ResourceBundle.new_from_type(10, ResourceType.SALVAGE)],
	[9.0, ResourceBundle.new_from_type(10, ResourceType.METAL)],
	[8.0, ResourceBundle.new_from_type(10, ResourceType.PLASTIC)],
	[7.0, ResourceBundle.new_from_type(10, ResourceType.CIRCUIT)],
	[6.0, ResourceBundle.new_from_type(20, ResourceType.SALVAGE)],
	[5.0, ResourceBundle.new_from_type(20, ResourceType.METAL)],
	[4.5, ResourceBundle.new_from_type(20, ResourceType.PLASTIC)],
	[4.0, ResourceBundle.new_from_type(20, ResourceType.CIRCUIT)],
	[3.5, ResourceBundle.new_from_type(10, ResourceType.SALVAGE)],
	[3.0, ResourceBundle.new_from_type(10, ResourceType.SALVAGE)],
	[2.5, ResourceBundle.new_from_type(10, ResourceType.SALVAGE)],
	[2.0, null],
]
signal robot_speed_changed(prev: float, curr: float)
var _robot_speed_current: int = 0
func get_robot_speed() -> float:
	return _robot_speeds[_robot_speed_current][0]
func get_robot_speed_next() -> float:
	if _robot_speed_current + 1 >= _robot_speeds.size():
		return -1
	return _robot_speeds[_robot_speed_current + 1][0]
## Returns the cost of the next bundle, or null if it's maxed
func get_robot_speed_cost() -> Variant:
	return _robot_speeds[_robot_speed_current][1]
## Does not deduct the upgrade resource costs
func robot_speed_increase() -> void:
	if _robot_speed_current + 1 == _robot_speeds.size():
		return
	_robot_speed_current = _robot_speed_current + 1
	robot_speed_changed.emit(_robot_speeds[_robot_speed_current - 1][0], _robot_speeds[_robot_speed_current][0])
