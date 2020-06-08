These docs are technically nonexhaustive but should contain 99% of the methods available to you, 100% of the ones you need to know.
## User Methods
`user:setPrioritySpeaker(bool)`

`user:setSelfMuted(bool)`

`user:setSelfDeafened(bool)` Can only be used on bot (who is the self)

`user:getURL()`

`user:message(text, ...)` Send a message to that user, applies `string.format()` to `text` if you provide variables `...` afterwards.

`user:kick(reason, ...)`

`user:ban(reason, ...)`

`user:move(channel)`

`user:requestStats(detailed)` Detailed is a boolean, defaults to true. When stats are received they call hook `OnUserStats` and are saved to a user's data, available with `user:getStats()`

`user:getChannel(path)`

`user:getPreviousChannel(path)`

`user:getSession()` Session is the number value of a user's session id. Session changes when they reconnect.

`user:getName()`

`user:getID()` ID remains consistent as long as a user is not reregistered. Returns 0 for unregistered (beware: SuperUser has ID 0 also)

`user:isTalking()`

`user:isMute()` Is server muted?

`user:isDeaf()` Is server deafened?
end

`user:isSuppressed()`

`user:isSelfMute()`

`user:isSelfDeaf()`

`user:getTexture()`

`user:getTextureHash()`

`user:getComment()`

`user:getCommentHash()`

`user:getHash()`

`user:isPrioritySpeaker()`

`user:isRecording()`

`user:getStats()` These stats are set on every call of `requestStats`

`user:getStat(stat, default)`

`user:isMaster()`


## Channel Methods
`channel:get(path)` Get a channel from a text path (much like a file path).  
Use . to refer to the current path (self if used first), .. to go back a channel and ~ to refer to root  
Example: Tree:
>Root  
>--A  
>---AB  
>----ABC  
>----ABD   
>---AC    
>--B  
>---BB

You can get the channel object for ABC with A:get("./AB/ABC")

`users, num = channel:getUsers()` Return table of users and the number of them.

`channel:isUserTalking()` Check to see if anyone is talking within the channel

`channel:getChildren()`

`channel:getClient()`
 
`channel:message(text, ...)` Send a message to that channel, applies `string.format()` to `text` if you provide variables `...` afterwards.

`channel:setDescription(desc)`

`channel:remove()`

`channel:getID()`

`channel:isRoot()`

`channel:getParentID()`

`channel:getParent(noroot)` Return parent channel. If noroot is false (default), return root if you call from root. If noroot is true, return nil if you call from root.

`channel:getName()`

`channel:getPath()`

`channel:getLinks()`

`channel:getDescription()`

`channel:isTemporary()`

`channel:getPosition()`

`channel:getDescriptionHash()`

`channel:getMaxUsers()`

`channel:hasPermission(flag)` Return boolean of if client has permission of flag given in provided channel.

`channel:requestACL()` Get ACL information (sent to hook "OnACL"). Requires "Write ACL" Permission.
