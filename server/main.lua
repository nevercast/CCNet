os.loadAPI("repoapi")

local packages = {}

-- If a new version is available, return true
local isNewVersionAvailable = function(packagePath)
    url = REPO_ROOT . packagePath . "/VERSION"
    name, versionString = unpack(download(url))
    if(packages[name] ~= nil) then
      currentVersion = packages[name]
      return isVersionNewer(currentVersion, versionString)
    else
      return true
    end    
  end
