extends Sprite

#Possible types for projectiles
enum ProjectileType {
	NONE, COMPANY_GOOD, COMPANY_BAD, PLAYER_GOOD, PLAYER_BAD
}

#The current velocity vector of the projectile
var velocity = Vector2()

#The type of the projectile, determines what should happen in collisions
export(ProjectileType) var type

#The other objects which this projectile should ignore
#any overlaps with. For example, the Money projectile
#should not register collisions with the Player's ship
export(PoolStringArray) var ignore_groups = []

#Moves the projectile by its velocity * delta
func _process(delta):
	position += velocity * delta 

#Called when the collision with this projectile and something else is handled
func destroy():
	queue_free()

#Called when this projectile's collider overlaps
#with another collider. If the other collider belongs
#to an object in an ignored group, the function returns.
#Otherwise, this object prints the name of itself and
#the object it collided with. TODO: replace printout
#with an overrideable function to handle collisions.
func _collided(other_area):
	for group in other_area.get_parent().get_groups():
		if group in ignore_groups: return
	$"/root/Game".handle_collision(self, other_area.get_parent())

#Called when the VisibilityNotifier2D reports that
#this projectile has left the screen, at which time
#it should delete itself from the world to save 
#memory and processor time.
func _offscreen():
	queue_free()
