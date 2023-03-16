module(..., package.seeall)

function callPhone(args)
    helper:phonecall(tostring(args))
end

function smsPhone(args)
    helper:phonesms(args)
end

function isWLAN()
    return helper:isWLAN()
end
