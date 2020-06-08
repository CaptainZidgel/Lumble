## Hooks
The client handles Mumble events by creating hooks, like this:
```Lua
client:hook("Hook name", "optional descriptor string", function(client, event)
	print("received hook")
end)
```
Client of course is the client.   
The event differs by hook. Below is a description of most of the hooks available to you and their returned events.

## List of Hooks and Corresponding Events
This list is incomplete and in no particular order.  
Legend:
>Hookname - Description  
event = {  
key_1, (type) --description  
key_2, (type) --description  
}

channel and user are lumble metatables for representing mumble channels or users.

OnChannelState - Called when a channel is modified.
```
{
  channel --the channel that changed
}
```
OnPermissionQuery
```
{
  [0] (number)
}
```
OnUserState - Called when a user is modified
```
{
  hash, (string)
  name, (string)
  user,
  user_id (int)
}
```
OnServerSync - Called after the server and the client sync information. The event returned is less important than the hook - it tells you when it is safe to initialize information about channels and users.
```
event = {...} --this event returns the bot's user (client.me)
```
OnServerConfig - Called when the server's config is received
```
{
  allow_html, (bool)
  image_message_length, (int)
  max_bandwidth, (int)
  max_users, (int)
  message_length, (int)
  welcome_text, (string)
}
```
OnACL - Called after the script calls `client:requestACL()` or `channel:requestACL()` (requires Write ACL perms)  
This event implementation is incomplete, the most completed table is groups.
```
{
  acls = {...},
  channel, --the relevant channel for the ACLs (root, if called from client)
  groups = {...}, --a table of the ACL groups, containing lists of users added or inherited (.add, .inherited_members)
  inherit_acls, (bool)
}
groups = {
	group_name = {
    	add = { --array of explictly added users, by user ID
        	1,
            2,
            3
        }
	}
}
```
OnUserStats - Called after the script calls `user:requestStats()`
```
{
  address, (string)
  bandwidth, (int)
  celt_versions = {...},
  certificates = {...},
  from_client = {...},
  from_server = {...},
  idlesecs, (int)
  onlinesecs, (int)
  opus, (bool)
  strong_certificate, (int)
  tcp_packets, (int)
  tcp_ping_avg, (int)
  tcp_ping_var, (int)
  udp_packets, (int)
  udp_ping_avg, (int)
  udp_ping_var, (int)
  user,
  version = {...}
}
```
OnUserRemove - Called when a user leaves the server voluntarily or is kicked or banned.
```
{
  actor, (user) --person responsible for the user leaving (if kick or ban)
  ban, (boolean) --true if ban, false if kick, nil if user left voluntarily
  reason, (string)
  user, --the user leaving
}
```

OnUserConnected - Called when a user connects to the server
```
{
  hash, string
  name, string
  suppress, bool
  user, lumble user
  user_id, int
}
```
OnUserChannel - Called when a user changes channel
```
{
  actor, (user) --the person responsible for moving the user, if there is one
  channel, (channel) --the channel moved to
  channel_prev, (channel) --the channel moved from
  user, (user) --the person moving
}
```
OnTextMessage - Called when receiving a non-command text message
```
{
  actor, (user)
  message, (string)
  users, (table) --users who will see the message
}
```

## Commands
Lumble contains default methods for command templates.  
Commands are called when receiving a message that starts with `!` or `/` (these messages do not call the OnTextMessage hook).
If you wish to create your own command parsing methods, you must disable the default parsing function in `modules/lumble/client/init.lua` in the function `client:onTextMessage`  
Commands can be added like this:
```Lua
client:addCommand("cmd_name", function(client, user, cmd, args)
	--do stuff here
end)
```
Arguments are separated by spaces or quotations marks. Example:  
```Lua
client:addCommand("print_args", function(client, user, cmd, args)
	print(cmd.name .. " called by user " .. user:getName())
    print(args[1])
    print(args[3])
end)
```
Sent in chat: `!print_args "a b" "c" d "e"`  
Output:
```
!print_args called by user SuperUser
a b
d

```
Sent in chat: `!print_args a b c d`
Output:
```
!print_args called by user SuperUser
a
c
```
You can append `:setMaster()` to the end of the `addCommand()` call to limit command to users with 'master' status.  
You can make users masters by you adding their hashes as keys to a 'masters' table in config.lua (in the root folder) and requiring config in your script.
