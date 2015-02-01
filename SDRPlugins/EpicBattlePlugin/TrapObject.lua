TrapObject = class();

-- TrapObject are information on a trap the player has put down. They have the following variables:

-- TrapObject.name -- the trap name (Bear/caltrop/tripwire)

-- TrapObject.endTime -- the time at which the trap will 'die'

function TrapObject:Constructor(name, startTime)
	self.name = name;
	self.endTime = startTime + 180;
end