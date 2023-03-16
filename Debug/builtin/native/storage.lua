module(..., package.seeall)

function load(key, scope)
    return helper:load_scope(key, scope)
end

-- value should not be any complex value
function save(key, value, scope, timeout)
    if timeout and timeout > 0 then
        helper:save_value_scope_timeout(key, value, scope, timeout)
    else
        helper:save_value_scope(key, value, scope)
    end
end
