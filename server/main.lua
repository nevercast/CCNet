os.loadAPI("http")

-- Root of the repository
local REPO_ROOT = "https://raw.github.com/nevercast/CCNet/master"

-- URL for the Packages list
local URL_PACKAGES = REPO_ROOT . "/PACKAGES"
-- Local cache of each package
-- Stored has name:version, ...
local packages = {}

-- Download lines from a url
local download = function(url)
    -- Use http api to get package list
    response = http.get(url)
    -- If the response is invalid, return nil
    if response == nil then
      return nil
    end
    -- Create empty array
    responseLines = {}
    local line = nil
    -- While the response has lines, insert them in to the list
    while ( line = response.readLine() ) ~= nil do
      table.insert(responseLines, line)
    end
    -- Close resources
    response.close()
    return responseLines
  end

-- Split string by Delimiter 
local splitByDelim = function(inputstr, sep)
    -- table
    t={}
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
      table.insert(t, str)
    end
    -- return result
    return t
  end


-- Get package list from the repo and return it as an array
local loadPackages = function()
    return download(URL_PACKAGES)
  end
  
-- Convert a string to a version table
local convertToVersion = function(versionString)
  local versionTable = splitByDelim(versionString, "\.")
  version = {}
  version["major"] = tonumber(versionTable[1])
  version["minor"] = tonumber(versionTable[2])
  version["revision"] = tonumber(versionTable[3])
  version["build"] = tonumber(versionTable[4])
  return version
  end

-- Returns true if the remote version is newer than the currentVersion
local isVersionNewer = function(currentVersion, remoteVersion)
    current = convertToVersion(currentVersion)
    remote = convertToVersion(remoteVersion)
    if remote.major > current.major then
      return true
    elseif remote.major == curent.major then
      if remote.minor > current.minor then
        return true
      elseif remote.minor == current.minor then
        if remote.revision > current.revision then
          return true
        elseif remote.revision == current.revision then
          if remote.build > current.build then
            return true
          end
        end
      end
    end    
    return false
  end
  
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
