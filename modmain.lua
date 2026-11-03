GLOBAL.setmetatable(env, { __index = function(t, k) return GLOBAL.rawget(GLOBAL, k) end })

local EVENT_COUNT = 3
local NEWS_STYLE = "formal"
local NEWS_INTERVAL = 1
local ENABLE_NEGATIVE = false
local ENABLE_NEUTRAL = false
local NEWS_HEADER = "simple"
local ENABLE_WARNING = false
local WARNING_TIME = 60
local ENABLE_NO_REPEAT = false
local REPEAT_LIMIT = 5
local NEWS_LANGUAGE = "zh"

local NEWS_HEADERS = {
    beautiful = {
        top = "════════════════  每日灾难  ════════════════",
        bottom = "════════════════════════════════════════"
    },
    simple = {
        top = "───────────────────────────────────────",
        bottom = "───────────────────────────────────────"
    },
    elegant = {
        top = "━━━━━━━━━━━━━━━━  每日灾难  ━━━━━━━━━━━━━━━━",
        bottom = "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    },
    solemn = {
        top = "■■■■■■■■■■■■■■■■  每日灾难  ■■■■■■■■■■■■■■■■",
        bottom = "■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■"
    }
}

local function GetConfig()
    EVENT_COUNT = GetModConfigData("event_count") or 3
    NEWS_STYLE = GetModConfigData("news_style") or "formal"
    NEWS_INTERVAL = GetModConfigData("news_interval") or 1
    ENABLE_NEGATIVE = GetModConfigData("enable_negative")
    if ENABLE_NEGATIVE == nil then ENABLE_NEGATIVE = false end
    ENABLE_NEUTRAL = GetModConfigData("enable_neutral")
    if ENABLE_NEUTRAL == nil then ENABLE_NEUTRAL = false end
    NEWS_HEADER = GetModConfigData("news_header") or "elegant"
    ENABLE_WARNING = GetModConfigData("enable_warning")
    if ENABLE_WARNING == nil then ENABLE_WARNING = false end
    WARNING_TIME = GetModConfigData("warning_time") or 60
    ENABLE_NO_REPEAT = GetModConfigData("enable_no_repeat")
    if ENABLE_NO_REPEAT == nil then ENABLE_NO_REPEAT = false end
    REPEAT_LIMIT = GetModConfigData("repeat_limit") or 5
    NEWS_LANGUAGE = GetModConfigData("news_language") or "zh"
end

local NEWS_EVENTS = {
    {
        news = {
            formal = "【青蛙雨季】今天会有大量青蛙出现！",
            playful = "【呱呱来袭】青蛙大军从天而降，呱呱呱呱呱！",
            english = "[Frog Rain] A large number of frogs will appear today!"
        },
        effect = function()
            local player = TheSim:FindFirstEntityWithTag("player")
            if player then
                local x, y, z = player.Transform:GetWorldPosition()
                for i = 1, 10 do
                    local frog = SpawnPrefab("frog")
                    if frog then
                        frog.Transform:SetPosition(x + math.random(-20, 20), 0, z + math.random(-20, 20))
                    end
                end
            end
        end,
        event_type = "positive"
    },
    
    {
        news = {
            formal = "【蝴蝶漫舞】今天会有大量蝴蝶出现！",
            playful = "【蝴蝶满天飞】哇！到处都是小蝴蝶，抓蝴蝶抓到眼花缭乱！",
            english = "[Butterfly Dance] A large number of butterflies will appear today!"
        },
        effect = function()
            local player = TheSim:FindFirstEntityWithTag("player")
            if player then
                local x, y, z = player.Transform:GetWorldPosition()
                for i = 1, 15 do
                    local butterfly = SpawnPrefab("butterfly")
                    if butterfly then
                        butterfly.Transform:SetPosition(x + math.random(-15, 15), 0, z + math.random(-15, 15))
                    end
                end
            end
        end,
        event_type = "positive"
    },
    
    {
        news = {
            formal = "【火鸡盛宴】今天火鸡出现数量大幅增加！",
            playful = "【火鸡满地跑】今天到处都是火鸡，抓都抓不完，大丰收！",
            english = "[Turkey Feast] Turkey spawns will increase significantly today!"
        },
        effect = function()
            local player = TheSim:FindFirstEntityWithTag("player")
            if player then
                local x, y, z = player.Transform:GetWorldPosition()
                for i = 1, 12 do
                    local gobbler = SpawnPrefab("perd")
                    if gobbler then
                        gobbler.Transform:SetPosition(x + math.random(-20, 20), 0, z + math.random(-20, 20))
                    end
                end
            end
        end,
        event_type = "positive"
    },
    
    {
        news = {
            formal = "【企鹅聚会】今天企鹅出现数量增加！",
            playful = "【企鹅开会】企鹅们今天开大会，到处都是企鹅蛋！",
            english = "[Penguin Gathering] Penguin spawns will increase today!"
        },
        effect = function()
            local player = TheSim:FindFirstEntityWithTag("player")
            if player then
                local x, y, z = player.Transform:GetWorldPosition()
                for i = 1, 8 do
                    local penguin = SpawnPrefab("penguin")
                    if penguin then
                        penguin.Transform:SetPosition(x + math.random(-20, 20), 0, z + math.random(-20, 20))
                    end
                end
            end
        end,
        event_type = "positive"
    },
    
    {
        news = {
            formal = "【花朵盛开】今天地图上会生成大量花朵！",
            playful = "【花花世界】今天到处都开满了花，美得像花园！",
            english = "[Flowers Blooming] A large number of flowers will spawn on the map today!"
        },
        effect = function()
            local player = TheSim:FindFirstEntityWithTag("player")
            if player then
                local x, y, z = player.Transform:GetWorldPosition()
                for i = 1, 20 do
                    local flower = SpawnPrefab("flower")
                    if flower then
                        flower.Transform:SetPosition(x + math.random(-25, 25), 0, z + math.random(-25, 25))
                    end
                end
            end
        end,
        event_type = "positive"
    },
    
    {
        news = {
            formal = "【燧石富矿】今天地面上会生成更多燧石！",
            playful = "【石头遍地】今天到处都是燧石，捡都捡不完！",
            english = "[Flint Abundance] More flint will spawn on the ground today!"
        },
        effect = function()
            local player = TheSim:FindFirstEntityWithTag("player")
            if player then
                local x, y, z = player.Transform:GetWorldPosition()
                for i = 1, 15 do
                    local flint = SpawnPrefab("flint")
                    if flint then
                        flint.Transform:SetPosition(x + math.random(-30, 30), 0, z + math.random(-30, 30))
                    end
                end
            end
        end,
        event_type = "positive"
    },
    
    {
        news = {
            formal = "【树枝丰收】今天地面上会生成更多树枝！",
            playful = "【树枝满地】今天到处都是树枝，捡到手软！",
            english = "[Twig Harvest] More twigs will spawn on the ground today!"
        },
        effect = function()
            local player = TheSim:FindFirstEntityWithTag("player")
            if player then
                local x, y, z = player.Transform:GetWorldPosition()
                for i = 1, 15 do
                    local twig = SpawnPrefab("twigs")
                    if twig then
                        twig.Transform:SetPosition(x + math.random(-30, 30), 0, z + math.random(-30, 30))
                    end
                end
            end
        end,
        event_type = "positive"
    },
    
    {
        news = {
            formal = "【草木繁盛】今天地面上会生成更多草！",
            playful = "【草草超多】今天到处都是草，采都采不完！",
            english = "[Grass Abundance] More grass will spawn on the ground today!"
        },
        effect = function()
            local player = TheSim:FindFirstEntityWithTag("player")
            if player then
                local x, y, z = player.Transform:GetWorldPosition()
                for i = 1, 15 do
                    local grass = SpawnPrefab("cutgrass")
                    if grass then
                        grass.Transform:SetPosition(x + math.random(-30, 30), 0, z + math.random(-30, 30))
                    end
                end
            end
        end,
        event_type = "positive"
    },
    
    {
        news = {
            formal = "【浆果丰收】今天地面上会生成更多浆果！",
            playful = "【浆果爆棚】今天到处都是浆果，吃都吃不完！",
            english = "[Berry Harvest] More berries will spawn on the ground today!"
        },
        effect = function()
            local player = TheSim:FindFirstEntityWithTag("player")
            if player then
                local x, y, z = player.Transform:GetWorldPosition()
                for i = 1, 12 do
                    local berry = SpawnPrefab("berries")
                    if berry then
                        berry.Transform:SetPosition(x + math.random(-25, 25), 0, z + math.random(-25, 25))
                    end
                end
            end
        end,
        event_type = "positive"
    },
    
    {
        news = {
            formal = "【胡萝卜丰收】今天地面上会生成更多胡萝卜！",
            playful = "【胡萝卜大丰收】今天到处都是胡萝卜，兔兔都吃不完！",
            english = "[Carrot Harvest] More carrots will spawn on the ground today!"
        },
        effect = function()
            local player = TheSim:FindFirstEntityWithTag("player")
            if player then
                local x, y, z = player.Transform:GetWorldPosition()
                for i = 1, 10 do
                    local carrot = SpawnPrefab("carrot")
                    if carrot then
                        carrot.Transform:SetPosition(x + math.random(-25, 25), 0, z + math.random(-25, 25))
                    end
                end
            end
        end,
        event_type = "positive"
    },
    
    {
        news = {
            formal = "【蜜蜂狂欢】今天会有大量蜜蜂飞舞！",
            playful = "【嗡嗡嗡】小蜜蜂今天开派对，到处嗡嗡嗡飞来飞去！",
            english = "[Bee Carnival] A large number of bees will fly around today!"
        },
        effect = function()
            local player = TheSim:FindFirstEntityWithTag("player")
            if player then
                local x, y, z = player.Transform:GetWorldPosition()
                for i = 1, 10 do
                    local bee = SpawnPrefab("bee")
                    if bee then
                        bee.Transform:SetPosition(x + math.random(-15, 15), 0, z + math.random(-15, 15))
                    end
                end
            end
        end,
        event_type = "positive"
    },
    
    {
        news = {
            formal = "【蜘蛛出没】今天蜘蛛活动频繁，小心应对！",
            playful = "【八脚怪来了】蜘蛛们今天组团出门，准备好打蜘蛛啦！",
            english = "[Spider Activity] Spiders are very active today, be careful!"
        },
        effect = function()
            local player = TheSim:FindFirstEntityWithTag("player")
            if player then
                local x, y, z = player.Transform:GetWorldPosition()
                for i = 1, 8 do
                    local spider = SpawnPrefab("spider")
                    if spider then
                        spider.Transform:SetPosition(x + math.random(-20, 20), 0, z + math.random(-20, 20))
                    end
                end
            end
        end,
        event_type = "positive"
    },
    
    {
        news = {
            formal = "【兔子繁殖季】今天兔子数量激增！",
            playful = "【兔兔满地跑】到处都是小兔子，蹦蹦跳跳超可爱！",
            english = "[Rabbit Season] Rabbit population will surge today!"
        },
        effect = function()
            local player = TheSim:FindFirstEntityWithTag("player")
            if player then
                local x, y, z = player.Transform:GetWorldPosition()
                for i = 1, 12 do
                    local rabbit = SpawnPrefab("rabbit")
                    if rabbit then
                        rabbit.Transform:SetPosition(x + math.random(-20, 20), 0, z + math.random(-20, 20))
                    end
                end
            end
        end,
        event_type = "positive"
    },
    
    {
        news = {
            formal = "【鼹鼠活跃日】今天鼹鼠频繁出没！",
            playful = "【鼹鼠挖挖挖】鼹鼠们今天疯狂挖洞，到处都是小土堆！",
            english = "[Mole Activity] Moles will appear frequently today!"
        },
        effect = function()
            local player = TheSim:FindFirstEntityWithTag("player")
            if player then
                local x, y, z = player.Transform:GetWorldPosition()
                for i = 1, 6 do
                    local mole = SpawnPrefab("mole")
                    if mole then
                        mole.Transform:SetPosition(x + math.random(-15, 15), 0, z + math.random(-15, 15))
                    end
                end
            end
        end,
        event_type = "positive"
    },
    
    {
        news = {
            formal = "【黄金时代】今天地面上会出现黄金！",
            playful = "【发财啦】地上到处都是金块，今天要发大财啦！",
            english = "[Golden Age] Gold nuggets will appear on the ground today!"
        },
        effect = function()
            local player = TheSim:FindFirstEntityWithTag("player")
            if player then
                local x, y, z = player.Transform:GetWorldPosition()
                for i = 1, 8 do
                    local gold = SpawnPrefab("goldnugget")
                    if gold then
                        gold.Transform:SetPosition(x + math.random(-30, 30), 0, z + math.random(-30, 30))
                    end
                end
            end
        end,
        event_type = "positive"
    },
    
    {
        news = {
            formal = "【木材富足】今天地面上会出现大量木头！",
            playful = "【木头堆成山】到处都是木头，盖房子的材料够够的！",
            english = "[Lumber Abundance] A large amount of logs will appear on the ground today!"
        },
        effect = function()
            local player = TheSim:FindFirstEntityWithTag("player")
            if player then
                local x, y, z = player.Transform:GetWorldPosition()
                for i = 1, 20 do
                    local log = SpawnPrefab("log")
                    if log then
                        log.Transform:SetPosition(x + math.random(-30, 30), 0, z + math.random(-30, 30))
                    end
                end
            end
        end,
        event_type = "positive"
    },
    
    {
        news = {
            formal = "【岩石遍地】今天地面上会出现大量石头！",
            playful = "【石头大丰收】到处都是石头，建墙建到手软！",
            english = "[Rock Abundance] A large amount of rocks will appear on the ground today!"
        },
        effect = function()
            local player = TheSim:FindFirstEntityWithTag("player")
            if player then
                local x, y, z = player.Transform:GetWorldPosition()
                for i = 1, 15 do
                    local rocks = SpawnPrefab("rocks")
                    if rocks then
                        rocks.Transform:SetPosition(x + math.random(-30, 30), 0, z + math.random(-30, 30))
                    end
                end
            end
        end,
        event_type = "positive"
    },
    
    {
        news = {
            formal = "【蘑菇大爆发】今天会长出大量蘑菇！",
            playful = "【蘑菇满地长】红的绿的蓝的蘑菇，到处都是，采蘑菇啦！",
            english = "[Mushroom Outbreak] A large number of mushrooms will grow today!"
        },
        effect = function()
            local player = TheSim:FindFirstEntityWithTag("player")
            if player then
                local x, y, z = player.Transform:GetWorldPosition()
                local mushrooms = {"red_cap", "green_cap", "blue_cap"}
                for i = 1, 15 do
                    local mushroom = SpawnPrefab(mushrooms[math.random(1, 3)])
                    if mushroom then
                        mushroom.Transform:SetPosition(x + math.random(-25, 25), 0, z + math.random(-25, 25))
                    end
                end
            end
        end,
        event_type = "positive"
    },
    
    {
        news = {
            formal = "【种子丰收】今天地面上会出现大量种子！",
            playful = "【种子满地】到处都是种子，种田种到停不下来！",
            english = "[Seed Harvest] A large amount of seeds will appear on the ground today!"
        },
        effect = function()
            local player = TheSim:FindFirstEntityWithTag("player")
            if player then
                local x, y, z = player.Transform:GetWorldPosition()
                for i = 1, 20 do
                    local seeds = SpawnPrefab("seeds")
                    if seeds then
                        seeds.Transform:SetPosition(x + math.random(-25, 25), 0, z + math.random(-25, 25))
                    end
                end
            end
        end,
        event_type = "positive"
    },
    
    {
        news = {
            formal = "【蜂蜜流淌】今天会出现大量蜂蜜！",
            playful = "【甜蜜蜜】到处都是蜂蜜，甜到心里去啦！",
            english = "[Honey Flow] A large amount of honey will appear today!"
        },
        effect = function()
            local player = TheSim:FindFirstEntityWithTag("player")
            if player then
                local x, y, z = player.Transform:GetWorldPosition()
                for i = 1, 10 do
                    local honey = SpawnPrefab("honey")
                    if honey then
                        honey.Transform:SetPosition(x + math.random(-20, 20), 0, z + math.random(-20, 20))
                    end
                end
            end
        end,
        event_type = "positive"
    },
    
    {
        news = {
            formal = "【肉食盛宴】今天会出现大量肉类！",
            playful = "【肉肉满地】到处都是肉，吃肉吃到饱！",
            english = "[Meat Feast] A large amount of meat will appear today!"
        },
        effect = function()
            local player = TheSim:FindFirstEntityWithTag("player")
            if player then
                local x, y, z = player.Transform:GetWorldPosition()
                local meats = {"meat", "smallmeat", "froglegs", "drumstick"}
                for i = 1, 12 do
                    local meat = SpawnPrefab(meats[math.random(1, 4)])
                    if meat then
                        meat.Transform:SetPosition(x + math.random(-25, 25), 0, z + math.random(-25, 25))
                    end
                end
            end
        end,
        event_type = "positive"
    },
    
    {
        news = {
            formal = "【鸟蛋遍地】今天会出现大量鸟蛋！",
            playful = "【蛋蛋满地】到处都是鸟蛋，煎蛋煮蛋炒蛋随便做！",
            english = "[Bird Eggs Everywhere] A large number of bird eggs will appear today!"
        },
        effect = function()
            local player = TheSim:FindFirstEntityWithTag("player")
            if player then
                local x, y, z = player.Transform:GetWorldPosition()
                for i = 1, 15 do
                    local egg = SpawnPrefab("bird_egg")
                    if egg then
                        egg.Transform:SetPosition(x + math.random(-20, 20), 0, z + math.random(-20, 20))
                    end
                end
            end
        end,
        event_type = "positive"
    },
    
    {
        news = {
            formal = "【曼德拉草现身】今天会出现珍稀的曼德拉草！",
            playful = "【小人参出没】曼德拉草今天到处跑，抓住它发大财！",
            english = "[Mandrake Appearance] Rare mandrakes will appear today!"
        },
        effect = function()
            local player = TheSim:FindFirstEntityWithTag("player")
            if player then
                local x, y, z = player.Transform:GetWorldPosition()
                for i = 1, 3 do
                    local mandrake = SpawnPrefab("mandrake")
                    if mandrake then
                        mandrake.Transform:SetPosition(x + math.random(-20, 20), 0, z + math.random(-20, 20))
                    end
                end
            end
        end,
        event_type = "positive"
    },
    
    {
        news = {
            formal = "【机械零件】今天会出现珍贵的齿轮！",
            playful = "【齿轮满地】到处都是齿轮，机器人都不够用啦！",
            english = "[Mechanical Parts] Precious gears will appear today!"
        },
        effect = function()
            local player = TheSim:FindFirstEntityWithTag("player")
            if player then
                local x, y, z = player.Transform:GetWorldPosition()
                for i = 1, 5 do
                    local gears = SpawnPrefab("gears")
                    if gears then
                        gears.Transform:SetPosition(x + math.random(-25, 25), 0, z + math.random(-25, 25))
                    end
                end
            end
        end,
        event_type = "positive"
    },
    
    {
        news = {
            formal = "【猪皮丰收】今天会出现大量猪皮！",
            playful = "【猪皮满地】到处都是猪皮，做帽子做到手软！",
            english = "[Pigskin Harvest] A large amount of pigskin will appear today!"
        },
        effect = function()
            local player = TheSim:FindFirstEntityWithTag("player")
            if player then
                local x, y, z = player.Transform:GetWorldPosition()
                for i = 1, 8 do
                    local pigskin = SpawnPrefab("pigskin")
                    if pigskin then
                        pigskin.Transform:SetPosition(x + math.random(-20, 20), 0, z + math.random(-20, 20))
                    end
                end
            end
        end,
        event_type = "positive"
    },
    
    {
        news = {
            formal = "【蜘蛛丝飘飘】今天会出现大量蜘蛛丝！",
            playful = "【丝丝满天飞】到处都是蜘蛛丝，做网做到停不下来！",
            english = "[Spider Silk] A large amount of spider silk will appear today!"
        },
        effect = function()
            local player = TheSim:FindFirstEntityWithTag("player")
            if player then
                local x, y, z = player.Transform:GetWorldPosition()
                for i = 1, 15 do
                    local silk = SpawnPrefab("silk")
                    if silk then
                        silk.Transform:SetPosition(x + math.random(-25, 25), 0, z + math.random(-25, 25))
                    end
                end
            end
        end,
        event_type = "positive"
    },
    
    {
        news = {
            formal = "【暗影涌动】今天会出现神秘的噩梦燃料！",
            playful = "【黑黑的东西】到处都是噩梦燃料，暗影装备做起来！",
            english = "[Shadow Surge] Mysterious nightmare fuel will appear today!"
        },
        effect = function()
            local player = TheSim:FindFirstEntityWithTag("player")
            if player then
                local x, y, z = player.Transform:GetWorldPosition()
                for i = 1, 8 do
                    local fuel = SpawnPrefab("nightmarefuel")
                    if fuel then
                        fuel.Transform:SetPosition(x + math.random(-20, 20), 0, z + math.random(-20, 20))
                    end
                end
            end
        end,
        event_type = "positive"
    },
    
    {
        news = {
            formal = "【冰雪降临】今天会出现大量冰块！",
            playful = "【冰冰凉凉】到处都是冰块，做冰箱做到爽！",
            english = "[Ice Age] A large amount of ice will appear today!"
        },
        effect = function()
            local player = TheSim:FindFirstEntityWithTag("player")
            if player then
                local x, y, z = player.Transform:GetWorldPosition()
                for i = 1, 12 do
                    local ice = SpawnPrefab("ice")
                    if ice then
                        ice.Transform:SetPosition(x + math.random(-25, 25), 0, z + math.random(-25, 25))
                    end
                end
            end
        end,
        event_type = "positive"
    },
    
    {
        news = {
            formal = "【松果满地】今天会出现大量松果！",
            playful = "【松果掉不停】到处都是松果，种树种到森林成片！",
            english = "[Pinecone Abundance] A large number of pinecones will appear today!"
        },
        effect = function()
            local player = TheSim:FindFirstEntityWithTag("player")
            if player then
                local x, y, z = player.Transform:GetWorldPosition()
                for i = 1, 15 do
                    local pinecone = SpawnPrefab("pinecone")
                    if pinecone then
                        pinecone.Transform:SetPosition(x + math.random(-25, 25), 0, z + math.random(-25, 25))
                    end
                end
            end
        end,
        event_type = "positive"
    },
    
    {
        news = {
            formal = "【宝石奇迹】今天会出现珍贵的宝石！",
            playful = "【宝石满地捡】红宝石蓝宝石紫宝石，到处都是，发大财啦！",
            english = "[Gem Miracle] Precious gems will appear today!"
        },
        effect = function()
            local player = TheSim:FindFirstEntityWithTag("player")
            if player then
                local x, y, z = player.Transform:GetWorldPosition()
                local gems = {"redgem", "bluegem", "purplegem"}
                for i = 1, 6 do
                    local gem = SpawnPrefab(gems[math.random(1, 3)])
                    if gem then
                        gem.Transform:SetPosition(x + math.random(-25, 25), 0, z + math.random(-25, 25))
                    end
                end
            end
        end,
        event_type = "positive"
    },
    
    {
        news = {
            formal = "【萤火虫之夜】今天晚上会有大量萤火虫出现！",
            playful = "【小灯笼飞呀飞】晚上到处都是萤火虫，亮晶晶的超漂亮！",
            english = "[Firefly Night] A large number of fireflies will appear tonight!"
        },
        effect = function()
            local player = TheSim:FindFirstEntityWithTag("player")
            if player then
                local x, y, z = player.Transform:GetWorldPosition()
                for i = 1, 12 do
                    local firefly = SpawnPrefab("fireflies")
                    if firefly then
                        firefly.Transform:SetPosition(x + math.random(-20, 20), 0, z + math.random(-20, 20))
                    end
                end
            end
        end,
        event_type = "positive"
    },
    
    {
        news = {
            formal = "【高鸟蛋现世】今天会出现珍贵的高鸟蛋！",
            playful = "【大鸟蛋来啦】高鸟蛋出现了，小心高鸟追你哦！",
            english = "[Tallbird Egg] Precious tallbird eggs will appear today!"
        },
        effect = function()
            local player = TheSim:FindFirstEntityWithTag("player")
            if player then
                local x, y, z = player.Transform:GetWorldPosition()
                for i = 1, 3 do
                    local talbirdegg = SpawnPrefab("tallbirdegg")
                    if talbirdegg then
                        talbirdegg.Transform:SetPosition(x + math.random(-25, 25), 0, z + math.random(-25, 25))
                    end
                end
            end
        end,
        event_type = "positive"
    },
    
    {
        news = {
            formal = "【蜂巢丰收】今天会出现蜂巢和蜂窝！",
            playful = "【蜜蜂的家】到处都是蜂巢，小心被蜜蜂蜇哦！",
            english = "[Honeycomb Harvest] Honeycombs will appear today!"
        },
        effect = function()
            local player = TheSim:FindFirstEntityWithTag("player")
            if player then
                local x, y, z = player.Transform:GetWorldPosition()
                for i = 1, 4 do
                    local honeycomb = SpawnPrefab("honeycomb")
                    if honeycomb then
                        honeycomb.Transform:SetPosition(x + math.random(-25, 25), 0, z + math.random(-25, 25))
                    end
                end
            end
        end,
        event_type = "positive"
    },
    
    {
        news = {
            formal = "【怪物肉堆积】今天会出现大量怪物肉！",
            playful = "【黑黑的肉】到处都是怪物肉，喂猪人正好！",
            english = "[Monster Meat] A large amount of monster meat will appear today!"
        },
        effect = function()
            local player = TheSim:FindFirstEntityWithTag("player")
            if player then
                local x, y, z = player.Transform:GetWorldPosition()
                for i = 1, 10 do
                    local monstermeat = SpawnPrefab("monstermeat")
                    if monstermeat then
                        monstermeat.Transform:SetPosition(x + math.random(-25, 25), 0, z + math.random(-25, 25))
                    end
                end
            end
        end,
        event_type = "positive"
    },
    
    {
        news = {
            formal = "【鱼人出没】今天鱼人活动频繁！",
            playful = "【鱼鱼人来了】鱼人们今天组团出门，小心被围攻！",
            english = "[Merm Activity] Merms are very active today!"
        },
        effect = function()
            local player = TheSim:FindFirstEntityWithTag("player")
            if player then
                local x, y, z = player.Transform:GetWorldPosition()
                for i = 1, 6 do
                    local merm = SpawnPrefab("merm")
                    if merm then
                        merm.Transform:SetPosition(x + math.random(-20, 20), 0, z + math.random(-20, 20))
                    end
                end
            end
        end,
        event_type = "negative"
    },
    
    {
        news = {
            formal = "【猪人聚会】今天猪人数量增加！",
            playful = "【猪猪开派对】猪人们今天开大会，可以招募好多帮手啦！",
            english = "[Pig Gathering] Pig population will increase today!"
        },
        effect = function()
            local player = TheSim:FindFirstEntityWithTag("player")
            if player then
                local x, y, z = player.Transform:GetWorldPosition()
                for i = 1, 5 do
                    local pig = SpawnPrefab("pigman")
                    if pig then
                        pig.Transform:SetPosition(x + math.random(-20, 20), 0, z + math.random(-20, 20))
                    end
                end
            end
        end,
        event_type = "positive"
    },
    
    {
        news = {
            formal = "【木炭丰收】今天会出现大量木炭！",
            playful = "【黑黑的炭】到处都是木炭，做火药做到爽！",
            english = "[Charcoal Harvest] A large amount of charcoal will appear today!"
        },
        effect = function()
            local player = TheSim:FindFirstEntityWithTag("player")
            if player then
                local x, y, z = player.Transform:GetWorldPosition()
                for i = 1, 15 do
                    local charcoal = SpawnPrefab("charcoal")
                    if charcoal then
                        charcoal.Transform:SetPosition(x + math.random(-25, 25), 0, z + math.random(-25, 25))
                    end
                end
            end
        end,
        event_type = "positive"
    },
    
    {
        news = {
            formal = "【硝石富矿】今天会出现大量硝石！",
            playful = "【黄色石头】到处都是硝石，做火药做炸药随便做！",
            english = "[Nitre Abundance] A large amount of nitre will appear today!"
        },
        effect = function()
            local player = TheSim:FindFirstEntityWithTag("player")
            if player then
                local x, y, z = player.Transform:GetWorldPosition()
                for i = 1, 12 do
                    local nitre = SpawnPrefab("nitre")
                    if nitre then
                        nitre.Transform:SetPosition(x + math.random(-25, 25), 0, z + math.random(-25, 25))
                    end
                end
            end
        end,
        event_type = "positive"
    },
    
    {
        news = {
            formal = "【芦苇丛生】今天会出现大量芦苇！",
            playful = "【芦苇满地长】到处都是芦苇，做纸做到停不下来！",
            english = "[Reed Growth] A large amount of reeds will appear today!"
        },
        effect = function()
            local player = TheSim:FindFirstEntityWithTag("player")
            if player then
                local x, y, z = player.Transform:GetWorldPosition()
                for i = 1, 10 do
                    local cutreeds = SpawnPrefab("cutreeds")
                    if cutreeds then
                        cutreeds.Transform:SetPosition(x + math.random(-25, 25), 0, z + math.random(-25, 25))
                    end
                end
            end
        end,
        event_type = "positive"
    },
    
    {
        news = {
            formal = "【猎犬来袭】今天会有猎犬群出现，注意防御！",
            playful = "【汪汪队出动】一群凶猛的狗狗要来了，快准备武器！",
            english = "[Hound Attack] Hound packs will appear today, be prepared!"
        },
        effect = function()
            local player = TheSim:FindFirstEntityWithTag("player")
            if player then
                local x, y, z = player.Transform:GetWorldPosition()
                for i = 1, 5 do
                    local hound = SpawnPrefab("hound")
                    if hound then
                        hound.Transform:SetPosition(x + math.random(-15, 15), 0, z + math.random(-15, 15))
                    end
                end
            end
        end,
        event_type = "negative"
    },
    
    {
        news = {
            formal = "【触手危机】今天会有触手从地下冒出！",
            playful = "【章鱼脚出没】小心地上的触手，会把你抓住打！",
            english = "[Tentacle Crisis] Tentacles will emerge from the ground today!"
        },
        effect = function()
            local player = TheSim:FindFirstEntityWithTag("player")
            if player then
                local x, y, z = player.Transform:GetWorldPosition()
                for i = 1, 6 do
                    local tentacle = SpawnPrefab("tentacle")
                    if tentacle then
                        tentacle.Transform:SetPosition(x + math.random(-20, 20), 0, z + math.random(-20, 20))
                    end
                end
            end
        end,
        event_type = "negative"
    },
    
    {
        news = {
            formal = "【蜘蛛战士】今天会出现强大的蜘蛛战士！",
            playful = "【大蜘蛛来了】超大只的蜘蛛战士出现了，快跑啊！",
            english = "[Spider Warriors] Powerful spider warriors will appear today!"
        },
        effect = function()
            local player = TheSim:FindFirstEntityWithTag("player")
            if player then
                local x, y, z = player.Transform:GetWorldPosition()
                for i = 1, 4 do
                    local spiderwarrior = SpawnPrefab("spider_warrior")
                    if spiderwarrior then
                        spiderwarrior.Transform:SetPosition(x + math.random(-20, 20), 0, z + math.random(-20, 20))
                    end
                end
            end
        end,
        event_type = "negative"
    },
    
    {
        news = {
            formal = "【发条骑士】今天会有发条骑士出现！",
            playful = "【机器人来了】叮叮当当的发条骑士要来打架了！",
            english = "[Clockwork Knight] Clockwork knights will appear today!"
        },
        effect = function()
            local player = TheSim:FindFirstEntityWithTag("player")
            if player then
                local x, y, z = player.Transform:GetWorldPosition()
                for i = 1, 3 do
                    local knight = SpawnPrefab("knight")
                    if knight then
                        knight.Transform:SetPosition(x + math.random(-20, 20), 0, z + math.random(-20, 20))
                    end
                end
            end
        end,
        event_type = "negative"
    },
    
    {
        news = {
            formal = "【发条主教】今天会有发条主教出现！",
            playful = "【激光炮来了】会发射激光的主教机器人出现了！",
            english = "[Clockwork Bishop] Clockwork bishops will appear today!"
        },
        effect = function()
            local player = TheSim:FindFirstEntityWithTag("player")
            if player then
                local x, y, z = player.Transform:GetWorldPosition()
                for i = 1, 3 do
                    local bishop = SpawnPrefab("bishop")
                    if bishop then
                        bishop.Transform:SetPosition(x + math.random(-20, 20), 0, z + math.random(-20, 20))
                    end
                end
            end
        end,
        event_type = "negative"
    },
    
    {
        news = {
            formal = "【发条战车】今天会有发条战车出现！",
            playful = "【小坦克来了】会冲撞的战车机器人出现了，小心被撞飞！",
            english = "[Clockwork Rook] Clockwork rooks will appear today!"
        },
        effect = function()
            local player = TheSim:FindFirstEntityWithTag("player")
            if player then
                local x, y, z = player.Transform:GetWorldPosition()
                for i = 1, 2 do
                    local rook = SpawnPrefab("rook")
                    if rook then
                        rook.Transform:SetPosition(x + math.random(-20, 20), 0, z + math.random(-20, 20))
                    end
                end
            end
        end,
        event_type = "negative"
    },
    
    {
        news = {
            formal = "【暗影怪物】今天理智值下降时会出现更多暗影生物！",
            playful = "【小黑人来了】今天暗影怪物特别多，保持理智很重要！",
            english = "[Shadow Creatures] More shadow creatures will appear when sanity drops today!"
        },
        effect = function()
            local player = TheSim:FindFirstEntityWithTag("player")
            if player then
                local x, y, z = player.Transform:GetWorldPosition()
                for i = 1, 4 do
                    local shadowcreature = SpawnPrefab("crawlinghorror")
                    if shadowcreature then
                        shadowcreature.Transform:SetPosition(x + math.random(-15, 15), 0, z + math.random(-15, 15))
                    end
                end
            end
        end,
        event_type = "negative"
    },
    
    {
        news = {
            formal = "【杀人蜂群】今天会有危险的杀人蜂出现！",
            playful = "【红眼蜜蜂】杀人蜂来了，被蜇到会很痛的！",
            english = "[Killer Bees] Dangerous killer bees will appear today!"
        },
        effect = function()
            local player = TheSim:FindFirstEntityWithTag("player")
            if player then
                local x, y, z = player.Transform:GetWorldPosition()
                for i = 1, 8 do
                    local killerbee = SpawnPrefab("killerbee")
                    if killerbee then
                        killerbee.Transform:SetPosition(x + math.random(-15, 15), 0, z + math.random(-15, 15))
                    end
                end
            end
        end,
        event_type = "negative"
    },
    
    {
        news = {
            formal = "【蚊子成灾】今天会有大量蚊子出现！",
            playful = "【嗡嗡嗡吸血】讨厌的蚊子要来吸血了，快躲开！",
            english = "[Mosquito Plague] A large number of mosquitoes will appear today!"
        },
        effect = function()
            local player = TheSim:FindFirstEntityWithTag("player")
            if player then
                local x, y, z = player.Transform:GetWorldPosition()
                for i = 1, 10 do
                    local mosquito = SpawnPrefab("mosquito")
                    if mosquito then
                        mosquito.Transform:SetPosition(x + math.random(-15, 15), 0, z + math.random(-15, 15))
                    end
                end
            end
        end,
        event_type = "negative"
    },
    
    {
        news = {
            formal = "【活木奇迹】今天会出现珍贵的活木！",
            playful = "【会动的木头】活木出现啦，做魔法装备的好材料！",
            english = "[Living Log Miracle] Precious living logs will appear today!"
        },
        effect = function()
            local player = TheSim:FindFirstEntityWithTag("player")
            if player then
                local x, y, z = player.Transform:GetWorldPosition()
                for i = 1, 6 do
                    local livinglog = SpawnPrefab("livinglog")
                    if livinglog then
                        livinglog.Transform:SetPosition(x + math.random(-25, 25), 0, z + math.random(-25, 25))
                    end
                end
            end
        end,
        event_type = "positive"
    },
    
    {
        news = {
            formal = "【紫宝石富矿】今天会出现大量紫宝石！",
            playful = "【紫色闪闪】到处都是紫宝石，做传送杖做到爽！",
            english = "[Purple Gem Abundance] A large amount of purple gems will appear today!"
        },
        effect = function()
            local player = TheSim:FindFirstEntityWithTag("player")
            if player then
                local x, y, z = player.Transform:GetWorldPosition()
                for i = 1, 5 do
                    local purplegem = SpawnPrefab("purplegem")
                    if purplegem then
                        purplegem.Transform:SetPosition(x + math.random(-25, 25), 0, z + math.random(-25, 25))
                    end
                end
            end
        end,
        event_type = "positive"
    },
    
    {
        news = {
            formal = "【红宝石富矿】今天会出现大量红宝石！",
            playful = "【红色闪闪】到处都是红宝石，做火魔杖做到手软！",
            english = "[Red Gem Abundance] A large amount of red gems will appear today!"
        },
        effect = function()
            local player = TheSim:FindFirstEntityWithTag("player")
            if player then
                local x, y, z = player.Transform:GetWorldPosition()
                for i = 1, 5 do
                    local redgem = SpawnPrefab("redgem")
                    if redgem then
                        redgem.Transform:SetPosition(x + math.random(-25, 25), 0, z + math.random(-25, 25))
                    end
                end
            end
        end,
        event_type = "positive"
    },
    
    {
        news = {
            formal = "【蓝宝石富矿】今天会出现大量蓝宝石！",
            playful = "【蓝色闪闪】到处都是蓝宝石，做冰魔杖做到爽！",
            english = "[Blue Gem Abundance] A large amount of blue gems will appear today!"
        },
        effect = function()
            local player = TheSim:FindFirstEntityWithTag("player")
            if player then
                local x, y, z = player.Transform:GetWorldPosition()
                for i = 1, 5 do
                    local bluegem = SpawnPrefab("bluegem")
                    if bluegem then
                        bluegem.Transform:SetPosition(x + math.random(-25, 25), 0, z + math.random(-25, 25))
                    end
                end
            end
        end,
        event_type = "positive"
    },
    
    {
        news = {
            formal = "【牛角丰收】今天会出现大量牛角！",
            playful = "【牛牛的角】到处都是牛角，做牛角帽做到停不下来！",
            english = "[Horn Harvest] A large amount of beefalo horns will appear today!"
        },
        effect = function()
            local player = TheSim:FindFirstEntityWithTag("player")
            if player then
                local x, y, z = player.Transform:GetWorldPosition()
                for i = 1, 6 do
                    local horn = SpawnPrefab("horn")
                    if horn then
                        horn.Transform:SetPosition(x + math.random(-20, 20), 0, z + math.random(-20, 20))
                    end
                end
            end
        end,
        event_type = "positive"
    },
    
    {
        news = {
            formal = "【羽毛飘飘】今天会出现大量羽毛！",
            playful = "【羽毛满天飞】到处都是羽毛，做飞镖做到手软！",
            english = "[Feather Fall] A large amount of feathers will appear today!"
        },
        effect = function()
            local player = TheSim:FindFirstEntityWithTag("player")
            if player then
                local x, y, z = player.Transform:GetWorldPosition()
                for i = 1, 12 do
                    local feather = SpawnPrefab("feather_crow")
                    if feather then
                        feather.Transform:SetPosition(x + math.random(-20, 20), 0, z + math.random(-20, 20))
                    end
                end
            end
        end,
        event_type = "positive"
    },
    
    {
        news = {
            formal = "【蜂王浆现世】今天会出现珍贵的蜂王浆！",
            playful = "【超级蜂蜜】蜂王浆出现了，吃了加好多血！",
            english = "[Royal Jelly] Precious royal jelly will appear today!"
        },
        effect = function()
            local player = TheSim:FindFirstEntityWithTag("player")
            if player then
                local x, y, z = player.Transform:GetWorldPosition()
                for i = 1, 4 do
                    local royaljelly = SpawnPrefab("royaljelly")
                    if royaljelly then
                        royaljelly.Transform:SetPosition(x + math.random(-20, 20), 0, z + math.random(-20, 20))
                    end
                end
            end
        end,
        event_type = "positive"
    },
    
    {
        news = {
            formal = "【大肉丰收】今天会出现大量大肉！",
            playful = "【大块肉肉】到处都是大肉，吃肉吃到撑！",
            english = "[Big Meat Harvest] A large amount of meat will appear today!"
        },
        effect = function()
            local player = TheSim:FindFirstEntityWithTag("player")
            if player then
                local x, y, z = player.Transform:GetWorldPosition()
                for i = 1, 10 do
                    local meat = SpawnPrefab("meat")
                    if meat then
                        meat.Transform:SetPosition(x + math.random(-25, 25), 0, z + math.random(-25, 25))
                    end
                end
            end
        end,
        event_type = "positive"
    },
    
    {
        news = {
            formal = "【鱼类丰收】今天会出现大量鱼肉！",
            playful = "【鱼鱼满地】到处都是鱼，做鱼排做到爽！",
            english = "[Fish Harvest] A large amount of fish will appear today!"
        },
        effect = function()
            local player = TheSim:FindFirstEntityWithTag("player")
            if player then
                local x, y, z = player.Transform:GetWorldPosition()
                for i = 1, 12 do
                    local fish = SpawnPrefab("fish")
                    if fish then
                        fish.Transform:SetPosition(x + math.random(-25, 25), 0, z + math.random(-25, 25))
                    end
                end
            end
        end,
        event_type = "positive"
    },
    
    {
        news = {
            formal = "【鳗鱼盛宴】今天会出现大量鳗鱼！",
            playful = "【长长的鱼】到处都是鳗鱼，做鳗鱼料理超好吃！",
            english = "[Eel Feast] A large amount of eels will appear today!"
        },
        effect = function()
            local player = TheSim:FindFirstEntityWithTag("player")
            if player then
                local x, y, z = player.Transform:GetWorldPosition()
                for i = 1, 8 do
                    local eel = SpawnPrefab("eel")
                    if eel then
                        eel.Transform:SetPosition(x + math.random(-25, 25), 0, z + math.random(-25, 25))
                    end
                end
            end
        end,
        event_type = "positive"
    },
    
    {
        news = {
            formal = "【天气预报】今天天气晴朗，适合外出探险。",
            playful = "【好天气】今天阳光明媚，出门玩耍的好日子！",
            english = "[Weather Forecast] The weather is clear today, perfect for exploration."
        },
        effect = function()
        end,
        event_type = "neutral"
    },
    
    {
        news = {
            formal = "【生态观察】今天森林中的生物活动正常。",
            playful = "【平平无奇】今天一切都很平常，没什么特别的。",
            english = "[Ecological Observation] Creatures in the forest are behaving normally today."
        },
        effect = function()
        end,
        event_type = "neutral"
    },
    
    {
        news = {
            formal = "【地质报告】今天地质活动稳定，无异常现象。",
            playful = "【大地安静】今天地面很安静，没有地震也没有塌陷。",
            english = "[Geological Report] Geological activity is stable today, no anomalies."
        },
        effect = function()
        end,
        event_type = "neutral"
    },
    
    {
        news = {
            formal = "【植被调查】今天植物生长状况良好。",
            playful = "【花花草草】今天的花草树木都长得好好的。",
            english = "[Vegetation Survey] Plant growth is good today."
        },
        effect = function()
        end,
        event_type = "neutral"
    },
    
    {
        news = {
            formal = "【气象观测】今天风力适中，温度适宜。",
            playful = "【不冷不热】今天温度刚刚好，很舒服的一天。",
            english = "[Weather Observation] Wind is moderate and temperature is pleasant today."
        },
        effect = function()
        end,
        event_type = "neutral"
    },
    
    {
        news = {
            formal = "【资源统计】今天各类资源储备充足。",
            playful = "【东西够用】今天资源都够用，不用担心缺东西。",
            english = "[Resource Statistics] All resources are abundant today."
        },
        effect = function()
        end,
        event_type = "neutral"
    },
    
    {
        news = {
            formal = "【安全提示】今天请注意保持警惕，做好防护。",
            playful = "【小心点哦】今天记得带好装备，安全第一！",
            english = "[Safety Reminder] Stay alert and be well-prepared today."
        },
        effect = function()
        end,
        event_type = "neutral"
    },
    
    {
        news = {
            formal = "【环境监测】今天环境指数正常，空气清新。",
            playful = "【空气真好】今天空气很清新，深呼吸感觉真棒！",
            english = "[Environmental Monitoring] Environmental index is normal, air is fresh today."
        },
        effect = function()
        end,
        event_type = "neutral"
    },
    
    {
        news = {
            formal = "【生物多样性】今天观察到多种生物和谐共存。",
            playful = "【动物们很和平】今天动物们都很乖，没有打架。",
            english = "[Biodiversity] Various creatures are coexisting peacefully today."
        },
        effect = function()
        end,
        event_type = "neutral"
    },
    
    {
        news = {
            formal = "【日常提醒】今天是普通的一天，祝您生存愉快。",
            playful = "【平凡的一天】今天没什么特别的，好好享受生活吧！",
            english = "[Daily Reminder] It's an ordinary day, enjoy your survival."
        },
        effect = function()
        end,
        event_type = "neutral"
    },
    
    {
        news = {
            formal = "【精神焕发】今天所有玩家理智值恢复！",
            playful = "【脑子清醒】今天脑子特别清醒，理智值满满！",
            english = "[Mental Clarity] All players' sanity will be restored today!"
        },
        effect = function()
            for i, player in ipairs(AllPlayers) do
                if player and player.components.sanity then
                    player.components.sanity:SetPercent(1)
                end
            end
        end,
        event_type = "positive"
    },
    
    {
        news = {
            formal = "【体力充沛】今天所有玩家饥饿值恢复！",
            playful = "【吃得饱饱】今天肚子吃得饱饱的，不用担心饿肚子！",
            english = "[Full Stomach] All players' hunger will be restored today!"
        },
        effect = function()
            for i, player in ipairs(AllPlayers) do
                if player and player.components.hunger then
                    player.components.hunger:SetPercent(1)
                end
            end
        end,
        event_type = "positive"
    },
    
    {
        news = {
            formal = "【生命旺盛】今天所有玩家生命值恢复！",
            playful = "【满血复活】今天血量满满的，精神抖擞！",
            english = "[Full Health] All players' health will be restored today!"
        },
        effect = function()
            for i, player in ipairs(AllPlayers) do
                if player and player.components.health then
                    player.components.health:SetPercent(1)
                end
            end
        end,
        event_type = "positive"
    },
    
    {
        news = {
            formal = "【白昼延长】今天白天时间延长50%！",
            playful = "【太阳不想下班】今天太阳多待一会儿，白天变长啦！",
            english = "[Extended Daylight] Daytime will be extended by 50% today!"
        },
        effect = function()
            if TheWorld and TheWorld.components.clock then
                local clock = TheWorld.components.clock
                local current_segs = clock:GetTimeLeftInEra()
                clock:SetSegs("day", clock:GetDaySegs() * 1.5)
            end
        end,
        event_type = "positive"
    },
    
    {
        news = {
            formal = "【移动加速】今天所有玩家移动速度提升！",
            playful = "【跑得飞快】今天脚底生风，跑得超级快！",
            english = "[Speed Boost] All players' movement speed will increase today!"
        },
        effect = function()
            for i, player in ipairs(AllPlayers) do
                if player and player.components.locomotor then
                    player.components.locomotor:SetExternalSpeedMultiplier(player, "daily_news_speed", 1.3)
                    player:DoTaskInTime(480, function()
                        if player and player.components.locomotor then
                            player.components.locomotor:RemoveExternalSpeedMultiplier(player, "daily_news_speed")
                        end
                    end)
                end
            end
        end,
        event_type = "positive"
    },
    
    {
        news = {
            formal = "【工作效率】今天所有玩家工作速度提升！",
            playful = "【手速超快】今天手速飞快，干活效率翻倍！",
            english = "[Work Efficiency] All players' work speed will increase today!"
        },
        effect = function()
            for i, player in ipairs(AllPlayers) do
                if player and player.components.worker then
                    player.components.worker:SetAction(player.components.worker.action, 1.5)
                    player:DoTaskInTime(480, function()
                        if player and player.components.worker then
                            player.components.worker:SetAction(player.components.worker.action, 1)
                        end
                    end)
                end
            end
        end,
        event_type = "positive"
    },
    
    {
        news = {
            formal = "【温度适宜】今天所有玩家体温恢复正常！",
            playful = "【不冷不热】今天体温刚刚好，舒服极了！",
            english = "[Temperature Balance] All players' temperature will normalize today!"
        },
        effect = function()
            for i, player in ipairs(AllPlayers) do
                if player and player.components.temperature then
                    player.components.temperature:SetTemperature(35)
                end
            end
        end,
        event_type = "positive"
    },
    
    {
        news = {
            formal = "【潮湿消散】今天所有玩家身上的潮湿度清除！",
            playful = "【瞬间变干】今天身上的水分都蒸发了，干干爽爽！",
            english = "[Dry Off] All players' wetness will be removed today!"
        },
        effect = function()
            for i, player in ipairs(AllPlayers) do
                if player and player.components.moisture then
                    player.components.moisture:SetPercent(0)
                end
            end
        end,
        event_type = "positive"
    },
    
    {
        news = {
            formal = "【经验加成】今天所有玩家获得经验加成！",
            playful = "【升级快快】今天做什么都能学到更多东西！",
            english = "[Experience Boost] All players will gain bonus experience today!"
        },
        effect = function()
            for i, player in ipairs(AllPlayers) do
                if player.components.builder then
                    local old_bonus = player.components.builder.science_bonus or 0
                    player.components.builder.science_bonus = old_bonus + 2
                    player:DoTaskInTime(480, function()
                        if player and player.components.builder then
                            player.components.builder.science_bonus = old_bonus
                        end
                    end)
                end
            end
        end,
        event_type = "positive"
    },
    
    {
        news = {
            formal = "【幸运降临】今天所有玩家幸运值提升！",
            playful = "【好运连连】今天运气爆棚，做什么都顺利！",
            english = "[Lucky Day] All players' luck will increase today!"
        },
        effect = function()
            for i, player in ipairs(AllPlayers) do
                if player.components.combat then
                    player.components.combat.damagemultiplier = (player.components.combat.damagemultiplier or 1) * 1.2
                    player:DoTaskInTime(480, function()
                        if player and player.components.combat then
                            player.components.combat.damagemultiplier = (player.components.combat.damagemultiplier or 1.2) / 1.2
                        end
                    end)
                end
            end
        end,
        event_type = "positive"
    },
    
    {
        news = {
            formal = "【海象出没】今天会有海象猎人出现！",
            playful = "【海象叔叔】海象爸爸带着小海象来打猎啦！",
            english = "[Walrus Hunters] Walrus hunters will appear today!"
        },
        effect = function()
            local player = TheSim:FindFirstEntityWithTag("player")
            if player then
                local x, y, z = player.Transform:GetWorldPosition()
                for i = 1, 2 do
                    local walrus = SpawnPrefab("walrus")
                    if walrus then
                        walrus.Transform:SetPosition(x + math.random(-20, 20), 0, z + math.random(-20, 20))
                    end
                end
            end
        end,
        event_type = "positive"
    },
    
    {
        news = {
            formal = "【牛群迁徙】今天会有大量牛群经过！",
            playful = "【哞哞大军】一大群牛牛路过，可以薅牛毛啦！",
            english = "[Beefalo Migration] A large herd of beefalo will pass by today!"
        },
        effect = function()
            local player = TheSim:FindFirstEntityWithTag("player")
            if player then
                local x, y, z = player.Transform:GetWorldPosition()
                for i = 1, 8 do
                    local beefalo = SpawnPrefab("beefalo")
                    if beefalo then
                        beefalo.Transform:SetPosition(x + math.random(-25, 25), 0, z + math.random(-25, 25))
                    end
                end
            end
        end,
        event_type = "positive"
    },
    
    {
        news = {
            formal = "【考拉聚会】今天会有大量考拉出现！",
            playful = "【树袋熊来了】好多可爱的考拉，抱抱它们！",
            english = "[Koalefant Gathering] A large number of koalefants will appear today!"
        },
        effect = function()
            local player = TheSim:FindFirstEntityWithTag("player")
            if player then
                local x, y, z = player.Transform:GetWorldPosition()
                for i = 1, 6 do
                    local koalefant = SpawnPrefab("koalefant_summer")
                    if koalefant then
                        koalefant.Transform:SetPosition(x + math.random(-25, 25), 0, z + math.random(-25, 25))
                    end
                end
            end
        end,
        event_type = "positive"
    },
    
    {
        news = {
            formal = "【龙蝇幼虫】今天会有龙蝇幼虫出现！",
            playful = "【小火虫虫】小小的龙蝇宝宝到处爬！",
            english = "[Lavae] Dragonfly larvae will appear today!"
        },
        effect = function()
            local player = TheSim:FindFirstEntityWithTag("player")
            if player then
                local x, y, z = player.Transform:GetWorldPosition()
                for i = 1, 8 do
                    local lavae = SpawnPrefab("lavae")
                    if lavae then
                        lavae.Transform:SetPosition(x + math.random(-20, 20), 0, z + math.random(-20, 20))
                    end
                end
            end
        end,
        event_type = "positive"
    },
    
    {
        news = {
            formal = "【鳞片丰收】今天会出现大量鳞片！",
            playful = "【闪亮鳞片】到处都是鳞片，做鳞甲做到爽！",
            english = "[Scale Harvest] A large amount of scales will appear today!"
        },
        effect = function()
            local player = TheSim:FindFirstEntityWithTag("player")
            if player then
                local x, y, z = player.Transform:GetWorldPosition()
                for i = 1, 8 do
                    local scales = SpawnPrefab("dragon_scales")
                    if scales then
                        scales.Transform:SetPosition(x + math.random(-25, 25), 0, z + math.random(-25, 25))
                    end
                end
            end
        end,
        event_type = "positive"
    },
    
    {
        news = {
            formal = "【骨片遍地】今天会出现大量骨片！",
            playful = "【白骨森森】到处都是骨头片，做骨甲做到手软！",
            english = "[Bone Shard Abundance] A large amount of bone shards will appear today!"
        },
        effect = function()
            local player = TheSim:FindFirstEntityWithTag("player")
            if player then
                local x, y, z = player.Transform:GetWorldPosition()
                for i = 1, 12 do
                    local boneshard = SpawnPrefab("boneshard")
                    if boneshard then
                        boneshard.Transform:SetPosition(x + math.random(-25, 25), 0, z + math.random(-25, 25))
                    end
                end
            end
        end,
        event_type = "positive"
    },
    
    {
        news = {
            formal = "【琥珀奇迹】今天会出现珍贵的琥珀！",
            playful = "【金黄琥珀】到处都是琥珀，复活神器材料！",
            english = "[Amber Miracle] Precious yellow amulets will appear today!"
        },
        effect = function()
            local player = TheSim:FindFirstEntityWithTag("player")
            if player then
                local x, y, z = player.Transform:GetWorldPosition()
                for i = 1, 4 do
                    local amber = SpawnPrefab("yellowamulet")
                    if amber then
                        amber.Transform:SetPosition(x + math.random(-20, 20), 0, z + math.random(-20, 20))
                    end
                end
            end
        end,
        event_type = "positive"
    },
    
    {
        news = {
            formal = "【胡须丰收】今天会出现大量胡须！",
            playful = "【毛茸茸】到处都是胡须，做复活石材料够够的！",
            english = "[Beard Hair Harvest] A large amount of beard hair will appear today!"
        },
        effect = function()
            local player = TheSim:FindFirstEntityWithTag("player")
            if player then
                local x, y, z = player.Transform:GetWorldPosition()
                for i = 1, 10 do
                    local beard = SpawnPrefab("beardhair")
                    if beard then
                        beard.Transform:SetPosition(x + math.random(-20, 20), 0, z + math.random(-20, 20))
                    end
                end
            end
        end,
        event_type = "positive"
    },
    
    {
        news = {
            formal = "【粪便堆积】今天会出现大量粪便！",
            playful = "【臭臭满地】到处都是便便，种田肥料超多！",
            english = "[Manure Abundance] A large amount of manure will appear today!"
        },
        effect = function()
            local player = TheSim:FindFirstEntityWithTag("player")
            if player then
                local x, y, z = player.Transform:GetWorldPosition()
                for i = 1, 15 do
                    local poop = SpawnPrefab("poop")
                    if poop then
                        poop.Transform:SetPosition(x + math.random(-25, 25), 0, z + math.random(-25, 25))
                    end
                end
            end
        end,
        event_type = "positive"
    },
    
    {
        news = {
            formal = "【腐烂物堆积】今天会出现大量腐烂物！",
            playful = "【臭烘烘】到处都是腐烂的东西，做肥料正好！",
            english = "[Rot Abundance] A large amount of rot will appear today!"
        },
        effect = function()
            local player = TheSim:FindFirstEntityWithTag("player")
            if player then
                local x, y, z = player.Transform:GetWorldPosition()
                for i = 1, 12 do
                    local rot = SpawnPrefab("spoiled_food")
                    if rot then
                        rot.Transform:SetPosition(x + math.random(-25, 25), 0, z + math.random(-25, 25))
                    end
                end
            end
        end,
        event_type = "positive"
    },
    
    {
        news = {
            formal = "【蜘蛛腺体】今天会出现大量蜘蛛腺体！",
            playful = "【治疗药药】到处都是蜘蛛腺体，治疗包做到爽！",
            english = "[Spider Gland] A large amount of spider glands will appear today!"
        },
        effect = function()
            local player = TheSim:FindFirstEntityWithTag("player")
            if player then
                local x, y, z = player.Transform:GetWorldPosition()
                for i = 1, 12 do
                    local gland = SpawnPrefab("spidergland")
                    if gland then
                        gland.Transform:SetPosition(x + math.random(-25, 25), 0, z + math.random(-25, 25))
                    end
                end
            end
        end,
        event_type = "positive"
    },
    
    {
        news = {
            formal = "【蜘蛛卵现世】今天会出现蜘蛛卵！",
            playful = "【蜘蛛蛋蛋】蜘蛛卵出现了，可以养蜘蛛啦！",
            english = "[Spider Eggs] Spider eggs will appear today!"
        },
        effect = function()
            local player = TheSim:FindFirstEntityWithTag("player")
            if player then
                local x, y, z = player.Transform:GetWorldPosition()
                for i = 1, 3 do
                    local egg = SpawnPrefab("spidereggsack")
                    if egg then
                        egg.Transform:SetPosition(x + math.random(-20, 20), 0, z + math.random(-20, 20))
                    end
                end
            end
        end,
        event_type = "positive"
    },
    
    {
        news = {
            formal = "【蜂刺丰收】今天会出现大量蜂刺！",
            playful = "【尖尖刺刺】到处都是蜂刺，做蜂刺陷阱做到手软！",
            english = "[Stinger Harvest] A large amount of stingers will appear today!"
        },
        effect = function()
            local player = TheSim:FindFirstEntityWithTag("player")
            if player then
                local x, y, z = player.Transform:GetWorldPosition()
                for i = 1, 15 do
                    local stinger = SpawnPrefab("stinger")
                    if stinger then
                        stinger.Transform:SetPosition(x + math.random(-20, 20), 0, z + math.random(-20, 20))
                    end
                end
            end
        end,
        event_type = "positive"
    },
    
    {
        news = {
            formal = "【触手尖刺】今天会出现大量触手尖刺！",
            playful = "【章鱼刺刺】到处都是触手尖刺，做武器做到爽！",
            english = "[Tentacle Spike] A large amount of tentacle spikes will appear today!"
        },
        effect = function()
            local player = TheSim:FindFirstEntityWithTag("player")
            if player then
                local x, y, z = player.Transform:GetWorldPosition()
                for i = 1, 8 do
                    local spike = SpawnPrefab("tentaclespike")
                    if spike then
                        spike.Transform:SetPosition(x + math.random(-25, 25), 0, z + math.random(-25, 25))
                    end
                end
            end
        end,
        event_type = "positive"
    },
    
    {
        news = {
            formal = "【触手皮革】今天会出现大量触手皮！",
            playful = "【滑溜溜皮】到处都是触手皮，做装备做到停不下来！",
            english = "[Tentacle Spots] A large amount of tentacle spots will appear today!"
        },
        effect = function()
            local player = TheSim:FindFirstEntityWithTag("player")
            if player then
                local x, y, z = player.Transform:GetWorldPosition()
                for i = 1, 10 do
                    local skin = SpawnPrefab("tentaclespots")
                    if skin then
                        skin.Transform:SetPosition(x + math.random(-25, 25), 0, z + math.random(-25, 25))
                    end
                end
            end
        end,
        event_type = "positive"
    },
    
    {
        news = {
            formal = "【猎犬牙齿】今天会出现大量猎犬牙！",
            playful = "【尖牙利齿】到处都是狗牙，做吹箭做到爽！",
            english = "[Hound Tooth] A large amount of hound teeth will appear today!"
        },
        effect = function()
            local player = TheSim:FindFirstEntityWithTag("player")
            if player then
                local x, y, z = player.Transform:GetWorldPosition()
                for i = 1, 12 do
                    local tooth = SpawnPrefab("houndstooth")
                    if tooth then
                        tooth.Transform:SetPosition(x + math.random(-20, 20), 0, z + math.random(-20, 20))
                    end
                end
            end
        end,
        event_type = "positive"
    },
    
    {
        news = {
            formal = "【小肉块丰收】今天会出现大量小肉块！",
            playful = "【小肉肉】到处都是小肉块，做肉丸子正好！",
            english = "[Small Meat Harvest] A large amount of small meat will appear today!"
        },
        effect = function()
            local player = TheSim:FindFirstEntityWithTag("player")
            if player then
                local x, y, z = player.Transform:GetWorldPosition()
                for i = 1, 15 do
                    local morsel = SpawnPrefab("smallmeat")
                    if morsel then
                        morsel.Transform:SetPosition(x + math.random(-25, 25), 0, z + math.random(-25, 25))
                    end
                end
            end
        end,
        event_type = "positive"
    },
    
    {
        news = {
            formal = "【青蛙腿丰收】今天会出现大量青蛙腿！",
            playful = "【呱呱的腿】到处都是青蛙腿，做料理超好吃！",
            english = "[Frog Legs Harvest] A large amount of frog legs will appear today!"
        },
        effect = function()
            local player = TheSim:FindFirstEntityWithTag("player")
            if player then
                local x, y, z = player.Transform:GetWorldPosition()
                for i = 1, 12 do
                    local froglegs = SpawnPrefab("froglegs")
                    if froglegs then
                        froglegs.Transform:SetPosition(x + math.random(-25, 25), 0, z + math.random(-25, 25))
                    end
                end
            end
        end,
        event_type = "positive"
    },
    
    {
        news = {
            formal = "【火鸡腿盛宴】今天会出现大量火鸡腿！",
            playful = "【大鸡腿】到处都是火鸡腿，吃肉吃到饱！",
            english = "[Drumstick Feast] A large amount of drumsticks will appear today!"
        },
        effect = function()
            local player = TheSim:FindFirstEntityWithTag("player")
            if player then
                local x, y, z = player.Transform:GetWorldPosition()
                for i = 1, 10 do
                    local drumstick = SpawnPrefab("drumstick")
                    if drumstick then
                        drumstick.Transform:SetPosition(x + math.random(-25, 25), 0, z + math.random(-25, 25))
                    end
                end
            end
        end,
        event_type = "positive"
    },
    
    {
        news = {
            formal = "【蝙蝠翅膀】今天会出现大量蝙蝠翅膀！",
            playful = "【小翅膀】到处都是蝙蝠翅膀，做料理做到爽！",
            english = "[Bat Wing] A large amount of bat wings will appear today!"
        },
        effect = function()
            local player = TheSim:FindFirstEntityWithTag("player")
            if player then
                local x, y, z = player.Transform:GetWorldPosition()
                for i = 1, 12 do
                    local batwing = SpawnPrefab("batwing")
                    if batwing then
                        batwing.Transform:SetPosition(x + math.random(-25, 25), 0, z + math.random(-25, 25))
                    end
                end
            end
        end,
        event_type = "positive"
    },
    
    {
        news = {
            formal = "【橙宝石富矿】今天会出现大量橙宝石！",
            playful = "【橙色闪闪】到处都是橙宝石，做懒人护符做到爽！",
            english = "[Orange Gem Abundance] A large amount of orange gems will appear today!"
        },
        effect = function()
            local player = TheSim:FindFirstEntityWithTag("player")
            if player then
                local x, y, z = player.Transform:GetWorldPosition()
                for i = 1, 5 do
                    local orangegem = SpawnPrefab("orangegem")
                    if orangegem then
                        orangegem.Transform:SetPosition(x + math.random(-25, 25), 0, z + math.random(-25, 25))
                    end
                end
            end
        end,
        event_type = "positive"
    },
    
    {
        news = {
            formal = "【黄宝石富矿】今天会出现大量黄宝石！",
            playful = "【黄色闪闪】到处都是黄宝石，做建筑护符做到爽！",
            english = "[Yellow Gem Abundance] A large amount of yellow gems will appear today!"
        },
        effect = function()
            local player = TheSim:FindFirstEntityWithTag("player")
            if player then
                local x, y, z = player.Transform:GetWorldPosition()
                for i = 1, 5 do
                    local yellowgem = SpawnPrefab("yellowgem")
                    if yellowgem then
                        yellowgem.Transform:SetPosition(x + math.random(-25, 25), 0, z + math.random(-25, 25))
                    end
                end
            end
        end,
        event_type = "positive"
    },
}


local current_events = {}
local last_day = -1
local broadcast_counter = 0

local function GetEventUsageCount(inst)
    if not inst.event_usage_count then
        inst.event_usage_count = {}
    end
    return inst.event_usage_count
end

local function SelectDailyEvents()
    local selected = {}
    local available = {}
    local event_usage_count = GetEventUsageCount(TheWorld)
    
    if EVENT_COUNT == 999 then
        for i, event in ipairs(NEWS_EVENTS) do
            table.insert(selected, event)
        end
        return selected
    end
    
    for i, event in ipairs(NEWS_EVENTS) do
        local should_add = true
        
        if event.event_type == "negative" and not ENABLE_NEGATIVE then
            should_add = false
        elseif event.event_type == "neutral" and not ENABLE_NEUTRAL then
            should_add = false
        end
        
        if ENABLE_NO_REPEAT and event_usage_count[i] and event_usage_count[i] >= REPEAT_LIMIT then
            should_add = false
        end
        
        if should_add then
            table.insert(available, i)
        end
    end
    
    if #available == 0 then
        return nil
    end
    
    for i = 1, math.min(EVENT_COUNT, #available) do
        if #available > 0 then
            local index = math.random(1, #available)
            local event_index = available[index]
            table.insert(selected, NEWS_EVENTS[event_index])
            
            if ENABLE_NO_REPEAT then
                event_usage_count[event_index] = (event_usage_count[event_index] or 0) + 1
            end
            
            table.remove(available, index)
        end
    end
    
    return selected
end

local function AnnounceNews(news_text)
    if TheWorld.ismastersim then
        TheNet:Announce(news_text)
    end
end

local function ApplyEventEffects(event)
    if event.effect then
        event.effect()
    end
end

local function GetNewsText(event)
    if type(event.news) == "table" then
        if NEWS_LANGUAGE == "en" then
            if event.news.english then
                return event.news.english
            else
                return event.news.formal
            end
        else
            return event.news[NEWS_STYLE] or event.news.formal
        end
    else
        return event.news
    end
end

local function CheckDailyNews()
    if not TheWorld.ismastersim then return end
    
    -- 直接抽取事件，没有任何天数判断
    current_events = SelectDailyEvents()
    local header_style = NEWS_HEADERS[NEWS_HEADER] or NEWS_HEADERS["beautiful"]
    
    if not current_events then
        TheWorld:DoTaskInTime(3, function()
            AnnounceNews(header_style.top)
            AnnounceNews("【通知】当前世界已经没有新鲜事啦~")
            AnnounceNews("可以在模组配置中关闭灾难不重复功能或者等待作者更新更多事件！")
            AnnounceNews(header_style.bottom)
        end)
        return
    end

    -- 预警逻辑（如果开启的话）
    if ENABLE_WARNING and WARNING_TIME > 0 then
        TheWorld:DoTaskInTime(0, function()
            AnnounceNews("【预警】致命灾难将在 " .. WARNING_TIME .. " 秒后播报！")
        end)
    end

    -- 播报与执行灾难
    TheWorld:DoTaskInTime(3, function()
        AnnounceNews(header_style.top)
        for i, event in ipairs(current_events) do
            TheWorld:DoTaskInTime(i * 2, function()
                local news_text = GetNewsText(event)
                AnnounceNews(string.format("【灾难 %d】%s", i, news_text))
                ApplyEventEffects(event)
            end)
        end
        TheWorld:DoTaskInTime((#current_events + 1) * 2, function()
            AnnounceNews(header_style.bottom)
        end)
    end)
end


AddPrefabPostInit("world", function(inst)
    if not TheWorld.ismastersim then return end
    
    GetConfig()
    
    inst.event_usage_count = {}
    
    inst:ListenForEvent("ms_save", function()
        if not ENABLE_NO_REPEAT then
            inst.event_usage_count = {}
        end
    end)
    
    --代表每 60 秒强制播报一次灾难
    inst:DoPeriodicTask(60, CheckDailyNews)
    
    -- 【删除了这里】把 inst:DoTaskInTime(5, CheckDailyNews) 删掉，避免开局倒计时还没结束就天降灾难
end)