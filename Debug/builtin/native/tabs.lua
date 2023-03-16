module(..., package.seeall)

function updateBadge(name, badge)
    helper:updateName_badge(name, badge)
end

function updateIndex(idx, badge)
    helper:updateIndex_badge(idx, badge)
end

function switch(name)
    helper:switchTab(name)
end
