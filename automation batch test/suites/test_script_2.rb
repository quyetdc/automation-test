#  Created by quyetdc on 2014-03-10.
#  Copyright 2014 quyetdc. All rights reserved.

before do
		
end

=========================================================

pair 1 -- [
	{
		select * from 
			conversation_61_logs
			where id between 1 and 1000
	}

	{
		select * from conversation_61_logs 
		where id between 1 and 1000
	}
]


pair 2 -- [
	{
		select conversation_event_id as result from 
			conversation_61_logs 
			where id = 1
	}

	{
		select track_type as result from conversation_61_logs 
		where id = 1
	}
]


pair 3 -- [
	{
		select count(id) from conversation_61_logs 
		where id between 1 and 10000
	}

	{
		select count(id) from conversation_61_logs 
		where id between 1 and 1000
	}
]

=========================================================

after do

end
