LUA53 = ./lua-5.3.0-work2

lua: $(LUA53)/src
	make -C $(LUA53) linux
	ln -s $(LUA53)/src/lua ./lua5.3
