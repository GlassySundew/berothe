#! not done yet

# Base Haxe flags
BASE_FLAGS = \
	-lib hide:git:https://github.com/HeapsIO/hide.git \
	-lib heaps:git:https://github.com/HeapsIO/heaps.git \
	-lib heeps:git:https://github.com/Yanrishatum/heeps.git \
	-lib castle:git:https://github.com/ncannasse/castle.git \
	-lib hxbit:git:https://github.com/GlassySundew/hxbit.git\#new-channels \
	-lib deepnightLibs:git:https://github.com/deepnight/deepnightLibs.git \
	-lib oimophysics:git:https://github.com/GlassySundew/OimoPhysics \
	-lib hlimgui:git:https://github.com/GlassySundew/hlimgui.git\#separatorText \
	-lib format:git:https://github.com/HaxeFoundation/format.git \
	-lib tink_core:git:https://github.com/haxetink/tink_core.git \
	-lib hscript:git:https://github.com/HaxeFoundation/hscript \
	-lib hxToolShed:git:https://github.com/GlassySundew/hxToolShed \
	-lib rxHaxe:git:https://github.com/GlassySundew/RxHaxe \
	-lib min-max:git:https://github.com/skial/min-max \
	-lib domkit:git:https://github.com/HeapsIO/domkit \
	-lib compiletime \
	-lib random \
	-lib seedyrng \
	-lib haxe-concurrent \
	-lib heaps-aseprite \
	-cp src -cp . -cp libs -cp src/shadow \
	-D domkit -D heaps_enable_hl_mp3 -D no-deprecation-warnings -D hscriptPos -D hxbit_visibility \
	--macro Init.setup() \
	plugins.bodyparts_animations.src.HideImports

DEBUG_FLAGS = -debug -D hxbit_report_errors -D dump=pretty

# Targets

.PHONY: 
	all clean \
	c hl_client hl_client_debug hl_client_debug_connect \
	hl_server hl_server_debug hl_server_debug_connect \
	hl_debug_all hl_debug_all_connect hl_debug_display \
	hl_pak_win_all hl_pak_mac_all hl_pak_linux_all hl_pak_server_debug \
	hl_tests

all: hl_client hl_server

# C target (c.hxml)
c:
	haxe $(BASE_FLAGS) \
		-lib hlsdl \
		-D pak=true \
		-D hlc=true $(DEBUG_FLAGS) \ 
		-D hl=true \
		-hl out/main.c \
		-D windowSize=1280x720 \
		-D windowTitle="Total Condemn"
	haxe -hl hxd.fmt.pak.Build.hl -lib heaps -main hxd.fmt.pak.Build && hl hxd.fmt.pak.Build.hl

# HL Client
hl_client:
	haxe $(BASE_FLAGS) -lib hlsdl -D client -main Boot -D windowTitle=Berothe -hl bin/game.hl

hl_client_debug:
	haxe $(BASE_FLAGS) -lib hlsdl -D client -main Boot -D windowTitle=Berothe $(DEBUG_FLAGS) -hl bin/game.hl

hl_client_debug_connect:
	haxe $(BASE_FLAGS) -lib hlsdl -D client -main Boot -D windowTitle=Berothe $(DEBUG_FLAGS) -hl bin/game.hl --connect 64228

# HL Server
hl_server:
	haxe $(BASE_FLAGS) -D server -main ServerBoot -D hl-ver=1.14.0

hl_server_debug:
	haxe $(BASE_FLAGS) -D server -main ServerBoot -D hl-ver=1.14.0 $(DEBUG_FLAGS) -hl bin/server.hl

hl_server_debug_connect:
	haxe $(BASE_FLAGS) -D server -main ServerBoot -D hl-ver=1.14.0 $(DEBUG_FLAGS) -hl bin/server.hl --connect 64229

# HL Debug All
hl_debug_all:
	$(MAKE) hl_client_debug
	$(MAKE) hl_server_debug

hl_debug_all_connect:
	$(MAKE) hl_client_debug_connect
	$(MAKE) hl_server_debug_connect

hl_debug_display:
	haxe $(BASE_FLAGS) 
		-D client \
		-D server \
		$(DEBUG_FLAGS) \

# HL PAK targets
hl_pak_win_all:
	haxe $(BASE_FLAGS) -lib hlsdl -D client -main Boot -D windowTitle=Berothe -hl redist/sdl_win/hlboot.dat -D pak -D windows
	haxe -hl hxd.fmt.pak.Build.hl -lib heaps -main hxd.fmt.pak.Build && hl hxd.fmt.pak.Build.hl -out redist/sdl_win/res -exclude vox,obj,mtl,ttf

hl_pak_mac_all:
	haxe $(BASE_FLAGS) -lib hlsdl -D client -main Boot -D windowTitle=Berothe -hl redist/sdl_mac/hlboot.dat -D pak -D macos
	haxe -hl hxd.fmt.pak.Build.hl -lib heaps -main hxd.fmt.pak.Build && hl hxd.fmt.pak.Build.hl -out redist/sdl_win/res -exclude vox,obj,mtl,ttf

hl_pak_linux_all:
	haxe $(BASE_FLAGS) -lib hlsdl -D client -main Boot -D windowTitle=Berothe -hl redist/sdl_linux/hlboot.dat -D pak -D linux
	haxe $(BASE_FLAGS) -D server -main ServerBoot -D hl-ver=1.14.0 -hl redist/sdl_linux/server.hl -D pak -D linux
	haxe -hl hxd.fmt.pak.Build.hl -lib heaps -main hxd.fmt.pak.Build && hl hxd.fmt.pak.Build.hl -out redist/sdl_win/res -exclude vox,obj,mtl,ttf

hl_pak_server_debug:
	haxe $(BASE_FLAGS) -D server -main ServerBoot -D hl-ver=1.14.0 $(DEBUG_FLAGS) -hl redist/server/server.hl -D pak -D linux -D prod
	haxe -hl hxd.fmt.pak.Build.hl -lib heaps -main hxd.fmt.pak.Build && hl hxd.fmt.pak.Build.hl -out redist/server/res -exclude vox,obj,mtl,ttf

# HL Tests
hl_tests:
	haxe $(BASE_FLAGS) -D server -main game.test.TestLocationServerMem $(DEBUG_FLAGS) -hl bin/test_mem.hl

clean:
	rm -rf bin/* out/* redist/* *.hl *.c *.dat
