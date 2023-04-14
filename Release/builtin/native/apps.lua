local type = type
local json = require "cjson"

module(..., package.seeall)

function switch(appId, animation, sandbox)
    if type(appId) == "table" then
        return helper:switchApp(appId)
    else
        return helper:switchApp{
            appId = appId,
            animation = animation,
            sandbox = sandbox
        }
    end
end

function switchPage(pageId, animation, sandbox)
    if type(pageId) == "table" then
        return helper:switchPage(pageId)
    else
        return helper:switchPage{
            pageId = pageId,
            animation = animation,
            sandbox = sandbox
        }
    end
end

function push(appId, pageId, useCurrentStack, sandbox)
    if not useCurrentStack then
        useCurrentStack = false
    end

    if type(appId) == "table" then
        return helper:pushPage(appId)
    else
        return helper:pushPage{
            pageId = pageId,
            appId = appId,
            useCurrentStack = useCurrentStack,
            sandbox = sandbox
        }
    end
end

function reloadPage(...)
    return helper:reloadPage(...)
end

function pushNative(name, context, sandbox)
    if type(name) == "table" then
        return helper:pushController(name)
    else
        if type(context) ~= "table" then
            context = {param = context}
        end
        context.name = name
        context.sandbox = sandbox

        return helper:pushController(context)
    end
end

function pop(obj, sandbox)
    if type(obj) == "table" then
        return helper:popApp(obj)
    else
        return helper:popApp{
            appId = obj,
            sandbox = sandbox
        }
    end
end

function popPage(obj, sandbox)
    if type(obj) == "table" then
        return helper:popPage(obj)
    else
        if type(obj) == "boolean" then
            return helper:popPage{
                toTop = obj,
                sandbox = sandbox
            }
        else
            return helper:popPage{
                pageId = obj,
                sandbox = sandbox
            }
        end
    end
end

function remove(appId)
    return helper:removeApp(appId)
end

function install(urlString, appId, existVersion)
    return helper:installApp_withAppId_withExistVersion(urlString, appId, existVersion)
end

function presentModal(obj, sandbox)
    if type(obj) == "table" and (obj.widget or obj.model) then
        helper:presentModal(obj)
    else
        if obj.qName then
            helper:presentModal{
                model = obj,
                sandbox = sandbox
            }
        else
            helper:presentModal{
                widget = obj,
                sandbox = sandbox
            }
        end
    end
end

function dismissModal()
    helper:dismissModal()
end
