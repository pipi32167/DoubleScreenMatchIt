require "find"

projName = 'DoubleScreenMatchIt'

# gitPath = '"D:/Program Files (x86)/Git/bin/git.exe"'
# serverPath = 'D:/tests/account-server'

# system "cd #{serverPath} && #{gitPath} pull"

files2 = Find.find('./GamePlist').select { |path| path.end_with?('tmx') or path.end_with?('plist') }

files = files2.collect { |path| elems = path.split('/') ; elems[elems.length-1] }

# p files.length, files

f = File.new "./#{projName}/Resources/copyFiles.dat", File::CREAT|File::TRUNC|File::RDWR, 0644

files.each { |file| f.write "#{file}\n"  }

f.close()

# f = File.new "#{serverPath}/config/copyFiles.txt", File::CREAT|File::TRUNC|File::RDWR, 0644

# files.each { |file| f.write "#{file}\n"  }

# f.close()

# system "cd #{serverPath} && #{gitPath} pull && #{gitPath} add config && #{gitPath} commit config -m\"update\" && #{gitPath} push && pause || pause "
