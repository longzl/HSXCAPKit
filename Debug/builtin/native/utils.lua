module(..., package.seeall)

function versionCompare(version1, version2)
    return helper:compareVersion_withVersion_(version1, version2)
end

function tojson(str)
    return helper:tojson(str)
end

function navigateURL(urlString)
    return helper:navigateURL(urlString)
end

function urlencode(str)
    return helper:urlencode(str)
end

function urldecode(str)
    return helper:urldecode(str)
end

function dump(o)
    return helper:dump(o)
end

function registerPush()
    helper:registerPush()
end

function md5String(str)
    local md5 = require "md5"
    local d = md5.new()
    d:update(str)
    return d:digest()
end

function exit(code)
    helper:exit(code)
end

function takePhoto(args)
    return helper:takePhoto(args)
end

function advancedTakePhoto(option)
    if option and type(option) ~= "table" then
        option = nil
    end
    return helper:advancedTakePhoto(option)
end

function editImage(img, opt)
    if opt and type(opt) ~= "table" then
        opt = nil
    end
    return helper:editImage_withOption(img, opt)
end

function requestPushToken()
    helper:registerPush()
end
