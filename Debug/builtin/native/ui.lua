module(..., package.seeall)

function alert(title, message, ok)
    helper:alertWithTitle_withMessage_withOK_(title, message, ok)
end

function confirm(title, message, ok, cancel)
    return helper:confirmWithTitle_withMessage_withOK_withCancel_(title, message, ok, cancel)
end

function startBusy(ycenter,title)
    helper:startBusy_withTitle(ycenter,title)
end

function stopBusy()
    helper:stopBusy()
end
