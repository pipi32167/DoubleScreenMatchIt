require "find"

beginTime = Time::now
p "begin time: #{beginTime}"

packBySubDir = 
[
	# 'ArtSource/Enemy',
	# 'ArtSource/Character',
]

targetFileInfos = 
[
	# {
	# 	'folder' => 'ArtSource/GameObject',
	# 	'plist' => 'ArtProduction/GameObject/GameObject.plist',
	# 	'ccz' => 'ArtProduction/GameObject/GameObject.pvr.ccz'
	# },

	{
		'folder' => 'ArtSource/UI',
		'plist' => 'ArtProduction/UI/UI.plist',
		'ccz' => 'ArtProduction/UI/UI.pvr.ccz'
	},

]

def haveSubDir(dir)

	Find.find(dir)
	.select { |path| File.directory?(path) and !path.include?('.svn') }
	.length > 0
end

def getTargetFileInfos(dir)

	paths = 
		Find.find(dir)
		.select { |path| 	!path.include?('.svn') and
							File.directory?(path) and
							Find.find(path)
								.select { |path2| path2 != path and 
													File.directory?(path2) and 
													!path2.include?('.svn') }
								.length == 0 }
		.collect { |path| path.slice(path.index(dir) + dir.size + 1, path.size) }
		.uniq()

	sourceFolders = paths

	# p 'sourceFolders', sourceFolders
    
    targetDir = dir.sub('ArtSource', 'ArtProduction')

	targetFileInfo = 
		sourceFolders.collect { |folder| fileName = folder.gsub(/\//, '_'); { 'folder'=> "#{dir}/#{folder}", 'plist'=> "#{targetDir}/#{fileName}.plist", 'ccz'=> "#{targetDir}/#{fileName}.pvr.ccz" }  }

end

def isNeedToPack( info )
    
    if !File.exist?(info['plist'])
        
        return true
    end

	artProductionLastModifedTime = File.mtime(info['plist'])

	artSourceLastModifedTimes = 
		Find.find(info['folder'])
		.select { |path| !File.directory?(path) and !path.include?('.svn')  }
		.collect { |path| File.mtime path }.sort

	artSourceLastModifedTime = artSourceLastModifedTimes[artSourceLastModifedTimes.length-1]

	# p artSourceLastModifedTime
	# p artProductionLastModifedTime

	if artSourceLastModifedTime == nil 

		p "#{info['folder']} is empty"
	end

	return artSourceLastModifedTime > artProductionLastModifedTime
end

packBySubDir.each { |dir| targetFileInfos.push getTargetFileInfos(dir) }

targetFileInfos = targetFileInfos.flatten()
								.select { |info| isNeedToPack info }

# targetFileInfos.each { |info| p info, '' }

targetFileInfos.each { |info| system "
folder='#{info['folder']}'
plist='#{info['plist']}'
ccz='#{info['ccz']}'
echo $folder, $plist, $ccz
/usr/local/bin/TexturePacker   --smart-update \
        --format cocos2d \
        --data $plist \
        --sheet $ccz \
        --algorithm MaxRects \
        --dither-fs-alpha \
        --premultiply-alpha \
        --opt RGBA8888 \
        $folder
" }

endTime = Time::now
p "end time: #{endTime}"
p "total cost time: #{endTime - beginTime} seconds"