 
import bpy
import os
from os import walk

walk = walk(".")

bpy.ops.object.select_all(action="SELECT")
bpy.ops.collection.objects_remove_all()

absPath = os.path.abspath(".")

for (dirpath, dirnames, filenames) in walk:
	for file in filenames:
		if ( dirpath.endswith("/fbx") or dirpath.endswith("\\fbx") ): 
			continue
		if ( file.endswith('.fbx') or file.endswith('.obj') ):
			os.chdir(dirpath)
			resultFilePath = file
			
			if (file.endswith('.fbx')):
				bpy.ops.import_scene.fbx(filepath=file)
			if (file.endswith('.obj')):
				bpy.ops.import_scene.obj(filepath=file) 
				resultFilePath = file.replace(".obj", ".fbx")

			if not os.path.isdir("fbx"):
				os.mkdir("fbx")
			bpy.ops.export_scene.fbx(filepath="fbx/" + resultFilePath.replace("-", "_") )
			bpy.ops.collection.objects_remove_all()
			os.chdir(absPath)

