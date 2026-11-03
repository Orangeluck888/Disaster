GLOBAL.setmetatable(env, { __index = function(t, k) return GLOBAL.rawget(GLOBAL, k) end })

local DISASTER_INTERVAL = GetModConfigData("disaster_interval") or 60
local FIRST_DISASTER_DELAY = GetModConfigData("first_disaster_delay") or 10
local CLEAN_INTERVAL = GetModConfigData("clean_interval") or 300
local CLEAN_NOTICE_ADVANCE = GetModConfigData("clean_notice_advance") or 60
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
	{
        news = {
            formal = "【猎犬围城】大量猎犬与火猎犬正在围攻！",
            playful = "【汪汪队大出动】狗狗们带着火把来拆家了，快跑！",
            english = "[Hound Siege] A massive pack of hounds and fire hounds is attacking!"
        },
        effect = function()
            local player = TheSim:FindFirstEntityWithTag("player")
            if player then
                local x, y, z = player.Transform:GetWorldPosition()
                for i = 1, 4 do
                    local hound = SpawnPrefab("hound")
                    if hound then hound.Transform:SetPosition(x + math.random(-15, 15), 0, z + math.random(-15, 15)) end
                    local fire = SpawnPrefab("firehound")
                    if fire then fire.Transform:SetPosition(x + math.random(-15, 15), 0, z + math.random(-15, 15)) end
                end
            end
        end,
        event_type = "negative"
    },
    {
        news = {
            formal = "【冰犬突袭】极寒猎犬降临，小心被冻住！",
            playful = "【冰冰狗来了】被这些狗狗咬到会变成冰棍哦！",
            english = "[Ice Hound Assault] Freezing hounds descend, beware of being frozen!"
        },
        effect = function()
            local player = TheSim:FindFirstEntityWithTag("player")
            if player then
                local x, y, z = player.Transform:GetWorldPosition()
                for i = 1, 6 do
                    local ice = SpawnPrefab("icehound")
                    if ice then ice.Transform:SetPosition(x + math.random(-15, 15), 0, z + math.random(-15, 15)) end
                end
            end
        end,
        event_type = "negative"
    },
    {
        news = {
            formal = "【蜘蛛巢穴】大地裂开，涌出大量蜘蛛战士与喷吐蜘蛛！",
            playful = "【八脚怪军团】蜘蛛们全家老小都出来逛街了，快清场！",
            english = "[Spider Nest] The ground cracks, spewing out spider warriors and spitters!"
        },
        effect = function()
            local player = TheSim:FindFirstEntityWithTag("player")
            if player then
                local x, y, z = player.Transform:GetWorldPosition()
                for i = 1, 4 do
                    local warrior = SpawnPrefab("spider_warrior")
                    if warrior then warrior.Transform:SetPosition(x + math.random(-15, 15), 0, z + math.random(-15, 15)) end
                    local spitter = SpawnPrefab("spider_spitter")
                    if spitter then spitter.Transform:SetPosition(x + math.random(-15, 15), 0, z + math.random(-15, 15)) end
                end
            end
        end,
        event_type = "negative"
    },
    {
        news = {
            formal = "【洞穴暴动】地下深处传来震动，大量洞穴蜘蛛与白蜘蛛破土而出！",
            playful = "【地底惊魂】地底下的小家伙们跑出来透气啦，小心它们的毒牙！",
            english = "[Cave Riot] Deep underground tremors bring forth cave spiders and white spiders!"
        },
        effect = function()
            local player = TheSim:FindFirstEntityWithTag("player")
            if player then
                local x, y, z = player.Transform:GetWorldPosition()
                for i = 1, 4 do
                    local hider = SpawnPrefab("spider_hider")
                    if hider then hider.Transform:SetPosition(x + math.random(-15, 15), 0, z + math.random(-15, 15)) end
                    local dropper = SpawnPrefab("spider_dropper")
                    if dropper then dropper.Transform:SetPosition(x + math.random(-15, 15), 0, z + math.random(-15, 15)) end
                end
            end
        end,
        event_type = "negative"
    },
    {
        news = {
            formal = "【杀人蜂巢】蜂群失控，危险的杀人蜂倾巢而出！",
            playful = "【嗡嗡嗡！】红眼睛的蜜蜂来了，被蛰到可不是闹着玩的！",
            english = "[Killer Bee Hive] The swarm is out of control, dangerous killer bees pour out!"
        },
        effect = function()
            local player = TheSim:FindFirstEntityWithTag("player")
            if player then
                local x, y, z = player.Transform:GetWorldPosition()
                for i = 1, 12 do
                    local bee = SpawnPrefab("killerbee")
                    if bee then bee.Transform:SetPosition(x + math.random(-20, 20), 0, z + math.random(-20, 20)) end
                end
            end
        end,
        event_type = "negative"
    },
    {
        news = {
            formal = "【发条军团】残破的远古机械苏醒，发条骑士与战车正在碾压一切！",
            playful = "【叮叮当当】会动的破铜烂铁来啦，快找个角落躲起来！",
            english = "[Clockwork Legion] Ancient machines awaken, clockwork knights and rooks crush everything!"
        },
        effect = function()
            local player = TheSim:FindFirstEntityWithTag("player")
            if player then
                local x, y, z = player.Transform:GetWorldPosition()
                for i = 1, 3 do
                    local knight = SpawnPrefab("knight")
                    if knight then knight.Transform:SetPosition(x + math.random(-20, 20), 0, z + math.random(-20, 20)) end
                    local rook = SpawnPrefab("rook")
                    if rook then rook.Transform:SetPosition(x + math.random(-20, 20), 0, z + math.random(-20, 20)) end
                end
            end
        end,
        event_type = "negative"
    },
    {
        news = {
            formal = "【主教审判】发条主教锁定区域，激光即将洗地！",
            playful = "【滋滋滋~】会射激光的机器人来了，蛇皮走位躲开它！",
            english = "[Bishop's Judgment] Clockwork bishops lock onto the area, lasers incoming!"
        },
        effect = function()
            local player = TheSim:FindFirstEntityWithTag("player")
            if player then
                local x, y, z = player.Transform:GetWorldPosition()
                for i = 1, 4 do
                    local bishop = SpawnPrefab("bishop")
                    if bishop then bishop.Transform:SetPosition(x + math.random(-20, 20), 0, z + math.random(-20, 20)) end
                end
            end
        end,
        event_type = "negative"
    },
    {
        news = {
            formal = "【破损军团】来自遗迹的破损发条生物出现了！",
            playful = "【锈迹斑斑】它们虽然破破烂烂，但打人还是很疼的！",
            english = "[Ruined Legion] Ruined clockwork creatures from the ruins appear!"
        },
        effect = function()
            local player = TheSim:FindFirstEntityWithTag("player")
            if player then
                local x, y, z = player.Transform:GetWorldPosition()
                for i = 1, 2 do
                    local kn = SpawnPrefab("knight_nightmare")
                    if kn then kn.Transform:SetPosition(x + math.random(-20, 20), 0, z + math.random(-20, 20)) end
                    local bn = SpawnPrefab("bishop_nightmare")
                    if bn then bn.Transform:SetPosition(x + math.random(-20, 20), 0, z + math.random(-20, 20)) end
                    local rn = SpawnPrefab("rook_nightmare")
                    if rn then rn.Transform:SetPosition(x + math.random(-20, 20), 0, z + math.random(-20, 20)) end
                end
            end
        end,
        event_type = "negative"
    },
    {
        news = {
            formal = "【暗影侵蚀】你的理智正在崩塌，爬行梦魇从阴影中显现！",
            playful = "【小黑人来了】它们就在你身后！快回头看看！",
            english = "[Shadow Erosion] Your sanity is collapsing, crawling horrors manifest from shadows!"
        },
        effect = function()
            local player = TheSim:FindFirstEntityWithTag("player")
            if player then
                local x, y, z = player.Transform:GetWorldPosition()
                for i = 1, 5 do
                    local shadow = SpawnPrefab("crawlinghorror")
                    if shadow then shadow.Transform:SetPosition(x + math.random(-15, 15), 0, z + math.random(-15, 15)) end
                end
            end
        end,
        event_type = "negative"
    },
    {
        news = {
            formal = "【恐怖尖喙】巨大的暗影尖喙正在锁定猎物！",
            playful = "【大鸟怪】那只长着大嘴的暗影怪盯上你了！",
            english = "[Terrorbeak] A massive shadow terrorbeak has locked onto its prey!"
        },
        effect = function()
            local player = TheSim:FindFirstEntityWithTag("player")
            if player then
                local x, y, z = player.Transform:GetWorldPosition()
                for i = 1, 3 do
                    local beak = SpawnPrefab("terrorbeak")
                    if beak then beak.Transform:SetPosition(x + math.random(-15, 15), 0, z + math.random(-15, 15)) end
                end
            end
        end,
        event_type = "negative"
    },
    {
        news = {
            formal = "【鱼人暴乱】沼泽的鱼人涌上岸，疯狂攻击一切！",
            playful = "【鱼鱼上岸啦】它们不讲武德，竟然上岸来打人了！",
            english = "[Merm Riot] Merms from the swamp surge ashore, attacking everything!"
        },
        effect = function()
            local player = TheSim:FindFirstEntityWithTag("player")
            if player then
                local x, y, z = player.Transform:GetWorldPosition()
                for i = 1, 8 do
                    local merm = SpawnPrefab("merm")
                    if merm then merm.Transform:SetPosition(x + math.random(-20, 20), 0, z + math.random(-20, 20)) end
                end
            end
        end,
        event_type = "negative"
    },
    {
        news = {
            formal = "【鱼人守卫】忠诚的鱼人守卫带着长矛来了！",
            playful = "【长矛鱼鱼】它们手里的家伙可不是吃素的！",
            english = "[Merm Guards] Loyal merm guards arrive with their spears!"
        },
        effect = function()
            local player = TheSim:FindFirstEntityWithTag("player")
            if player then
                local x, y, z = player.Transform:GetWorldPosition()
                for i = 1, 5 do
                    local guard = SpawnPrefab("mermguard")
                    if guard then guard.Transform:SetPosition(x + math.random(-20, 20), 0, z + math.random(-20, 20)) end
                end
            end
        end,
        event_type = "negative"
    },
    {
        news = {
            formal = "【高脚鸟之怒】成年高脚鸟被激怒，正在疯狂啄击！",
            playful = "【大长腿】别靠近它们！它们的啄击又快又疼！",
            english = "[Tallbird's Wrath] Adult tallbirds are enraged, pecking furiously!"
        },
        effect = function()
            local player = TheSim:FindFirstEntityWithTag("player")
            if player then
                local x, y, z = player.Transform:GetWorldPosition()
                for i = 1, 6 do
                    local bird = SpawnPrefab("tallbird")
                    if bird then bird.Transform:SetPosition(x + math.random(-20, 20), 0, z + math.random(-20, 20)) end
                end
            end
        end,
        event_type = "negative"
    },
    {
        news = {
            formal = "【触手暴走】地面喷出大量触手，疯狂抽打！",
            playful = "【地面攻击】走路小心脚下，触手随时会冒出来！",
            english = "[Tentacle Rampage] The ground erupts with tentacles, whipping wildly!"
        },
        effect = function()
            local player = TheSim:FindFirstEntityWithTag("player")
            if player then
                local x, y, z = player.Transform:GetWorldPosition()
                for i = 1, 10 do
                    local tentacle = SpawnPrefab("tentacle")
                    if tentacle then tentacle.Transform:SetPosition(x + math.random(-25, 25), 0, z + math.random(-25, 25)) end
                end
            end
        end,
        event_type = "negative"
    },
    {
        news = {
            formal = "【蝙蝠夜袭】洞穴蝙蝠倾巢而出，遮天蔽日！",
            playful = "【吱吱吱】满天都是蝙蝠，快找个地方躲起来！",
            english = "[Bat Night Raid] Cave bats pour out, blotting out the sky!"
        },
        effect = function()
            local player = TheSim:FindFirstEntityWithTag("player")
            if player then
                local x, y, z = player.Transform:GetWorldPosition()
                for i = 1, 15 do
                    local bat = SpawnPrefab("bat")
                    if bat then bat.Transform:SetPosition(x + math.random(-20, 20), 0, z + math.random(-20, 20)) end
                end
            end
        end,
        event_type = "negative"
    },
    {
        news = {
            formal = "【深渊蠕虫】大地震动，巨大的深渊蠕虫破土而出！",
            playful = "【地底巨兽】这玩意可比触手可怕多了，快跑！",
            english = "[Depths Worm] The earth shakes as giant depths worms burst forth!"
        },
        effect = function()
            local player = TheSim:FindFirstEntityWithTag("player")
            if player then
                local x, y, z = player.Transform:GetWorldPosition()
                for i = 1, 3 do
                    local worm = SpawnPrefab("worm")
                    if worm then worm.Transform:SetPosition(x + math.random(-20, 20), 0, z + math.random(-20, 20)) end
                end
            end
        end,
        event_type = "negative"
    },
    {
        news = {
            formal = "【坎普斯降临】你的罪恶引来了坎普斯！",
            playful = "【小偷来了】快捂好你的背包，别被偷光了！",
            english = "[Krampus Arrives] Your sins have summoned Krampus!"
        },
        effect = function()
            local player = TheSim:FindFirstEntityWithTag("player")
            if player then
                local x, y, z = player.Transform:GetWorldPosition()
                local krampus = SpawnPrefab("krampus")
                if krampus then krampus.Transform:SetPosition(x + math.random(-10, 10), 0, z + math.random(-10, 10)) end
                for i = 1, 3 do
                    local thief = SpawnPrefab("krampus")
                    if thief then thief.Transform:SetPosition(x + math.random(-15, 15), 0, z + math.random(-15, 15)) end
                end
            end
        end,
        event_type = "negative"
    },
    {
        news = {
            formal = "【座狼突袭】凶残的座狼带着它的猎犬群来了！",
            playful = "【大狗王】这只大狗会召唤小弟，小心被围殴！",
            english = "[Varg Attack] A ferocious Varg arrives with its pack of hounds!"
        },
        effect = function()
            local player = TheSim:FindFirstEntityWithTag("player")
            if player then
                local x, y, z = player.Transform:GetWorldPosition()
                local varg = SpawnPrefab("warg")
                if varg then varg.Transform:SetPosition(x + math.random(-15, 15), 0, z + math.random(-15, 15)) end
                for i = 1, 4 do
                    local hound = SpawnPrefab("hound")
                    if hound then hound.Transform:SetPosition(x + math.random(-15, 15), 0, z + math.random(-15, 15)) end
                end
            end
        end,
        event_type = "negative"
    },
    {
        news = {
            formal = "【杀人蜂群】漫山遍野的杀人蜂正在搜寻目标！",
            playful = "【马蜂窝】你捅了马蜂窝了！快跑！",
            english = "[Killer Bee Swarm] A massive swarm of killer bees is searching for targets!"
        },
        effect = function()
            local player = TheSim:FindFirstEntityWithTag("player")
            if player then
                local x, y, z = player.Transform:GetWorldPosition()
                for i = 1, 20 do
                    local bee = SpawnPrefab("killerbee")
                    if bee then bee.Transform:SetPosition(x + math.random(-25, 25), 0, z + math.random(-25, 25)) end
                end
            end
        end,
        event_type = "negative"
    },
    {
        news = {
            formal = "【蚊子瘟疫】大量蚊子携带疾病来袭！",
            playful = "【嗡嗡嗡】被蚊子咬不仅掉血，还会得病！",
            english = "[Mosquito Plague] A horde of disease-carrying mosquitoes attacks!"
        },
        effect = function()
            local player = TheSim:FindFirstEntityWithTag("player")
            if player then
                local x, y, z = player.Transform:GetWorldPosition()
                for i = 1, 15 do
                    local mosquito = SpawnPrefab("mosquito")
                    if mosquito then mosquito.Transform:SetPosition(x + math.random(-20, 20), 0, z + math.random(-20, 20)) end
                end
            end
        end,
        event_type = "negative"
    },
    {
        news = {
            formal = "【啜食兽】贪婪的啜食兽盯上了你的装备！",
            playful = "【贪吃鬼】它会把你的武器吸走！快打它！",
            english = "[Slurper] A greedy slurper has set its sights on your equipment!"
        },
        effect = function()
            local player = TheSim:FindFirstEntityWithTag("player")
            if player then
                local x, y, z = player.Transform:GetWorldPosition()
                for i = 1, 4 do
                    local slurper = SpawnPrefab("slurper")
                    if slurper then slurper.Transform:SetPosition(x + math.random(-15, 15), 0, z + math.random(-15, 15)) end
                end
            end
        end,
        event_type = "negative"
    },
    {
        news = {
            formal = "【眼球草】诡异的眼球草正在蔓延，吞噬一切！",
            playful = "【大眼睛】满地都是眼睛在盯着你，快烧掉它们！",
            english = "[Eyeplants] Creepy eyeplants are spreading, devouring everything!"
        },
        effect = function()
            local player = TheSim:FindFirstEntityWithTag("player")
            if player then
                local x, y, z = player.Transform:GetWorldPosition()
                for i = 1, 6 do
                    local plant = SpawnPrefab("eyeplant")
                    if plant then plant.Transform:SetPosition(x + math.random(-25, 25), 0, z + math.random(-25, 25)) end
                end
            end
        end,
        event_type = "negative"
    },
    {
        news = {
            formal = "【食人花】巨大的食人花张开了血盆大口！",
            playful = "【血盆大口】别靠近它！它会把你的东西都吃掉！",
            english = "[Lureplant] A giant lureplant opens its massive maw!"
        },
        effect = function()
            local player = TheSim:FindFirstEntityWithTag("player")
            if player then
                local x, y, z = player.Transform:GetWorldPosition()
                local lure = SpawnPrefab("lureplant")
                if lure then lure.Transform:SetPosition(x + math.random(-20, 20), 0, z + math.random(-20, 20)) end
            end
        end,
        event_type = "negative"
    },
    {
        news = {
            formal = "【幽灵】亡者的灵魂在哭泣，幽灵正在靠近！",
            playful = "【呜呜呜】它们好可怜，但咬人也真的好疼！",
            english = "[Ghosts] The souls of the dead are weeping, ghosts are approaching!"
        },
        effect = function()
            local player = TheSim:FindFirstEntityWithTag("player")
            if player then
                local x, y, z = player.Transform:GetWorldPosition()
                for i = 1, 5 do
                    local ghost = SpawnPrefab("ghost")
                    if ghost then ghost.Transform:SetPosition(x + math.random(-20, 20), 0, z + math.random(-20, 20)) end
                end
            end
        end,
        event_type = "negative"
    },
    {
        news = {
            formal = "【月岩企鹅】变异月岩企鹅正在疯狂攻击！",
            playful = "【暴力企鹅】这些企鹅看起来不太友好，快跑！",
            english = "[Moonrock Penguins] Mutated moonrock penguins are attacking furiously!"
        },
        effect = function()
            local player = TheSim:FindFirstEntityWithTag("player")
            if player then
                local x, y, z = player.Transform:GetWorldPosition()
                for i = 1, 6 do
                    local penguin = SpawnPrefab("mutated_penguin")
                    if penguin then penguin.Transform:SetPosition(x + math.random(-20, 20), 0, z + math.random(-20, 20)) end
                end
            end
        end,
        event_type = "negative"
    },
    {
        news = {
            formal = "【饼干切割机】海里的饼干切割机上岸了！",
            playful = "【嘎嘣脆】它们会啃食你的船和装备！",
            english = "[Cookie Cutters] Cookie cutters from the sea have come ashore!"
        },
        effect = function()
            local player = TheSim:FindFirstEntityWithTag("player")
            if player then
                local x, y, z = player.Transform:GetWorldPosition()
                for i = 1, 8 do
                    local cutter = SpawnPrefab("cookiecutter")
                    if cutter then cutter.Transform:SetPosition(x + math.random(-20, 20), 0, z + math.random(-20, 20)) end
                end
            end
        end,
        event_type = "negative"
    },
    {
        news = {
            formal = "【果蝇王】果蝇王带着它的子民来了！",
            playful = "【大苍蝇】它虽然不咬人，但会一直骚扰你！",
            english = "[Lord of the Fruit Flies] The Lord of the Fruit Flies arrives with his subjects!"
        },
        effect = function()
            local player = TheSim:FindFirstEntityWithTag("player")
            if player then
                local x, y, z = player.Transform:GetWorldPosition()
                local lord = SpawnPrefab("fruitfly")
                if lord then lord.Transform:SetPosition(x + math.random(-15, 15), 0, z + math.random(-15, 15)) end
                for i = 1, 5 do
                    local fly = SpawnPrefab("flies")
                    if fly then fly.Transform:SetPosition(x + math.random(-20, 20), 0, z + math.random(-20, 20)) end
                end
            end
        end,
        event_type = "negative"
    },
    {
        news = {
            formal = "【奇形鸟】诡异的奇形鸟在天空中盘旋！",
            playful = "【怪鸟】它们长得奇形怪状，还会主动攻击！",
            english = "[Malbatross] Strange malbatrosses circle overhead!"
        },
        effect = function()
            local player = TheSim:FindFirstEntityWithTag("player")
            if player then
                local x, y, z = player.Transform:GetWorldPosition()
                for i = 1, 3 do
                    local bird = SpawnPrefab("malbatross")
                    if bird then bird.Transform:SetPosition(x + math.random(-20, 20), 0, z + math.random(-20, 20)) end
                end
            end
        end,
        event_type = "negative"
    },
    {
        news = {
            formal = "【猪人守卫】原本友好的猪人守卫突然发狂了！",
            playful = "【二师兄疯了】平时称兄道弟，现在追着你打！",
            english = "[Pig Guards] The normally friendly pig guards have gone berserk!"
        },
        effect = function()
            local player = TheSim:FindFirstEntityWithTag("player")
            if player then
                local x, y, z = player.Transform:GetWorldPosition()
                for i = 1, 6 do
                    local pig = SpawnPrefab("pigguard")
                    if pig then pig.Transform:SetPosition(x + math.random(-20, 20), 0, z + math.random(-20, 20)) end
                end
            end
        end,
        event_type = "negative"
    },
    {
        news = {
            formal = "【蜘蛛女王】大地开始震颤，一只巨大的蜘蛛女王从地底爬出！",
            playful = "【蜘蛛老母】女王带着她成千上万的孩子来欢迎你了！",
            english = "[Spider Queen] The ground trembles as a giant Spider Queen emerges!"
        },
        effect = function()
            local player = TheSim:FindFirstEntityWithTag("player")
            if player then
                local x, y, z = player.Transform:GetWorldPosition()
                local queen = SpawnPrefab("spiderqueen")
                if queen then queen.Transform:SetPosition(x + math.random(-15, 15), 0, z + math.random(-15, 15)) end
            end
        end,
        event_type = "negative"
    },
    {
        news = {
            formal = "【桦树精】森林的守护者被激怒了，巨大的桦树精正在苏醒！",
            playful = "【大树生气了】你砍树太多了，树精来找你算账了！",
            english = "[Birchnutter] The forest guardian is enraged, a giant birchnut treeguard awakens!"
        },
        effect = function()
            local player = TheSim:FindFirstEntityWithTag("player")
            if player then
                local x, y, z = player.Transform:GetWorldPosition()
                local tree = SpawnPrefab("deciduoustree")
                if tree then
                    tree.Transform:SetPosition(x + math.random(-15, 15), 0, z + math.random(-15, 15))
                    if tree.components.health then tree.components.health:SetVal(1) end
                end
            end
        end,
        event_type = "negative"
    },
    {
        news = {
            formal = "【远古犀牛】迷宫深处的远古守护者被释放了！",
            playful = "【犀牛冲撞】被它撞一下可不是开玩笑的，快躲开！",
            english = "[Ancient Guardian] The ancient guardian from the labyrinth is unleashed!"
        },
        effect = function()
            local player = TheSim:FindFirstEntityWithTag("player")
            if player then
                local x, y, z = player.Transform:GetWorldPosition()
                local rhino = SpawnPrefab("minotaur")
                if rhino then rhino.Transform:SetPosition(x + math.random(-15, 15), 0, z + math.random(-15, 15)) end
            end
        end,
        event_type = "negative"
    },
    {
        news = {
            formal = "【熊獾】秋季BOSS熊獾被惊醒，它正饿着肚子寻找食物！",
            playful = "【大笨熊】它饿了，而你就是它的点心！",
            english = "[Bearger] The autumn boss Bearger has awakened, hungry and looking for food!"
        },
        effect = function()
            local player = TheSim:FindFirstEntityWithTag("player")
            if player then
                local x, y, z = player.Transform:GetWorldPosition()
                local bearger = SpawnPrefab("bearger")
                if bearger then bearger.Transform:SetPosition(x + math.random(-15, 15), 0, z + math.random(-15, 15)) end
            end
        end,
        event_type = "negative"
    },
    {
        news = {
            formal = "【巨鹿】独眼巨鹿的脚步声越来越近，大地都在颤抖！",
            playful = "【独眼巨人】它会把你的基地拆得一干二净！",
            english = "[Deerclops] The footsteps of the Deerclops grow closer, the earth trembles!"
        },
        effect = function()
            local player = TheSim:FindFirstEntityWithTag("player")
            if player then
                local x, y, z = player.Transform:GetWorldPosition()
                local deer = SpawnPrefab("deerclops")
                if deer then deer.Transform:SetPosition(x + math.random(-15, 15), 0, z + math.random(-15, 15)) end
            end
        end,
        event_type = "negative"
    },
	    -- ==========================================
    -- 新增的 50 个致命负面事件（直接粘贴到表里）
    -- ==========================================
    {
        news = { formal = "【冰犬突袭】极寒猎犬降临，小心被冻住！", playful = "【冰冰狗来了】被这些狗狗咬到会变成冰棍哦！", english = "[Ice Hound Assault]" },
        effect = function()
            local player = TheSim:FindFirstEntityWithTag("player")
            if player then
                local x, y, z = player.Transform:GetWorldPosition()
                for i = 1, 6 do
                    local ice = SpawnPrefab("icehound")
                    if ice then ice.Transform:SetPosition(x + math.random(-15, 15), 0, z + math.random(-15, 15)) end
                end
            end
        end,
        event_type = "negative"
    },
    {
        news = { formal = "【洞穴暴动】地下深处传来震动，大量洞穴蜘蛛破土而出！", playful = "【地底惊魂】地底下的小家伙们跑出来透气啦，小心它们的毒牙！", english = "[Cave Riot]" },
        effect = function()
            local player = TheSim:FindFirstEntityWithTag("player")
            if player then
                local x, y, z = player.Transform:GetWorldPosition()
                for i = 1, 4 do
                    local hider = SpawnPrefab("spider_hider")
                    if hider then hider.Transform:SetPosition(x + math.random(-15, 15), 0, z + math.random(-15, 15)) end
                    local spitter = SpawnPrefab("spider_spitter")
                    if spitter then spitter.Transform:SetPosition(x + math.random(-15, 15), 0, z + math.random(-15, 15)) end
                end
            end
        end,
        event_type = "negative"
    },
    {
        news = { formal = "【破损军团】来自遗迹的破损发条生物出现了！", playful = "【锈迹斑斑】它们虽然破破烂烂，但打人还是很疼的！", english = "[Ruined Legion]" },
        effect = function()
            local player = TheSim:FindFirstEntityWithTag("player")
            if player then
                local x, y, z = player.Transform:GetWorldPosition()
                local kn = SpawnPrefab("knight_nightmare")
                if kn then kn.Transform:SetPosition(x + math.random(-15, 15), 0, z + math.random(-15, 15)) end
                local bn = SpawnPrefab("bishop_nightmare")
                if bn then bn.Transform:SetPosition(x + math.random(-15, 15), 0, z + math.random(-15, 15)) end
                local rn = SpawnPrefab("rook_nightmare")
                if rn then rn.Transform:SetPosition(x + math.random(-15, 15), 0, z + math.random(-15, 15)) end
            end
        end,
        event_type = "negative"
    },
    {
        news = { formal = "【恐怖尖喙】巨大的暗影尖喙正在锁定猎物！", playful = "【大鸟怪】那只长着大嘴的暗影怪盯上你了！", english = "[Terrorbeak]" },
        effect = function()
            local player = TheSim:FindFirstEntityWithTag("player")
            if player then
                local x, y, z = player.Transform:GetWorldPosition()
                for i = 1, 3 do
                    local beak = SpawnPrefab("terrorbeak")
                    if beak then beak.Transform:SetPosition(x + math.random(-15, 15), 0, z + math.random(-15, 15)) end
                end
            end
        end,
        event_type = "negative"
    },
    {
        news = { formal = "【鱼人守卫】忠诚的鱼人守卫带着长矛来了！", playful = "【长矛鱼鱼】它们手里的家伙可不是吃素的！", english = "[Merm Guards]" },
        effect = function()
            local player = TheSim:FindFirstEntityWithTag("player")
            if player then
                local x, y, z = player.Transform:GetWorldPosition()
                for i = 1, 5 do
                    local guard = SpawnPrefab("mermguard")
                    if guard then guard.Transform:SetPosition(x + math.random(-20, 20), 0, z + math.random(-20, 20)) end
                end
            end
        end,
        event_type = "negative"
    },
    {
        news = { formal = "【高脚鸟之怒】成年高脚鸟被激怒，正在疯狂啄击！", playful = "【大长腿】别靠近它们！它们的啄击又快又疼！", english = "[Tallbird's Wrath]" },
        effect = function()
            local player = TheSim:FindFirstEntityWithTag("player")
            if player then
                local x, y, z = player.Transform:GetWorldPosition()
                for i = 1, 6 do
                    local bird = SpawnPrefab("tallbird")
                    if bird then bird.Transform:SetPosition(x + math.random(-20, 20), 0, z + math.random(-20, 20)) end
                end
            end
        end,
        event_type = "negative"
    },
    {
        news = { formal = "【蝙蝠夜袭】洞穴蝙蝠倾巢而出，遮天蔽日！", playful = "【吱吱吱】满天都是蝙蝠，快找个地方躲起来！", english = "[Bat Night Raid]" },
        effect = function()
            local player = TheSim:FindFirstEntityWithTag("player")
            if player then
                local x, y, z = player.Transform:GetWorldPosition()
                for i = 1, 15 do
                    local bat = SpawnPrefab("bat")
                    if bat then bat.Transform:SetPosition(x + math.random(-20, 20), 0, z + math.random(-20, 20)) end
                end
            end
        end,
        event_type = "negative"
    },
    {
        news = { formal = "【深渊蠕虫】大地震动，巨大的深渊蠕虫破土而出！", playful = "【地底巨兽】这玩意可比触手可怕多了，快跑！", english = "[Depths Worm]" },
        effect = function()
            local player = TheSim:FindFirstEntityWithTag("player")
            if player then
                local x, y, z = player.Transform:GetWorldPosition()
                for i = 1, 3 do
                    local worm = SpawnPrefab("worm")
                    if worm then worm.Transform:SetPosition(x + math.random(-20, 20), 0, z + math.random(-20, 20)) end
                end
            end
        end,
        event_type = "negative"
    },
    {
        news = { formal = "【坎普斯降临】你的罪恶引来了坎普斯！", playful = "【小偷来了】快捂好你的背包，别被偷光了！", english = "[Krampus Arrives]" },
        effect = function()
            local player = TheSim:FindFirstEntityWithTag("player")
            if player then
                local x, y, z = player.Transform:GetWorldPosition()
                local krampus = SpawnPrefab("krampus")
                if krampus then krampus.Transform:SetPosition(x + math.random(-10, 10), 0, z + math.random(-10, 10)) end
                for i = 1, 3 do
                    local thief = SpawnPrefab("krampus")
                    if thief then thief.Transform:SetPosition(x + math.random(-15, 15), 0, z + math.random(-15, 15)) end
                end
            end
        end,
        event_type = "negative"
    },
    {
        news = { formal = "【座狼突袭】凶残的座狼带着它的猎犬群来了！", playful = "【大狗王】这只大狗会召唤小弟，小心被围殴！", english = "[Varg Attack]" },
        effect = function()
            local player = TheSim:FindFirstEntityWithTag("player")
            if player then
                local x, y, z = player.Transform:GetWorldPosition()
                local varg = SpawnPrefab("warg")
                if varg then varg.Transform:SetPosition(x + math.random(-15, 15), 0, z + math.random(-15, 15)) end
                for i = 1, 4 do
                    local hound = SpawnPrefab("hound")
                    if hound then hound.Transform:SetPosition(x + math.random(-15, 15), 0, z + math.random(-15, 15)) end
                end
            end
        end,
        event_type = "negative"
    },
    {
        news = { formal = "【啜食兽】贪婪的啜食兽盯上了你的装备！", playful = "【贪吃鬼】它会把你的武器吸走！快打它！", english = "[Slurper]" },
        effect = function()
            local player = TheSim:FindFirstEntityWithTag("player")
            if player then
                local x, y, z = player.Transform:GetWorldPosition()
                for i = 1, 4 do
                    local slurper = SpawnPrefab("slurper")
                    if slurper then slurper.Transform:SetPosition(x + math.random(-15, 15), 0, z + math.random(-15, 15)) end
                end
            end
        end,
        event_type = "negative"
    },
    {
        news = { formal = "【眼球草】诡异的眼球草正在蔓延，吞噬一切！", playful = "【大眼睛】满地都是眼睛在盯着你，快烧掉它们！", english = "[Eyeplants]" },
        effect = function()
            local player = TheSim:FindFirstEntityWithTag("player")
            if player then
                local x, y, z = player.Transform:GetWorldPosition()
                for i = 1, 6 do
                    local plant = SpawnPrefab("eyeplant")
                    if plant then plant.Transform:SetPosition(x + math.random(-25, 25), 0, z + math.random(-25, 25)) end
                end
            end
        end,
        event_type = "negative"
    },
    {
        news = { formal = "【食人花】巨大的食人花张开了血盆大口！", playful = "【血盆大口】别靠近它！它会把你的东西都吃掉！", english = "[Lureplant]" },
        effect = function()
            local player = TheSim:FindFirstEntityWithTag("player")
            if player then
                local x, y, z = player.Transform:GetWorldPosition()
                local lure = SpawnPrefab("lureplant")
                if lure then lure.Transform:SetPosition(x + math.random(-20, 20), 0, z + math.random(-20, 20)) end
            end
        end,
        event_type = "negative"
    },
    {
        news = { formal = "【幽灵】亡者的灵魂在哭泣，幽灵正在靠近！", playful = "【呜呜呜】它们好可怜，但咬人也真的好疼！", english = "[Ghosts]" },
        effect = function()
            local player = TheSim:FindFirstEntityWithTag("player")
            if player then
                local x, y, z = player.Transform:GetWorldPosition()
                for i = 1, 5 do
                    local ghost = SpawnPrefab("ghost")
                    if ghost then ghost.Transform:SetPosition(x + math.random(-20, 20), 0, z + math.random(-20, 20)) end
                end
            end
        end,
        event_type = "negative"
    },
    {
        news = { formal = "【月岩企鹅】变异月岩企鹅正在疯狂攻击！", playful = "【暴力企鹅】这些企鹅看起来不太友好，快跑！", english = "[Moonrock Penguins]" },
        effect = function()
            local player = TheSim:FindFirstEntityWithTag("player")
            if player then
                local x, y, z = player.Transform:GetWorldPosition()
                for i = 1, 6 do
                    local penguin = SpawnPrefab("mutated_penguin")
                    if penguin then penguin.Transform:SetPosition(x + math.random(-20, 20), 0, z + math.random(-20, 20)) end
                end
            end
        end,
        event_type = "negative"
    },
    {
        news = { formal = "【饼干切割机】海里的饼干切割机上岸了！", playful = "【嘎嘣脆】它们会啃食你的船和装备！", english = "[Cookie Cutters]" },
        effect = function()
            local player = TheSim:FindFirstEntityWithTag("player")
            if player then
                local x, y, z = player.Transform:GetWorldPosition()
                for i = 1, 8 do
                    local cutter = SpawnPrefab("cookiecutter")
                    if cutter then cutter.Transform:SetPosition(x + math.random(-20, 20), 0, z + math.random(-20, 20)) end
                end
            end
        end,
        event_type = "negative"
    },
    {
        news = { formal = "【果蝇王】果蝇王带着它的子民来了！", playful = "【大苍蝇】它虽然不咬人，但会一直骚扰你！", english = "[Lord of the Fruit Flies]" },
        effect = function()
            local player = TheSim:FindFirstEntityWithTag("player")
            if player then
                local x, y, z = player.Transform:GetWorldPosition()
                local lord = SpawnPrefab("fruitfly")
                if lord then lord.Transform:SetPosition(x + math.random(-15, 15), 0, z + math.random(-15, 15)) end
                for i = 1, 5 do
                    local fly = SpawnPrefab("flies")
                    if fly then fly.Transform:SetPosition(x + math.random(-20, 20), 0, z + math.random(-20, 20)) end
                end
            end
        end,
        event_type = "negative"
    },
    {
        news = { formal = "【猪人守卫】原本友好的猪人守卫突然发狂了！", playful = "【二师兄疯了】平时称兄道弟，现在追着你打！", english = "[Pig Guards]" },
        effect = function()
            local player = TheSim:FindFirstEntityWithTag("player")
            if player then
                local x, y, z = player.Transform:GetWorldPosition()
                for i = 1, 6 do
                    local pig = SpawnPrefab("pigguard")
                    if pig then pig.Transform:SetPosition(x + math.random(-20, 20), 0, z + math.random(-20, 20)) end
                end
            end
        end,
        event_type = "negative"
    },
    {
        news = { formal = "【蜘蛛女王】大地开始震颤，一只巨大的蜘蛛女王从地底爬出！", playful = "【蜘蛛老母】女王带着她成千上万的孩子来欢迎你了！", english = "[Spider Queen]" },
        effect = function()
            local player = TheSim:FindFirstEntityWithTag("player")
            if player then
                local x, y, z = player.Transform:GetWorldPosition()
                local queen = SpawnPrefab("spiderqueen")
                if queen then queen.Transform:SetPosition(x + math.random(-15, 15), 0, z + math.random(-15, 15)) end
            end
        end,
        event_type = "negative"
    },
    {
        news = { formal = "【远古犀牛】迷宫深处的远古守护者被释放了！", playful = "【犀牛冲撞】被它撞一下可不是开玩笑的，快躲开！", english = "[Ancient Guardian]" },
        effect = function()
            local player = TheSim:FindFirstEntityWithTag("player")
            if player then
                local x, y, z = player.Transform:GetWorldPosition()
                local rhino = SpawnPrefab("minotaur")
                if rhino then rhino.Transform:SetPosition(x + math.random(-15, 15), 0, z + math.random(-15, 15)) end
            end
        end,
        event_type = "negative"
    },
    {
        news = { formal = "【熊獾】秋季BOSS熊獾被惊醒，它正饿着肚子寻找食物！", playful = "【大笨熊】它饿了，而你就是它的点心！", english = "[Bearger]" },
        effect = function()
            local player = TheSim:FindFirstEntityWithTag("player")
            if player then
                local x, y, z = player.Transform:GetWorldPosition()
                local bearger = SpawnPrefab("bearger")
                if bearger then bearger.Transform:SetPosition(x + math.random(-15, 15), 0, z + math.random(-15, 15)) end
            end
        end,
        event_type = "negative"
    },
    {
        news = { formal = "【巨鹿】独眼巨鹿的脚步声越来越近，大地都在颤抖！", playful = "【独眼巨人】它会把你的基地拆得一干二净！", english = "[Deerclops]" },
        effect = function()
            local player = TheSim:FindFirstEntityWithTag("player")
            if player then
                local x, y, z = player.Transform:GetWorldPosition()
                local deer = SpawnPrefab("deerclops")
                if deer then deer.Transform:SetPosition(x + math.random(-15, 15), 0, z + math.random(-15, 15)) end
            end
        end,
        event_type = "negative"
    },
    {
        news = { formal = "【极寒降临】一场突如其来的暴风雪席卷了岛屿！", playful = "【冷死啦】温度骤降，快烤火，不然会变成冰雕！", english = "[Extreme Cold]" },
        effect = function()
            for i, player in ipairs(AllPlayers) do
                if player and player.components.temperature then
                    player.components.temperature:SetTemperature(-10)
                end
            end
        end,
        event_type = "negative"
    },
    {
        news = { formal = "【酷暑难耐】热浪来袭，连空气都在燃烧！", playful = "【热死啦】温度飙升，快找冰块降温！", english = "[Scorching Heat]" },
        effect = function()
            for i, player in ipairs(AllPlayers) do
                if player and player.components.temperature then
                    player.components.temperature:SetTemperature(70)
                end
            end
        end,
        event_type = "negative"
    },
    {
        news = { formal = "【理智崩塌】不可名状的恐惧侵蚀了你的大脑！", playful = "【脑子坏掉了】理智值暴跌，暗影怪物要来找你了！", english = "[Sanity Collapse]" },
        effect = function()
            for i, player in ipairs(AllPlayers) do
                if player and player.components.sanity then
                    player.components.sanity:DoDelta(-100)
                end
            end
        end,
        event_type = "negative"
    },
    {
        news = { formal = "【极度饥饿】你的胃在咆哮，能量正在流失！", playful = "【饿扁了】肚子空空如也，再不吃饭就要饿死了！", english = "[Extreme Hunger]" },
        effect = function()
            for i, player in ipairs(AllPlayers) do
                if player and player.components.hunger then
                    player.components.hunger:DoDelta(-100)
                end
            end
        end,
        event_type = "negative"
    },
    {
        news = { formal = "【浑身湿透】倾盆大雨从天而降，你被淋成了落汤鸡！", playful = "【湿哒哒】浑身都是水，快生火烤干！", english = "[Soaking Wet]" },
        effect = function()
            for i, player in ipairs(AllPlayers) do
                if player and player.components.moisture then
                    player.components.moisture:SetPercent(1)
                end
            end
        end,
        event_type = "negative"
    },
    {
        news = { formal = "【食物腐烂】一股诡异的热浪让你的食物迅速变质！", playful = "【臭烘烘】你的食物全烂了，饿肚子吧！", english = "[Food Rot]" },
        effect = function()
            for i, player in ipairs(AllPlayers) do
                if player and player.components.inventory then
                    local items = player.components.inventory:FindItems(function(item) return item.components.perishable ~= nil end)
                    for _, item in ipairs(items) do
                        item.components.perishable:DoDelta(0.5)
                    end
                end
            end
        end,
        event_type = "negative"
    },
    {
        news = { formal = "【雷暴天降】天空中乌云密布，闪电锁定了你！", playful = "【天打雷劈】小心，闪电要劈下来啦！", english = "[Thunderstorm]" },
        effect = function()
            for i, player in ipairs(AllPlayers) do
                if player then
                    TheWorld:PushEvent("ms_lightningstrike", player:GetPosition())
                end
            end
        end,
        event_type = "negative"
    },
    {
        news = { formal = "【熔岩虫群】地表裂开，滚烫的熔岩虫喷涌而出！", playful = "【小火虫】这些虫子会着火，碰到就会被烧伤！", english = "[Lavae Swarm]" },
        effect = function()
            local player = TheSim:FindFirstEntityWithTag("player")
            if player then
                local x, y, z = player.Transform:GetWorldPosition()
                for i = 1, 8 do
                    local lavae = SpawnPrefab("lavae")
                    if lavae then lavae.Transform:SetPosition(x + math.random(-20, 20), 0, z + math.random(-20, 20)) end
                end
            end
        end,
        event_type = "negative"
    },
    {
        news = { formal = "【兔人狂暴】平时温顺的兔人突然红眼，向你扑来！", playful = "【兔兔咬人】这些兔子疯了，快跑！", english = "[Bunnyman Rampage]" },
        effect = function()
            local player = TheSim:FindFirstEntityWithTag("player")
            if player then
                local x, y, z = player.Transform:GetWorldPosition()
                for i = 1, 8 do
                    local bunny = SpawnPrefab("bunnyman")
                    if bunny then 
                        bunny.Transform:SetPosition(x + math.random(-20, 20), 0, z + math.random(-20, 20))
                        if bunny.components.combat then bunny.components.combat:SuggestTarget(player) end
                    end
                end
            end
        end,
        event_type = "negative"
    },
    {
        news = { formal = "【克劳斯降临】沉重的脚步声响起，克劳斯带着它的鹿来了！", playful = "【无眼鹿来了】它背着大包，但绝对不好惹！", english = "[Klaus Arrives]" },
        effect = function()
            local player = TheSim:FindFirstEntityWithTag("player")
            if player then
                local x, y, z = player.Transform:GetWorldPosition()
                local klaus = SpawnPrefab("klaus")
                if klaus then klaus.Transform:SetPosition(x + math.random(-15, 15), 0, z + math.random(-15, 15)) end
            end
        end,
        event_type = "negative"
    },
    {
        news = { formal = "【蚁狮愤怒】沙漠的王者发怒了，沙尘暴即将吞噬一切！", playful = "【沙子怪】它在地下发脾气，小心地陷！", english = "[Antlion's Wrath]" },
        effect = function()
            local player = TheSim:FindFirstEntityWithTag("player")
            if player then
                local x, y, z = player.Transform:GetWorldPosition()
                local antlion = SpawnPrefab("antlion")
                if antlion then antlion.Transform:SetPosition(x + math.random(-15, 15), 0, z + math.random(-15, 15)) end
            end
        end,
        event_type = "negative"
    },
    {
        news = { formal = "【瘟疫蔓延】空气中弥漫着腐臭，你开始持续掉血！", playful = "【生病了】这风有毒，快找药草！", english = "[Plague]" },
        effect = function()
            for i, player in ipairs(AllPlayers) do
                if player and player.components.health then
                    player.components.health:DoDelta(-20)
                end
            end
        end,
        event_type = "negative"
    },
    {
        news = { formal = "【武器腐蚀】强酸雨腐蚀了你的武器！", playful = "【装备坏了】你的武器攻击力下降了！", english = "[Acid Rain]" },
        effect = function()
            for i, player in ipairs(AllPlayers) do
                if player and player.components.combat then
                    player.components.combat.damagemultiplier = 0.5
                    player:DoTaskInTime(60, function()
                        if player and player.components.combat then
                            player.components.combat.damagemultiplier = 1
                        end
                    end)
                end
            end
        end,
        event_type = "negative"
    },
    {
        news = { formal = "【双腿灌铅】神秘力量缠绕了你的双腿！", playful = "【走不动了】你感觉步履维艰，移速大幅下降！", english = "[Heavy Legs]" },
        effect = function()
            for i, player in ipairs(AllPlayers) do
                if player and player.components.locomotor then
                    player.components.locomotor:SetExternalSpeedMultiplier(player, "disaster_slow", 0.5)
                    player:DoTaskInTime(60, function()
                        if player and player.components.locomotor then
                            player.components.locomotor:RemoveExternalSpeedMultiplier(player, "disaster_slow")
                        end
                    end)
                end
            end
        end,
        event_type = "negative"
    },
    {
        news = { formal = "【震耳欲聋】巨大的轰鸣声让你头疼欲裂！", playful = "【吵死了】这声音让你精神涣散！", english = "[Deafening Roar]" },
        effect = function()
            for i, player in ipairs(AllPlayers) do
                if player and player.components.sanity then
                    player.components.sanity:DoDelta(-50)
                end
            end
        end,
        event_type = "negative"
    },
    {
        news = { formal = "【龙蝇苏醒】火山爆发，龙蝇从岩浆中飞出！", playful = "【大火龙】终极BOSS来了，快跑啊！", english = "[Dragonfly Awakens]" },
        effect = function()
            local player = TheSim:FindFirstEntityWithTag("player")
            if player then
                local x, y, z = player.Transform:GetWorldPosition()
                local dfly = SpawnPrefab("dragonfly")
                if dfly then dfly.Transform:SetPosition(x + math.random(-15, 15), 0, z + math.random(-15, 15)) end
            end
        end,
        event_type = "negative"
    },
    {
        news = { formal = "【蜂后狂怒】巨大的蜂巢震动，蜂后降临！", playful = "【大蜜蜂】被它蛰一下你就没了！", english = "[Bee Queen Fury]" },
        effect = function()
            local player = TheSim:FindFirstEntityWithTag("player")
            if player then
                local x, y, z = player.Transform:GetWorldPosition()
                local queen = SpawnPrefab("beequeen")
                if queen then queen.Transform:SetPosition(x + math.random(-15, 15), 0, z + math.random(-15, 15)) end
            end
        end,
        event_type = "negative"
    },
    {
        news = { formal = "【触手陷阱】地面瞬间变成触手丛林！", playful = "【密密麻麻】到处都是触手，根本没地方站脚！", english = "[Tentacle Trap]" },
        effect = function()
            local player = TheSim:FindFirstEntityWithTag("player")
            if player then
                local x, y, z = player.Transform:GetWorldPosition()
                for i = 1, 15 do
                    local t = SpawnPrefab("tentacle")
                    if t then t.Transform:SetPosition(x + math.random(-30, 30), 0, z + math.random(-30, 30)) end
                end
            end
        end,
        event_type = "negative"
    },
    {
        news = { formal = "【暗影之手】无数只暗影手从地底伸出，试图抓住你！", playful = "【抓脚踝】小心脚下，有东西在拉你！", english = "[Shadow Hands]" },
        effect = function()
            local player = TheSim:FindFirstEntityWithTag("player")
            if player then
                local x, y, z = player.Transform:GetWorldPosition()
                for i = 1, 5 do
                    local hand = SpawnPrefab("shadowtentacle")
                    if hand then hand.Transform:SetPosition(x + math.random(-15, 15), 0, z + math.random(-15, 15)) end
                end
            end
        end,
        event_type = "negative"
    },
    {
        news = { formal = "【强制入夜】太阳被黑暗吞噬，直接进入黑夜！", playful = "【天黑啦】没有火把的话，你什么都看不见！", english = "[Sudden Night]" },
        effect = function()
            if TheWorld.state.isday then
                TheWorld:PushEvent("ms_setphase", "night")
            end
        end,
        event_type = "negative"
    },
    {
        news = { formal = "【发条风暴】失控的齿轮零件四处乱飞，发条生物成群结队！", playful = "【机器人开会】这次不仅有大有小，还全来了！", english = "[Clockwork Storm]" },
        effect = function()
            local player = TheSim:FindFirstEntityWithTag("player")
            if player then
                local x, y, z = player.Transform:GetWorldPosition()
                for i = 1, 2 do
                    local k = SpawnPrefab("knight")
                    if k then k.Transform:SetPosition(x + math.random(-20, 20), 0, z + math.random(-20, 20)) end
                    local b = SpawnPrefab("bishop")
                    if b then b.Transform:SetPosition(x + math.random(-20, 20), 0, z + math.random(-20, 20)) end
                    local r = SpawnPrefab("rook")
                    if r then r.Transform:SetPosition(x + math.random(-20, 20), 0, z + math.random(-20, 20)) end
                end
            end
        end,
        event_type = "negative"
    },
    {
        news = { formal = "【食物消失】一股神秘力量偷走了你的食物！", playful = "【谁偷了我的饭】你身上的食物被偷走了一半！", english = "[Food Thief]" },
        effect = function()
            for i, player in ipairs(AllPlayers) do
                if player and player.components.inventory then
                    local items = player.components.inventory:FindItems(function(item) return item.components.edible ~= nil end)
                    for _, item in ipairs(items) do
                        if math.random() > 0.5 then
                            item:Remove()
                        end
                    end
                end
            end
        end,
        event_type = "negative"
    },
    {
        news = { formal = "【被诅咒的饥饿】你的身体无法吸收营养，饥饿感翻倍！", playful = "【吃不饱】你今天怎么吃都吃不饱！", english = "[Cursed Hunger]" },
        effect = function()
            for i, player in ipairs(AllPlayers) do
                if player and player.components.hunger then
                    player.components.hunger:DoDelta(-150)
                end
            end
        end,
        event_type = "negative"
    },
    {
        news = { formal = "【冰封大地】寒冰从你的脚下蔓延，你被冻在原地！", playful = "【冻住了】你的脚被冰封，短时间内无法移动！", english = "[Frozen Ground]" },
        effect = function()
            for i, player in ipairs(AllPlayers) do
                if player and player.components.locomotor then
                    player.components.locomotor:SetExternalSpeedMultiplier(player, "disaster_freeze", 0)
                    player:DoTaskInTime(3, function()
                        if player and player.components.locomotor then
                            player.components.locomotor:RemoveExternalSpeedMultiplier(player, "disaster_freeze")
                        end
                    end)
                end
            end
        end,
        event_type = "negative"
    },
    {
        news = { formal = "【狂乱】你陷入了无法控制的恐惧与狂乱！", playful = "【疯了】你的视野变得扭曲，小心周围的人！", english = "[Panic Attack]" },
        effect = function()
            for i, player in ipairs(AllPlayers) do
                if player and player.components.sanity then
                    player.components.sanity:DoDelta(-80)
                end
            end
        end,
        event_type = "negative"
    },
    {
        news = { formal = "【下雨啦】虽然不是暴雨，但是也够烦人的！", playful = "【湿哒哒】这雨下个不停，真讨厌！", english = "[Rainy Day]" },
        effect = function()
            for i, player in ipairs(AllPlayers) do
                if player and player.components.moisture then
                    player.components.moisture:DoDelta(30)
                end
            end
        end,
        event_type = "negative"
    },
    {
        news = { formal = "【蚊子叮咬】蚊子在耳边嗡嗡作响，不断攻击你！", playful = "【吸血大军】这群蚊子要把你榨干了！", english = "[Mosquito Bites]" },
        effect = function()
            local player = TheSim:FindFirstEntityWithTag("player")
            if player then
                local x, y, z = player.Transform:GetWorldPosition()
                for i = 1, 12 do
                    local m = SpawnPrefab("mosquito")
                    if m then m.Transform:SetPosition(x + math.random(-10, 10), 0, z + math.random(-10, 10)) end
                end
            end
        end,
        event_type = "negative"
    },
    {
        news = { formal = "【熔岩喷发】地面裂开，滚烫的岩浆喷涌而出！", playful = "【烫脚】地上冒出好多火，小心被烧到！", english = "[Lava Eruption]" },
        effect = function()
            local player = TheSim:FindFirstEntityWithTag("player")
            if player then
                local x, y, z = player.Transform:GetWorldPosition()
                for i = 1, 5 do
                    local f = SpawnPrefab("fire")
                    if f then f.Transform:SetPosition(x + math.random(-20, 20), 0, z + math.random(-20, 20)) end
                end
            end
        end,
        event_type = "negative"
    },
    {
        news = { formal = "【发条主教审判】主教瞄准了你！", playful = "【激光锁定】快躲开，有激光扫过来了！", english = "[Bishop's Judgment]" },
        effect = function()
            local player = TheSim:FindFirstEntityWithTag("player")
            if player then
                local x, y, z = player.Transform:GetWorldPosition()
                for i = 1, 4 do
                    local b = SpawnPrefab("bishop")
                    if b then b.Transform:SetPosition(x + math.random(-20, 20), 0, z + math.random(-20, 20)) end
                end
            end
        end,
        event_type = "negative"
    },
    {
        news = { formal = "【触手突袭】脚下的土地变成了沼泽！", playful = "【水下有东西】小心触手突然冒出来打你！", english = "[Tentacle Ambush]" },
        effect = function()
            local player = TheSim:FindFirstEntityWithTag("player")
            if player then
                local x, y, z = player.Transform:GetWorldPosition()
                for i = 1, 8 do
                    local t = SpawnPrefab("tentacle")
                    if t then t.Transform:SetPosition(x + math.random(-15, 15), 0, z + math.random(-15, 15)) end
                end
            end
        end,
        event_type = "negative"
    },
    {
        news = { formal = "【饥饿噩梦】你的梦魇中全是食物！", playful = "【梦到好吃的】醒来却发现自己更饿了！", english = "[Hunger Nightmare]" },
        effect = function()
            for i, player in ipairs(AllPlayers) do
                if player and player.components.sanity then
                    player.components.sanity:DoDelta(-20)
                end
                if player and player.components.hunger then
                    player.components.hunger:DoDelta(-50)
                end
            end
        end,
        event_type = "negative"
    },
    {
        news = { formal = "【发条战车冲撞】战车向你冲过来了！", playful = "【快躲开】被撞一下会飞很远的！", english = "[Rook Charge]" },
        effect = function()
            local player = TheSim:FindFirstEntityWithTag("player")
            if player then
                local x, y, z = player.Transform:GetWorldPosition()
                for i = 1, 4 do
                    local r = SpawnPrefab("rook")
                    if r then r.Transform:SetPosition(x + math.random(-20, 20), 0, z + math.random(-20, 20)) end
                end
            end
        end,
        event_type = "negative"
    },
	    {
        news = { formal = "【雷劫降临】天空中雷云密布，闪电正在追踪你！", playful = "【天打雷劈】快跑！雷公发怒了，专劈活人！", english = "[Lightning Wrath]" },
        effect = function()
            local player = TheSim:FindFirstEntityWithTag("player")
            if player then
                for i = 1, 3 do
                    TheWorld:DoTaskInTime(i * 0.5, function()
                        if player and player:IsValid() then
                            TheWorld:PushEvent("ms_lightningstrike", player:GetPosition())
                        end
                    end)
                end
            end
        end,
        event_type = "negative"
    },
    {
        news = { formal = "【酸雨腐蚀】天空中下起了绿色的毒雨，装备正在被腐蚀！", playful = "【掉漆了】这雨有毒！赶紧躲进洞穴或者找地方避雨！", english = "[Acid Rain]" },
        effect = function()
            for i, player in ipairs(AllPlayers) do
                if player and player.components.inventory then
                    local items = player.components.inventory:FindItems(function(item) return item.components.finiteuses ~= nil end)
                    for _, item in ipairs(items) do
                        item.components.finiteuses:Use(1)
                    end
                end
                if player and player.components.moisture then player.components.moisture:DoDelta(50) end
            end
        end,
        event_type = "negative"
    },
    {
        news = { formal = "【天体陨星】天体能量紊乱，巨大的陨石砸向了岛屿！", playful = "【天降正义】流星不是用来许愿的，是用来砸头的！", english = "[Meteor Shower]" },
        effect = function()
            local player = TheSim:FindFirstEntityWithTag("player")
            if player then
                local x, y, z = player.Transform:GetWorldPosition()
                for i = 1, 6 do
                    local meteor = SpawnPrefab("meteor")
                    if meteor then meteor.Transform:SetPosition(x + math.random(-15, 15), 0, z + math.random(-15, 15)) end
                end
            end
        end,
        event_type = "negative"
    },
    {
        news = { formal = "【暗影棋子】麦斯威尔的暗影棋子苏醒了，准备将你将死！", playful = "【国际象棋】会动的棋子上门了，小心主教和骑士！", english = "[Shadow Pieces]" },
        effect = function()
            local player = TheSim:FindFirstEntityWithTag("player")
            if player then
                local x, y, z = player.Transform:GetWorldPosition()
                local p = SpawnPrefab("shadow_pawn")
                if p then p.Transform:SetPosition(x + math.random(-10, 10), 0, z + math.random(-10, 10)) end
                local r = SpawnPrefab("shadow_rook")
                if r then r.Transform:SetPosition(x + math.random(-15, 15), 0, z + math.random(-15, 15)) end
                local k = SpawnPrefab("shadow_knight")
                if k then k.Transform:SetPosition(x + math.random(-15, 15), 0, z + math.random(-15, 15)) end
            end
        end,
        event_type = "negative"
    },
    {
        news = { formal = "【克劳斯的冰火鹿】克劳斯的冰火双鹿跑出来了，冰火两重天！", playful = "【冰火两重天】一红一蓝，追着你喷！", english = "[Klaus's Deer]" },
        effect = function()
            local player = TheSim:FindFirstEntityWithTag("player")
            if player then
                local x, y, z = player.Transform:GetWorldPosition()
                local fire = SpawnPrefab("deer_fire")
                if fire then fire.Transform:SetPosition(x + math.random(-10, 10), 0, z + math.random(-10, 10)) end
                local ice = SpawnPrefab("deer_ice")
                if ice then ice.Transform:SetPosition(x + math.random(-10, 10), 0, z + math.random(-10, 10)) end
            end
        end,
        event_type = "negative"
    },
    {
        news = { formal = "【毒菌孢子】毒菌蟾蜍释放了漫天毒孢，空气变得致命！", playful = "【蘑菇云】别呼吸！那是毒蘑菇的孢子！", english = "[Toadstool Spores]" },
        effect = function()
            local player = TheSim:FindFirstEntityWithTag("player")
            if player then
                local x, y, z = player.Transform:GetWorldPosition()
                for i = 1, 10 do
                    local spore = SpawnPrefab("spore")
                    if spore then spore.Transform:SetPosition(x + math.random(-15, 15), 0, z + math.random(-15, 15)) end
                end
            end
        end,
        event_type = "negative"
    },
    {
        news = { formal = "【月灵暴动】月圆之夜，灵体狂暴化，疯狂的月灵正在搜寻肉体！", playful = "【小月灵】它们平时很可爱，现在要你的命！", english = "[Gestalt Rampage]" },
        effect = function()
            local player = TheSim:FindFirstEntityWithTag("player")
            if player then
                local x, y, z = player.Transform:GetWorldPosition()
                for i = 1, 8 do
                    local gestalt = SpawnPrefab("gestalt")
                    if gestalt then gestalt.Transform:SetPosition(x + math.random(-20, 20), 0, z + math.random(-20, 20)) end
                end
            end
        end,
        event_type = "negative"
    },
    {
        news = { formal = "【狂暴发条】发条战车彻底失控，正在横冲直撞！", playful = "【无人驾驶】这台破车停不下来了，快躲开！", english = "[Rampaging Rook]" },
        effect = function()
            local player = TheSim:FindFirstEntityWithTag("player")
            if player then
                local x, y, z = player.Transform:GetWorldPosition()
                for i = 1, 5 do
                    local rook = SpawnPrefab("rook")
                    if rook then rook.Transform:SetPosition(x + math.random(-20, 20), 0, z + math.random(-20, 20)) end
                end
            end
        end,
        event_type = "negative"
    },
    {
        news = { formal = "【大嘴怪异变】大嘴怪变异了，它的嘴巴能吞下一切！", playful = "【血盆大口】别被咬到，一口半管血！", english = "[Mutated Hound]" },
        effect = function()
            local player = TheSim:FindFirstEntityWithTag("player")
            if player then
                local x, y, z = player.Transform:GetWorldPosition()
                for i = 1, 6 do
                    local hound = SpawnPrefab("mutatedhound")
                    if hound then hound.Transform:SetPosition(x + math.random(-15, 15), 0, z + math.random(-15, 15)) end
                end
            end
        end,
        event_type = "negative"
    },
    {
        news = { formal = "【雪怪突袭】极地雪怪被唤醒，巨大的拳头砸向地面！", playful = "【大猩猩】这玩意儿皮糙肉厚，打人贼疼！", english = "[Snow Monster]" },
        effect = function()
            local player = TheSim:FindFirstEntityWithTag("player")
            if player then
                local x, y, z = player.Transform:GetWorldPosition()
                local monster = SpawnPrefab("snowman")
                if monster then monster.Transform:SetPosition(x + math.random(-15, 15), 0, z + math.random(-15, 15)) end
            end
        end,
        event_type = "negative"
    },
    {
        news = { formal = "【洞穴地震】地底深处传来轰鸣，大地开始剧烈颤抖！", playful = "【地震啦】地上的东西都要掉下去了！", english = "[Cave Earthquake]" },
        effect = function()
            for i, player in ipairs(AllPlayers) do
                if player then
                    player:PushEvent("ms_earthquake")
                end
            end
        end,
        event_type = "negative"
    },
    {
        news = { formal = "【暗影触手】恶意的暗影能量化作触手，从你的影子里钻出！", playful = "【影子怪物】你的影子活了，还在打你！", english = "[Shadow Tentacles]" },
        effect = function()
            for i, player in ipairs(AllPlayers) do
                if player then
                    local x, y, z = player.Transform:GetWorldPosition()
                    local t = SpawnPrefab("shadowtentacle")
                    if t then t.Transform:SetPosition(x + math.random(-5, 5), 0, z + math.random(-5, 5)) end
                end
            end
        end,
        event_type = "negative"
    },
    {
        news = { formal = "【精神错乱】未知的恐惧直击灵魂，你的理智瞬间清零！", playful = "【脑子进水了】你疯了，眼前的怪物全是真的！", english = "[Mind Shatter]" },
        effect = function()
            for i, player in ipairs(AllPlayers) do
                if player and player.components.sanity then
                    player.components.sanity:SetPercent(0)
                end
            end
        end,
        event_type = "negative"
    },
    {
        news = { formal = "【强制冬眠】气温骤降至冰点以下，寒冷正在吞噬你的生命！", playful = "【冷冷冷】这鬼天气，没火堆你必死无疑！", english = "[Flash Freeze]" },
        effect = function()
            for i, player in ipairs(AllPlayers) do
                if player and player.components.temperature then
                    player.components.temperature:SetTemperature(-20)
                end
                if player and player.components.moisture then player.components.moisture:DoDelta(100) end
            end
        end,
        event_type = "negative"
    },
    {
        news = { formal = "【烈焰地狱】热浪席卷全岛，连呼吸都像是在吞火！", playful = "【热死啦】衣服都要烧起来了，快找冰！", english = "[Scorching Hell]" },
        effect = function()
            for i, player in ipairs(AllPlayers) do
                if player and player.components.temperature then
                    player.components.temperature:SetTemperature(90)
                end
            end
        end,
        event_type = "negative"
    },
    {
        news = { formal = "【武器碎裂】巨大的冲击波震碎了你们的武器！", playful = "【家当碎了】武器全坏了，用拳头打吗？", english = "[Weapon Shatter]" },
        effect = function()
            for i, player in ipairs(AllPlayers) do
                if player and player.components.inventory then
                    local items = player.components.inventory:FindItems(function(item) return item.components.weapon ~= nil end)
                    for _, item in ipairs(items) do
                        if item.components.finiteuses then item.components.finiteuses:SetPercent(0) end
                    end
                end
            end
        end,
        event_type = "negative"
    },
    {
        news = { formal = "【护甲腐蚀】一股酸液腐蚀了所有人的护甲！", playful = "【裸奔吧】护甲全烂了，一碰就碎！", english = "[Armor Corrosion]" },
        effect = function()
            for i, player in ipairs(AllPlayers) do
                if player and player.components.inventory then
                    local items = player.components.inventory:FindItems(function(item) return item.components.armor ~= nil end)
                    for _, item in ipairs(items) do
                        if item.components.finiteuses then item.components.finiteuses:SetPercent(0) end
                    end
                end
            end
        end,
        event_type = "negative"
    },
    {
        news = { formal = "【重力加倍】大地变得无比沉重，连走路都困难！", playful = "【走不动啦】腿像灌了铅一样！", english = "[Double Gravity]" },
        effect = function()
            for i, player in ipairs(AllPlayers) do
                if player and player.components.locomotor then
                    player.components.locomotor:SetExternalSpeedMultiplier(player, "disaster_heavy", 0.5)
                    player:DoTaskInTime(60, function()
                        if player and player.components.locomotor then
                            player.components.locomotor:RemoveExternalSpeedMultiplier(player, "disaster_heavy")
                        end
                    end)
                end
            end
        end,
        event_type = "negative"
    },
    {
        news = { formal = "【食物腐化】空气中弥漫着恶臭，你的食物瞬间变成了烂泥！", playful = "【臭气熏天】没吃的了，准备饿肚子吧！", english = "[Mass Rot]" },
        effect = function()
            for i, player in ipairs(AllPlayers) do
                if player and player.components.inventory then
                    local items = player.components.inventory:FindItems(function(item) return item.components.perishable ~= nil end)
                    for _, item in ipairs(items) do
                        item.components.perishable:SetPercent(0)
                    end
                end
            end
        end,
        event_type = "negative"
    },
    {
        news = { formal = "【虚空吞噬】你的背包被虚空裂缝吞噬，物品正在消失！", playful = "【背包漏了】你身上的东西一件件掉进了黑洞！", english = "[Void Consumption]" },
        effect = function()
            for i, player in ipairs(AllPlayers) do
                if player and player.components.inventory then
                    local items = player.components.inventory:GetItems()
                    for _, item in ipairs(items) do
                        if math.random() < 0.3 then item:Remove() end
                    end
                end
            end
        end,
        event_type = "negative"
    },
    {
        news = { formal = "【永夜降临】太阳彻底熄灭，无尽的黑暗笼罩了岛屿！", playful = "【彻底黑了】没有光，你什么都看不见！", english = "[Eternal Night]" },
        effect = function()
            TheWorld:PushEvent("ms_setphase", "night")
            TheWorld:PushEvent("ms_lockphase", "night")
            TheWorld:DoTaskInTime(120, function() TheWorld:PushEvent("ms_unlockphase") end)
        end,
        event_type = "negative"
    },
    {
        news = { formal = "【青蛙暴雨】铺天盖地的青蛙从云层中砸下，它们饿疯了！", playful = "【呱呱大军】这不是雨，这是青蛙！", english = "[Frog Monsoon]" },
        effect = function()
            for i, player in ipairs(AllPlayers) do
                if player then
                    local x, y, z = player.Transform:GetWorldPosition()
                    for j = 1, 10 do
                        local f = SpawnPrefab("frog")
                        if f then f.Transform:SetPosition(x + math.random(-20, 20), 0, z + math.random(-20, 20)) end
                    end
                end
            end
        end,
        event_type = "negative"
    },
    {
        news = { formal = "【蜘蛛狂潮】地下涌出海量的蜘蛛，它们正在无差别攻击！", playful = "【八脚怪海】密密麻麻全是蜘蛛，快跑！", english = "[Spider Tide]" },
        effect = function()
            for i, player in ipairs(AllPlayers) do
                if player then
                    local x, y, z = player.Transform:GetWorldPosition()
                    for j = 1, 12 do
                        local s = SpawnPrefab("spider")
                        if s then s.Transform:SetPosition(x + math.random(-25, 25), 0, z + math.random(-25, 25)) end
                    end
                end
            end
        end,
        event_type = "negative"
    },
    {
        news = { formal = "【猪人背叛】原本中立的猪人突然发狂，开始攻击所有人类！", playful = "【二师兄疯了】见人就打，不讲武德！", english = "[Pig Betrayal]" },
        effect = function()
            for i, player in ipairs(AllPlayers) do
                if player then
                    local x, y, z = player.Transform:GetWorldPosition()
                    for j = 1, 6 do
                        local p = SpawnPrefab("pigman")
                        if p then 
                            p.Transform:SetPosition(x + math.random(-15, 15), 0, z + math.random(-15, 15))
                            if p.components.combat then p.components.combat:SuggestTarget(player) end
                        end
                    end
                end
            end
        end,
        event_type = "negative"
    },
    {
        news = { formal = "【鱼人入侵】鱼人带着长矛从水里冲出来，要找你决斗！", playful = "【长矛鱼鱼】它们上岸了，准备战斗！", english = "[Merm Invasion]" },
        effect = function()
            for i, player in ipairs(AllPlayers) do
                if player then
                    local x, y, z = player.Transform:GetWorldPosition()
                    for j = 1, 8 do
                        local m = SpawnPrefab("merm")
                        if m then m.Transform:SetPosition(x + math.random(-20, 20), 0, z + math.random(-20, 20)) end
                    end
                end
            end
        end,
        event_type = "negative"
    },
    {
        news = { formal = "【暗影侵蚀】你们的影子被暗影力量吞噬，化为恐怖的怪物！", playful = "【影子活了】快看地上，影子在动！", english = "[Shadow Erosion]" },
        effect = function()
            for i, player in ipairs(AllPlayers) do
                if player then
                    local x, y, z = player.Transform:GetWorldPosition()
                    for j = 1, 3 do
                        local s = SpawnPrefab("crawlinghorror")
                        if s then s.Transform:SetPosition(x + math.random(-10, 10), 0, z + math.random(-10, 10)) end
                    end
                end
            end
        end,
        event_type = "negative"
    },
    {
        news = { formal = "【陨石雨】天空中的星辰坠落，燃烧的陨石正砸向你们！", playful = "【流星砸头】快许愿，愿望是别被砸死！", english = "[Meteor Shower]" },
        effect = function()
            for i, player in ipairs(AllPlayers) do
                if player then
                    local x, y, z = player.Transform:GetWorldPosition()
                    for j = 1, 5 do
                        local m = SpawnPrefab("meteor")
                        if m then m.Transform:SetPosition(x + math.random(-20, 20), 0, z + math.random(-20, 20)) end
                    end
                end
            end
        end,
        event_type = "negative"
    },
    {
        news = { formal = "【雷暴连环】闪电如同暴雨般落下，这片区域成了雷区！", playful = "【天雷滚滚】小心别被雷劈了！", english = "[Lightning Storm]" },
        effect = function()
            for i, player in ipairs(AllPlayers) do
                if player then
                    for j = 1, 5 do
                        TheWorld:DoTaskInTime(j * 0.5, function()
                            if player and player:IsValid() then
                                TheWorld:PushEvent("ms_lightningstrike", player:GetPosition())
                            end
                        end)
                    end
                end
            end
        end,
        event_type = "negative"
    },
    {
        news = { formal = "【极寒风暴】暴风雪突然降临，温度骤降，滴水成冰！", playful = "【好冷啊】冻成狗了，快烤火！", english = "[Blizzard]" },
        effect = function()
            for i, player in ipairs(AllPlayers) do
                if player and player.components.temperature then
                    player.components.temperature:DoDelta(-30)
                end
            end
        end,
        event_type = "negative"
    },
    {
        news = { formal = "【饥饿诅咒】你的胃仿佛无底洞，饥饿感成倍增加！", playful = "【吃不饱】刚吃完又饿了，真难受！", english = "[Hunger Curse]" },
        effect = function()
            for i, player in ipairs(AllPlayers) do
                if player and player.components.hunger then
                    player.components.hunger:DoDelta(-120)
                end
            end
        end,
        event_type = "negative"
    },
    {
        news = { formal = "【精神污染】不可名状的声音在你的脑海中回荡，理智急速流失！", playful = "【脑壳疼】有什么东西在偷看我的脑子！", english = "[Mind Pollution]" },
        effect = function()
            for i, player in ipairs(AllPlayers) do
                if player and player.components.sanity then
                    player.components.sanity:DoDelta(-80)
                end
            end
        end,
        event_type = "negative"
    },
    {
        news = { formal = "【武器失效】神秘的力场干扰了武器，你们的攻击变得软弱无力！", playful = "【没力气了】武器拿不动了，快用拳头！", english = "[Weapon Jam]" },
        effect = function()
            for i, player in ipairs(AllPlayers) do
                if player and player.components.combat then
                    player.components.combat.damagemultiplier = 0.2
                    player:DoTaskInTime(30, function()
                        if player and player.components.combat then
                            player.components.combat.damagemultiplier = 1
                        end
                    end)
                end
            end
        end,
        event_type = "negative"
    },
    {
        news = { formal = "【触手突袭】你以为安全的地面突然伸出无数触手！", playful = "【好多触手】到处都是触手，没地方跑了！", english = "[Tentacle Ambush]" },
        effect = function()
            for i, player in ipairs(AllPlayers) do
                if player then
                    local x, y, z = player.Transform:GetWorldPosition()
                    for j = 1, 10 do
                        local t = SpawnPrefab("tentacle")
                        if t then t.Transform:SetPosition(x + math.random(-20, 20), 0, z + math.random(-20, 20)) end
                    end
                end
            end
        end,
        event_type = "negative"
    },
    {
        news = { formal = "【巨型野猪】一头狂暴的巨型野猪冲破了丛林，向你冲来！", playful = "【大野猪】被它拱一下，人就没了！", english = "[Giant Boar]" },
        effect = function()
            for i, player in ipairs(AllPlayers) do
                if player then
                    local x, y, z = player.Transform:GetWorldPosition()
                    local b = SpawnPrefab("boaron")
                    if b then b.Transform:SetPosition(x + math.random(-15, 15), 0, z + math.random(-15, 15)) end
                end
            end
        end,
        event_type = "negative"
    },
    {
        news = { formal = "【发条风暴】遗迹的守护机械全部出动了！", playful = "【机器人军团】破铜烂铁全来了，快跑！", english = "[Clockwork Storm]" },
        effect = function()
            for i, player in ipairs(AllPlayers) do
                if player then
                    local x, y, z = player.Transform:GetWorldPosition()
                    local k = SpawnPrefab("knight")
                    if k then k.Transform:SetPosition(x + math.random(-15, 15), 0, z + math.random(-15, 15)) end
                    local b = SpawnPrefab("bishop")
                    if b then b.Transform:SetPosition(x + math.random(-15, 15), 0, z + math.random(-15, 15)) end
                    local r = SpawnPrefab("rook")
                    if r then r.Transform:SetPosition(x + math.random(-15, 15), 0, z + math.random(-15, 15)) end
                end
            end
        end,
        event_type = "negative"
    },
    {
        news = { formal = "【暗影之手】无数暗影手从地底伸出，试图将你拖入深渊！", playful = "【抓脚踝】有东西在拉你的脚！", english = "[Shadow Hands]" },
        effect = function()
            for i, player in ipairs(AllPlayers) do
                if player then
                    local x, y, z = player.Transform:GetWorldPosition()
                    for j = 1, 5 do
                        local h = SpawnPrefab("shadowtentacle")
                        if h then h.Transform:SetPosition(x + math.random(-15, 15), 0, z + math.random(-15, 15)) end
                    end
                end
            end
        end,
        event_type = "negative"
    },
    {
        news = { formal = "【毒气弥漫】一股绿色的毒气弥漫开来，你们的生命正在流逝！", playful = "【中毒了】快捂住口鼻，这气味有毒！", english = "[Poison Gas]" },
        effect = function()
            for i, player in ipairs(AllPlayers) do
                if player and player.components.health then
                    player.components.health:DoDelta(-30)
                end
            end
        end,
        event_type = "negative"
    },
    {
        news = { formal = "【潮汐暴涨】海水突然上涨，小岛正在被淹没！", playful = "【涨水啦】再不跑就被淹死了！", english = "[Rising Tide]" },
        effect = function()
            for i, player in ipairs(AllPlayers) do
                if player and player.components.moisture then
                    player.components.moisture:SetPercent(1)
                end
                if player and player.components.locomotor then
                    player.components.locomotor:SetExternalSpeedMultiplier(player, "disaster_water", 0.6)
                    player:DoTaskInTime(30, function()
                        if player and player.components.locomotor then
                            player.components.locomotor:RemoveExternalSpeedMultiplier(player, "disaster_water")
                        end
                    end)
                end
            end
        end,
        event_type = "negative"
    },
	    {
        news = {
            formal = "【大灾变降临】血月升起，世界陷入永恒的黑暗与满月！",
            playful = "【血月当空】红月亮的诅咒！理智狂掉，食物腐烂翻倍！",
            english = "[Aporkalypse] The blood moon rises, the world falls into eternal darkness and full moon!"
        },
        effect = function()
            -- 强制锁定为满月，并进入夜晚（模拟大灾变）
            TheWorld:PushEvent("ms_setphase", "night")
            TheWorld:PushEvent("ms_lockphase", "night")
            TheWorld:PushEvent("ms_forcenextfullmoon")
            TheWorld:DoTaskInTime(120, function() TheWorld:PushEvent("ms_unlockphase") end)
        end,
        event_type = "negative"
    },
    {
        news = {
            formal = "【兔人魔化】低理智值触发了兔人的魔化，它们正以胡须领主之姿袭来！",
            playful = "【疯兔】你脑子不清醒，看谁都像怪物，兔兔真的来揍你了！",
            english = "[Bunnyman's Curse] Low sanity triggers the mutation, bunnymen attack as Beardlords!"
        },
        effect = function()
            local player = TheSim:FindFirstEntityWithTag("player")
            if player then
                local x, y, z = player.Transform:GetWorldPosition()
                for i = 1, 6 do
                    local bunny = SpawnPrefab("bunnyman")
                    if bunny then
                        bunny.Transform:SetPosition(x + math.random(-20, 20), 0, z + math.random(-20, 20))
                        if bunny.components.combat then bunny.components.combat:SuggestTarget(player) end
                    end
                end
            end
        end,
        event_type = "negative"
    },
    {
        news = {
            formal = "【疯猪狂潮】满月之力唤醒了猪人的野性，它们已彻底疯狂！",
            playful = "【猪突猛进】满月让猪猪们疯掉了，快跑！",
            english = "[Werepig Rampage] The full moon's power awakens the pigs' feral nature, they've gone mad!"
        },
        effect = function()
            local player = TheSim:FindFirstEntityWithTag("player")
            if player then
                local x, y, z = player.Transform:GetWorldPosition()
                for i = 1, 6 do
                    local pig = SpawnPrefab("pigman")
                    if pig then
                        pig.Transform:SetPosition(x + math.random(-20, 20), 0, z + math.random(-20, 20))
                        if pig.components.combat then pig.components.combat:SuggestTarget(player) end
                        pig:AddTag("werepig") -- 模拟变身状态
                    end
                end
            end
        end,
        event_type = "negative"
    },
    {
        news = {
            formal = "【月灵侵袭】启蒙值过高，月灵开始主动攻击！它们正冲向你！",
            playful = "【月灵冲撞】被那玩意儿撞到会减速，还会睡着！",
            english = "[Gestalt Assault] Enlightenment is too high, gestalts are attacking! They're charging at you!"
        },
        effect = function()
            local player = TheSim:FindFirstEntityWithTag("player")
            if player then
                local x, y, z = player.Transform:GetWorldPosition()
                for i = 1, 8 do
                    local gestalt = SpawnPrefab("gestalt")
                    if gestalt then
                        gestalt.Transform:SetPosition(x + math.random(-20, 20), 0, z + math.random(-20, 20))
                        -- 月灵会主动冲向玩家
                        if gestalt.components.combat then gestalt.components.combat:SuggestTarget(player) end
                    end
                end
            end
        end,
        event_type = "negative"
    },
    {
        news = {
            formal = "【蚁狮地陷】沙漠的蚁狮发怒了，地面正在开裂下陷！",
            playful = "【地塌了】快跑！蚁狮把你脚下的地给弄塌了！",
            english = "[Antlion's Sinkhole] The desert Antlion is enraged, the ground is caving in!"
        },
        effect = function()
            for i, player in ipairs(AllPlayers) do
                if player then
                    local x, y, z = player.Transform:GetWorldPosition()
                    -- 模拟地陷：在玩家脚下生成坍塌
                    local sinkhole = SpawnPrefab("sinkhole")
                    if sinkhole then sinkhole.Transform:SetPosition(x, 0, z) end
                end
            end
        end,
        event_type = "negative"
    },
    {
        news = {
            formal = "【沙尘暴】遮天蔽日的沙尘暴席卷而来，你的视线被严重遮蔽！",
            playful = "【吃沙子了】啥也看不见，走路还贼慢！",
            english = "[Sandstorm] A blinding sandstorm sweeps in, severely obscuring your vision!"
        },
        effect = function()
            for i, player in ipairs(AllPlayers) do
                if player and player.components.locomotor then
                    -- 沙尘暴导致移速降低和视野受限（模拟效果）
                    player.components.locomotor:SetExternalSpeedMultiplier(player, "disaster_sandstorm", 0.4)
                    player:DoTaskInTime(30, function()
                        if player and player.components.locomotor then
                            player.components.locomotor:RemoveExternalSpeedMultiplier(player, "disaster_sandstorm")
                        end
                    end)
                end
            end
        end,
        event_type = "negative"
    },
    {
        news = {
            formal = "【恐怖之眼】一只巨大的恐怖之眼在空中凝视着你！",
            playful = "【大眼珠子】它在看你！快跑，它还会下蛋孵小怪！",
            english = "[Eye of Terror] A giant Eye of Terror gazes at you from the sky!"
        },
        effect = function()
            local player = TheSim:FindFirstEntityWithTag("player")
            if player then
                local x, y, z = player.Transform:GetWorldPosition()
                local eye = SpawnPrefab("eyeplant")
                -- 注意：游戏内真正的恐怖之眼代码可能不同，这里用类似逻辑
                -- 更准确的代码可能是 "eyeofterror"
                local eye2 = SpawnPrefab("eyeofterror")
                if eye2 then
                    eye2.Transform:SetPosition(x + math.random(-10, 10), 0, z + math.random(-10, 10))
                end
            end
        end,
        event_type = "negative"
    },
    {
        news = {
            formal = "【可疑窥视者】恐怖之眼产下的蛋孵化了，大量可疑窥视者正在逼近！",
            playful = "【小眼怪】这些小家伙跑得贼快，还咬人！",
            english = "[Suspicious Peepers] Eggs laid by the Eye of Terror have hatched, a swarm of Suspicious Peepers approaches!"
        },
        effect = function()
            local player = TheSim:FindFirstEntityWithTag("player")
            if player then
                local x, y, z = player.Transform:GetWorldPosition()
                for i = 1, 8 do
                    local peeper = SpawnPrefab("suspiciouspeeper")
                    if peeper then peeper.Transform:SetPosition(x + math.random(-15, 15), 0, z + math.random(-15, 15)) end
                end
            end
        end,
        event_type = "negative"
    },
    {
        news = {
            formal = "【海盗猴来袭】海盗猴带着它们的船长从海上登陆了！",
            playful = "【猴子海盗】它们不仅抢东西，还打人！",
            english = "[Pirate Monkeys] Pirate monkeys and their captain have landed from the sea!"
        },
        effect = function()
            local player = TheSim:FindFirstEntityWithTag("player")
            if player then
                local x, y, z = player.Transform:GetWorldPosition()
                for i = 1, 5 do
                    local monkey = SpawnPrefab("monkey")
                    if monkey then monkey.Transform:SetPosition(x + math.random(-20, 20), 0, z + math.random(-20, 20)) end
                end
                local captain = SpawnPrefab("monkey_captain")
                if captain then captain.Transform:SetPosition(x + math.random(-10, 10), 0, z + math.random(-10, 10)) end
            end
        end,
        event_type = "negative"
    },
    {
        news = {
            formal = "【岩石白鲨】海中的岩石白鲨冲上了岸，它什么都咬！",
            playful = "【大白鲨】这玩意儿在陆地上也这么凶！",
            english = "[Rockjaw Shark] A Rockjaw Shark from the sea has come ashore, it bites everything!"
        },
        effect = function()
            local player = TheSim:FindFirstEntityWithTag("player")
            if player then
                local x, y, z = player.Transform:GetWorldPosition()
                for i = 1, 3 do
                    local shark = SpawnPrefab("rockjaw")
                    if shark then shark.Transform:SetPosition(x + math.random(-15, 15), 0, z + math.random(-15, 15)) end
                end
            end
        end,
        event_type = "negative"
    },
    {
        news = {
            formal = "【猪鼻蝠群】成群的猪鼻蝠从洞穴中飞出，它们的鼻子像猪，但它们是蝙蝠！",
            playful = "【飞天猪】这些家伙长得怪，咬人可疼了！",
            english = "[Pig Bats] Flocks of pig bats fly out of the caves, they have pig noses but they are bats!"
        },
        effect = function()
            local player = TheSim:FindFirstEntityWithTag("player")
            if player then
                local x, y, z = player.Transform:GetWorldPosition()
                for i = 1, 12 do
                    local bat = SpawnPrefab("pigbat")
                    if bat then bat.Transform:SetPosition(x + math.random(-20, 20), 0, z + math.random(-20, 20)) end
                end
            end
        end,
        event_type = "negative"
    },
    {
        news = {
            formal = "【远古蜈蚣】远古的蜈蚣被惊醒了，它正在地下快速穿行！",
            playful = "【千足虫】地底下有东西在爬，好多脚！",
            english = "[Ancient Centipede] The ancient centipede has been awakened, it's burrowing rapidly underground!"
        },
        effect = function()
            local player = TheSim:FindFirstEntityWithTag("player")
            if player then
                local x, y, z = player.Transform:GetWorldPosition()
                local centipede = SpawnPrefab("ancient_centipede")
                if centipede then centipede.Transform:SetPosition(x + math.random(-15, 15), 0, z + math.random(-15, 15)) end
            end
        end,
        event_type = "negative"
    },
    {
        news = {
            formal = "【破碎蜘蛛】月岛的破碎蜘蛛涌入了这片区域！",
            playful = "【玻璃蜘蛛】它们身上全是碎片，打人很疼！",
            english = "[Shattered Spiders] Shattered spiders from the moon island have swarmed into this area!"
        },
        effect = function()
            local player = TheSim:FindFirstEntityWithTag("player")
            if player then
                local x, y, z = player.Transform:GetWorldPosition()
                for i = 1, 6 do
                    local spider = SpawnPrefab("spider_moon")
                    if spider then spider.Transform:SetPosition(x + math.random(-20, 20), 0, z + math.random(-20, 20)) end
                end
            end
        end,
        event_type = "negative"
    },
    {
        news = {
            formal = "【月盲乌鸦】受到月亮影响的乌鸦变得极具攻击性，它们正在俯冲！",
            playful = "【疯乌鸦】天上的乌鸦都疯了，见人就啄！",
            english = "[Moonblind Crows] Moon-affected crows have become aggressive and are diving at you!"
        },
        effect = function()
            local player = TheSim:FindFirstEntityWithTag("player")
            if player then
                local x, y, z = player.Transform:GetWorldPosition()
                for i = 1, 10 do
                    local crow = SpawnPrefab("crow_moon")
                    if crow then crow.Transform:SetPosition(x + math.random(-20, 20), 0, z + math.random(-20, 20)) end
                end
            end
        end,
        event_type = "negative"
    },
    {
        news = {
            formal = "【水上蜘蛛】水面上的蜘蛛爬上了岸，它们在水上也能跑！",
            playful = "【水蜘蛛】它们从水里冲出来了，速度好快！",
            english = "[Water Spiders] Water spiders have come ashore, they can run on water too!"
        },
        effect = function()
            local player = TheSim:FindFirstEntityWithTag("player")
            if player then
                local x, y, z = player.Transform:GetWorldPosition()
                for i = 1, 8 do
                    local spider = SpawnPrefab("spider_water")
                    if spider then spider.Transform:SetPosition(x + math.random(-20, 20), 0, z + math.random(-20, 20)) end
                end
            end
        end,
        event_type = "negative"
    },
    {
        news = {
            formal = "【恐怖利爪】巨大的恐怖利爪从地下伸出，试图将你拖入深渊！",
            playful = "【大地之爪】地上冒出好多爪子，快躲开！",
            english = "[Terrorclaws] Giant terrorclaws reach up from underground, trying to drag you into the abyss!"
        },
        effect = function()
            local player = TheSim:FindFirstEntityWithTag("player")
            if player then
                local x, y, z = player.Transform:GetWorldPosition()
                for i = 1, 6 do
                    local claw = SpawnPrefab("terrorclaw")
                    if claw then claw.Transform:SetPosition(x + math.random(-20, 20), 0, z + math.random(-20, 20)) end
                end
            end
        end,
        event_type = "negative"
    },
    {
        news = {
            formal = "【奇形鸟俯冲】奇形鸟在空中盘旋后发起俯冲攻击！",
            playful = "【怪鸟俯冲】小心天上！那只怪鸟冲下来了！",
            english = "[Malbatross Dive] The malbatross circles in the air and begins its dive attack!"
        },
        effect = function()
            local player = TheSim:FindFirstEntityWithTag("player")
            if player then
                local x, y, z = player.Transform:GetWorldPosition()
                for i = 1, 4 do
                    local bird = SpawnPrefab("malbatross")
                    if bird then bird.Transform:SetPosition(x + math.random(-20, 20), 0, z + math.random(-20, 20)) end
                end
            end
        end,
        event_type = "negative"
    },
    {
        news = {
            formal = "【梦幻果蝇】果蝇王被激怒，它召唤了成群的梦幻果蝇！",
            playful = "【苍蝇大军】嗡嗡嗡！它们虽然不咬人，但烦死人了！",
            english = "[Dream Flies] The Lord of the Fruit Flies is enraged, summoning a swarm of dream flies!"
        },
        effect = function()
            local player = TheSim:FindFirstEntityWithTag("player")
            if player then
                local x, y, z = player.Transform:GetWorldPosition()
                for i = 1, 15 do
                    local fly = SpawnPrefab("flies")
                    if fly then fly.Transform:SetPosition(x + math.random(-25, 25), 0, z + math.random(-25, 25)) end
                end
            end
        end,
        event_type = "negative"
    },
    {
        news = {
            formal = "【青年座狼】一头青年座狼带着它的猎犬群出现了！",
            playful = "【小狗王】它虽然还小，但已经学会召唤小弟了！",
            english = "[Young Varg] A young Varg appears with its pack of hounds!"
        },
        effect = function()
            local player = TheSim:FindFirstEntityWithTag("player")
            if player then
                local x, y, z = player.Transform:GetWorldPosition()
                local varg = SpawnPrefab("warg")
                if varg then varg.Transform:SetPosition(x + math.random(-15, 15), 0, z + math.random(-15, 15)) end
                for i = 1, 4 do
                    local hound = SpawnPrefab("hound")
                    if hound then hound.Transform:SetPosition(x + math.random(-15, 15), 0, z + math.random(-15, 15)) end
                end
            end
        end,
        event_type = "negative"
    },
    {
        news = {
            formal = "【脓包蜘蛛】吐网蜘蛛的变种出现了，它们会喷吐粘液！",
            playful = "【粘粘蜘蛛】被它们吐到就动不了了！",
            english = "[Spitter Spiders] A variant of spitter spiders appears, they spit sticky slime!"
        },
        effect = function()
            local player = TheSim:FindFirstEntityWithTag("player")
            if player then
                local x, y, z = player.Transform:GetWorldPosition()
                for i = 1, 6 do
                    local spider = SpawnPrefab("spider_spitter")
                    if spider then spider.Transform:SetPosition(x + math.random(-20, 20), 0, z + math.random(-20, 20)) end
                end
            end
        end,
        event_type = "negative"
    },
    {
        news = {
            formal = "【护士蜘蛛】护士蜘蛛正在治疗其他蜘蛛，它们会持续恢复！",
            playful = "【奶妈蜘蛛】先打护士！不然其他蜘蛛打不死！",
            english = "[Nurse Spiders] Nurse spiders are healing other spiders, they will keep recovering!"
        },
        effect = function()
            local player = TheSim:FindFirstEntityWithTag("player")
            if player then
                local x, y, z = player.Transform:GetWorldPosition()
                for i = 1, 4 do
                    local spider = SpawnPrefab("spider")
                    if spider then spider.Transform:SetPosition(x + math.random(-20, 20), 0, z + math.random(-20, 20)) end
                end
                for i = 1, 2 do
                    local nurse = SpawnPrefab("spider_healer")
                    if nurse then nurse.Transform:SetPosition(x + math.random(-15, 15), 0, z + math.random(-15, 15)) end
                end
            end
        end,
        event_type = "negative"
    },
    {
        news = {
            formal = "【大黄蜂】巨大的大黄蜂出现了，它的毒性更强！",
            playful = "【超级大黄蜂】这只蜂比普通的杀人蜂大好多，快跑！",
            english = "[Bumblebee] A giant bumblebee appears, its poison is stronger!"
        },
        effect = function()
            local player = TheSim:FindFirstEntityWithTag("player")
            if player then
                local x, y, z = player.Transform:GetWorldPosition()
                for i = 1, 5 do
                    local bee = SpawnPrefab("bumblebee")
                    if bee then bee.Transform:SetPosition(x + math.random(-15, 15), 0, z + math.random(-15, 15)) end
                end
            end
        end,
        event_type = "negative"
    },
    {
        news = {
            formal = "【宝石鹿】发光的宝石鹿出现了，它们会主动冲撞入侵者！",
            playful = "【亮晶晶的鹿】它们身上的宝石很值钱，但它们会撞人！",
            english = "[Gem Deer] Glowing gem deer appear, they will charge at intruders!"
        },
        effect = function()
            local player = TheSim:FindFirstEntityWithTag("player")
            if player then
                local x, y, z = player.Transform:GetWorldPosition()
                local fire = SpawnPrefab("deer_fire")
                if fire then fire.Transform:SetPosition(x + math.random(-15, 15), 0, z + math.random(-15, 15)) end
                local ice = SpawnPrefab("deer_ice")
                if ice then ice.Transform:SetPosition(x + math.random(-15, 15), 0, z + math.random(-15, 15)) end
            end
        end,
        event_type = "negative"
    },
    {
        news = {
            formal = "【蘑菇蛤孢子】毒菌蟾蜍释放了孢子炸弹，剧毒正在弥漫！",
            playful = "【毒蘑菇云】小心那些飘来飘去的孢子，碰到就中毒！",
            english = "[Toadstool Spores] The Toadstool has released spore bombs, deadly poison is spreading!"
        },
        effect = function()
            local player = TheSim:FindFirstEntityWithTag("player")
            if player then
                local x, y, z = player.Transform:GetWorldPosition()
                for i = 1, 10 do
                    local spore = SpawnPrefab("spore")
                    if spore then spore.Transform:SetPosition(x + math.random(-20, 20), 0, z + math.random(-20, 20)) end
                end
            end
        end,
        event_type = "negative"
    }
	
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

	-- 【核心修复】加一个标记，防止世界重载或多次初始化时重复挂载定时器
    if inst._disaster_task_started then return end
    inst._disaster_task_started = tr
    
    GetConfig()
    
    inst.event_usage_count = {}
    
    inst:ListenForEvent("ms_save", function()
        if not ENABLE_NO_REPEAT then
            inst.event_usage_count = {}
        end
    end)
    
    --代表每 60 秒强制播报一次灾难
    inst:DoPeriodicTask(DISASTER_INTERVAL, CheckDailyNews)
    --开局第一次10秒播报一次灾难
    inst:DoTaskInTime(FIRST_DISASTER_DELAY, CheckDailyNews)
end)