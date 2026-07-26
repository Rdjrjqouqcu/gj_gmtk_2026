extends Label
class_name ResourceToast
const RESOURCE_TOAST = preload("uid://bldrymxcpn7no")

const GROUP_NAME = "toasts"

const JUNK = preload("uid://iy60qi6wyaih")

const CIRCUIT = preload("uid://r5luvcvw0qje")
const METAL = preload("uid://dh778d2tucsb7")
const PLASTIC = preload("uid://dnf5j6jbi73j1")
const SALVAGE = preload("uid://dfuuwxlbshqge")

static func create(i: int, t: Resources.Types, gpos: Vector2) -> void:
	if i == 0:
		return
	var r: ResourceToast = RESOURCE_TOAST.instantiate()
	r.add_to_group(GROUP_NAME)
	if i > 0:
		r.text = "+%d" % i
	else:
		r.text = "-%d" % abs(i)
	var texture_rect: TextureRect = r.get_node("icon")
	match t:
		-1:
			texture_rect.texture = JUNK
		Resources.Types.SALVAGE:
			texture_rect.texture = SALVAGE
		Resources.Types.METAL:
			texture_rect.texture = METAL
		Resources.Types.PLASTIC:
			texture_rect.texture = PLASTIC
		Resources.Types.CIRCUIT:
			texture_rect.texture = CIRCUIT
		_:
			Log.error("invalid resource type")
			return
	r.global_position = gpos
	(Engine.get_main_loop().root as Node).add_child(r)

static func restart() -> void:
	(Engine.get_main_loop() as SceneTree).call_group(GROUP_NAME, "queue_free")

const DIRECTION: Vector2 = Vector2.UP
const ANGLE_VARIATION: float = deg_to_rad(15)
const DISTANCE: float = 100.0
const DURATION: float = 2.5

var tween: Tween
func _ready() -> void:
	var angle: float = randf_range(-ANGLE_VARIATION, ANGLE_VARIATION)
	var final_offset = DIRECTION.rotated(angle).normalized() * DISTANCE

	tween = get_tree().create_tween().set_parallel()
	tween.tween_property(self, "position", position + final_offset, DURATION)
	#tween.tween_property(self, "position:y", position.y + final_offset.y, DURATION)
	#tween.tween_property(self, "position:x", position.x + final_offset.x, DURATION)
	tween.chain()
	tween.tween_callback(self.queue_free)


func _process(_delta: float) -> void:
	pass
