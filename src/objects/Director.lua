---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by apple.
--- DateTime: 2018/9/20 下午11:53
---

--- @class Director : Object

Director = Object:extend()

function Director:new(stage)
    self.stage = stage
    self.difficulty = 1
    self.round_duration = 22
    self.round_time = 0
    self.difficulty_to_point = {}
    self.difficulty_to_point[1] = 16
    self.timer = timer
    for i = 2, 1024,4 do
        self.difficulty_to_point[i] = self.difficulty_to_point[i - 1] + 8
        self.difficulty_to_point[i + 1] = self.difficulty_to_point[i]
        self.difficulty_to_point[i + 2] = self.difficulty_to_point[i + 1]/1.5
        self.difficulty_to_point[i + 3] = self.difficulty_to_point[i + 2] * 2
    end

    self.enemy_to_point = {
        ['Rock'] = 1,
        ['Shooter'] = 2,
        ["BigRock"] = 1
    }


    self.enemy_spawn_chance = {
        [1] = chanceList({'BigRock',1}),
        [2] = chanceList({'Rock',8},{'Shooter',4}),
        [3] = chanceList({'Rock',8},{'Shooter',4},{'BigRock',2}),
        [4] = chanceList({'Rock',4},{'Shooter',8},{'BigRock',4}),
    }
    for i = 5, 1024 do
        self.enemy_spawn_chance[i] = chanceList(
                {'Rock',random(2,12)},
                {'Shooter',random(2,12)},
                {'BigRock',random(2,12)})
    end
--- resource spawn
    self.resource_to_point = {
        ['Ammo'] = 1,
        ['Boost'] = 1,
        ['Hp'] = 2,
        ["Sp"] = 4
    }

    self.resource_spawn_chance = {
        [1] = chanceList({'Ammo',1}),
        [2] = chanceList({'Ammo',8},{'Boost',4},{'Hp',4}),
        [3] = chanceList({'Ammo',8},{'Boost',4},{'Hp',8}),
        [4] = chanceList({'Ammo',4},{'Boost',4},{'Hp',8},{'Sp',8}),
    }
    for i = 5, 1024 do
        self.resource_spawn_chance[i] = chanceList(
                {'Ammo',random(2,12)},
                {'Boost',random(2,12)},
                {'Hp',random(2,12)},
                {'Sp',random(2,12)})
    end

    --- attack spawn
    self.attack_to_point = {
    ["Double"]  = 4,
    ['Triple']  = 4,
    ['Rapid']   = 5,
    ['Spread']  = 5,
    ['Back']    = 6,
    ['Side']    = 6,
    ['Blast']   = 7
    }

    local attacks_name = {}
    for k,v in pairs(attacks) do
        table.insert(attacks_name,k)
    end
    self.attack_spawn_chance = {}
    for i = 1, 1024 do
        local attack_index = math.random(1,#attacks_name)
        self.attack_spawn_chance[i] = chanceList(
                {attacks_name[attack_index],random(1,math.floor(i))})
    end

    self:setEnemySpawnForThisRound()
    self:setResourceSpawnForThisRound()
    self:setAttackSpawnForThisRound()
end

function Director:update(dt)
    self.round_time = self.round_time + dt
    if self.round_time > self.round_duration then
        self.round_time = 0
        self.difficulty = self.difficulty + 1
        self:setEnemySpawnForThisRound()
        self:setResourceSpawnForThisRound()
        self:setAttackSpawnForThisRound()
    end
end

function Director:destroy()

end

function Director:setEnemySpawnForThisRound()
    local point = self.difficulty_to_point[self.difficulty]
    --- find enemy
    local enemy_list = {}
    while point > 0 do
        local enemy = self.enemy_spawn_chance[self.difficulty]:next()
        point = point - self.enemy_to_point[enemy]
        table.insert(enemy_list,enemy)
    end
    --- find enemy spawn times
    local enemy_spawn_times = {}
    for i = 1,#enemy_list do
        enemy_spawn_times[i] = random(0,self.round_duration)
    end
    table.sort(enemy_spawn_times,function (a,b) return a < b end)
    --- set spawn enemy timer
    for i = 1,#enemy_spawn_times do
        self.timer:after(enemy_spawn_times[i],function ()
            self.stage.area:addObject(enemy_list[i])
        end)
    end
end

function Director:setResourceSpawnForThisRound()
    local point = self.difficulty_to_point[self.difficulty]
    --- find resource
    local resource_list = {}
    while point > 0 do
        local resource = self.resource_spawn_chance[self.difficulty]:next()
        point = point - self.resource_to_point[resource]
        table.insert(resource_list,resource)
    end
    --- find resource spawn times
    local resource_spawn_times = {}
    for i = 1,#resource_list do
        resource_spawn_times[i] = random(0,self.round_duration)
    end
    table.sort(resource_spawn_times,function (a,b) return a < b end)
    --- set spawn resource timer
    for i = 1,#resource_spawn_times do
        self.timer:after(resource_spawn_times[i],function ()
            current_room.area:addObject(resource_list[i])
        end)
    end
end

function Director:setAttackSpawnForThisRound()
    local point = self.difficulty_to_point[self.difficulty]
    --- find attack
    local attack_list = {}
    while point > 0 do
        local attack = self.attack_spawn_chance[self.difficulty]:next()
        point = point - self.attack_to_point[attack]
        table.insert(attack_list,attack)
    end
    --- find attack spawn times
    local attack_spawn_times = {}
    for i = 1,#attack_list do
        attack_spawn_times[i] = random(0,self.round_duration)
    end
    table.sort(attack_spawn_times,function (a,b) return a < b end)
    --- set spawn attack timer
    for i = 1,#attack_spawn_times do
        self.timer:after(attack_spawn_times[i],function ()
            current_room.area:addObject("Attack",0,0,{name = attack_list[i]})
        end)
    end
end

function Director:destroy()

end