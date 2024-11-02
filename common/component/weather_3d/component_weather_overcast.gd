extends Decal
class_name component_weather_overcast

func crawl_cloud(delta, dir, speed):
	if dir == &"south":
		self.position.z += delta * speed
		if self.position.z > self.size.x / 4:
			self.position.z = 0		
	if dir == &"west":
		self.position.x -= delta * speed
		if self.position.x < self.size.x / 4 * -1:
			self.position.x = 0				
	if dir == &"north":
		self.position.z -= delta * speed
		if self.position.z < self.size.x / 4  * -1:
			self.position.z = 0				
	if dir == &"east":
		self.position.x += delta * speed
		if self.position.x > self.size.x / 4:
			self.position.x = 0						
	
func _ready() -> void:
	set_cloud_overcast(4)
func set_cloud_overcast(degree):
	self.albedo_mix  = lerpf(self.albedo_mix, degree, 0.1)
func _process(delta: float) -> void:
	crawl_cloud(delta, &"south", 3.0)
