extends RigidBody

export var explosion_force = 1000

func launch(pos, normal):
	add_central_force(normal * explosion_force)
	
	var t = Timer.new() #wait 15 seconds until despawn
	t.set_wait_time(7)
	t.set_one_shot(true)
	self.add_child(t)
	t.start()
	yield(t, "timeout")
	
	print("asdasdasd")
	t.queue_free()
	queue_free()

