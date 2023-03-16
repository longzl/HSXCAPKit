module(..., package.seeall)

function curl(method, headers, url, body)
    return helper:curl_withHeaders_withURLString_withBody(method, headers, url, body)
end

function apost(route, value, id)
    return helper:asyncPostRoute_withValue_withId(route, value, id)
end

function download(urlString, path)
    return helper:download_toPath(urlString, path)
end

function unzipURL(urlString, path, withOutCache)
    if not withOutCache then
        withOutCache = false
    end
    return helper:unzip_toPath_withOutCache(urlString, path, withOutCache)
end
