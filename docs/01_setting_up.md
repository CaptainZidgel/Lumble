## Dependencies
These instructions are for Linux.

##### Prerequisites
First we will install the easiest to install dependencies and prerequisites for other dependencies.  
What:  
`sudo apt-get install build-essential cmake luarocks autoreconf libssl-dev lua5.1-dev openssl libopus-dev`  
Why:  
build-essential is for make; make and cmake are for building dependencies; autoreconf, openssl, libssl-dev, lua5.1-dev are dependencies for dependencies; libopus-dev is an actual dependency, luarocks is for installing lua modules.

##### LuaJIT
What:  
Download **at least** [the latest LuaJIT-2.1.0 beta](https://luajit.org/download.html). Enter directory. `make && sudo make install`  
If this is still beta at the time you're reading this, this will NOT automatically install to PATH. It will give you instructions on how to create a symlink to bin (anything in bin is in your PATH).  
Why:  
LuaJIT is the Lua compiler you will be using to run your client.

##### Lua modules
What:   
`sudo luarocks install`  
`luasec`, `protobuf`, `luafilesystem`, `luasocket`  
You must do each command individually, as luarocks does not support multiple installs in one command.  
Why:  
[luasec](https://github.com/brunoos/luasec) is used for interacting with OpenSSL, which is necessary for certificate interactions. The [protobuf](https://github.com/urbanairship/protobuf-lua) module is necessary for using protobufs, the way to communicate with Mumble. [luafilesystem](https://keplerproject.github.io/luafilesystem/) is used for file system interactions, [luasocket](http://w3.impa.br/~diego/software/luasocket/) is the definitive module for sending and receiving packets with sockets.

##### Lua-ev
Libev is a library for creating event loops. Lua-ev is a libev-lua integration.  

Download [libev](http://dist.schmorp.de/libev/)  
>./autogen.sh  
./configure  
make && sudo make install  

Download [lua-ev](https://github.com/brimworks/lua-ev)
>cmake .  
>make && sudo make install

This will not install to a directory where LuaJIT can recognize it as a module, it will probably install to `/usr/local/share/lua/cmod/ev.so` however it should tell you where it installed. Move it to `/usr/local/share/lua/5.1/ev.so` (If that does not work, Lua will tell you it cannot find ev and will list many directories it looked for ev in, pick one that seems appropriate and move `ev.so` there)  

That should be every dependency.

## Starter Code and Execution
##### Getting your bot to join a server
Import the library  
`local mumble = require("lumble")`   
Create a params table, the mode can be client and the protocol sslv23.  
The key and certificate fields will be paths to your .key and .pem files (from the root folder, not the script's location)  
```Lua
local params = {
	mode = "client",
	protocol = "sslv23",
	key = "",
	certificate = ""
}
```
If you need to make a key and pem, you can do so with 
```
openssl req -x509 -newkey rsa:2048 -keyout bot.key -out bot.pem -days 1000 -nodes
```

Connect to the server:
```Lua
local client = mumble.getClient(hostname, port, params)
if not client then return end
client:auth(username, password, tokens)
```
`hostname` is the IP or hostname of the server (string), `port` is the port (number), `params` is the reference to the previously created `params` (table).  
`username` (string) is the username to log in as (if you are registered, you will be forced to the username you registered with).   
`password` (string) is the password for the server you're connecting to (if there is one).   
`tokens` is an array of strings to use as access tokens for different channels in the server.

##### Start Your Bot
Save your bot script as modules/scripts/init.lua  
To run, go to the root directory and execute `luajit client.lua`  
Voila!  

