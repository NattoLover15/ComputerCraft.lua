--sphere(半径(必須),角度下,上,円角度-,+,楕円x,y比率)球体下中心
local ver = 1.4
local args = {...}
local argsr = tonumber(args[1])--半径
local nowx = 0--現在幅
local nowz = 0--現在奥行
local nowd = 1--0=右1=前2=左3=後
local selectslot = 1
local rlist = {}

function argType(arg,retNum,minNum,maxNum)
    if type(arg) ~= "number" then
        arg = retNum
    elseif arg < minNum or arg > maxNum then
        arg = retNum
    end
    return(arg)
end

local argsya = argType(tonumber(args[2]),-90,-90,90)--角度下(-90)
local argsyb = argType(tonumber(args[3]),90,-90,90)--角度上(90)
local argsda = argType(tonumber(args[4]),1,1,360)--円角度-(1)
local argsdb = argType(tonumber(args[5]),360,1,360)--円角度+(360)
local argsa = argType(tonumber(args[6]),1,0.1,10)--楕円x比率
local argsb = argType(tonumber(args[7]),1,0.1,10)--楕円z比率(0.1から10)

if argsya > argsyb then
    argsyb = argsya
end
if argsda > argsdb then
    argsdb = argsda
end

function forward(n)
    if n > 0 then
        for i = 1, n do
            turtle.forward()
        end
    elseif n < 0 then
        for i = 1, math.abs(n) do
            turtle.back()
        end
    end
end--前後移動用関数

function move(x,z)
    if x ~= nowx then
        if nowd == 1 then
            turtle.turnRight()
            nowd = 0
        end
        forward(x-nowx)
        nowx = x
    end
    if z ~= nowz then
        if nowd == 0 then
            turtle.turnLeft()
            nowd = 1
        end
        forward(z-nowz)
        nowz = z
    end--座標が変化するなら実行

    while turtle.getItemCount(selectslot) == 0 do
        selectslot = selectslot+1
        if selectslot == 17 then
            print("Block none")
            selectslot = 1
            while turtle.getItemCount(selectslot) == 0 do
                sleep(1)
            end
        end
    end--アイテムが無くなったら待機
    turtle.select(selectslot)
    turtle.placeDown()
end--指定座標に移動、設置

local ydown = math.floor(argsr*math.sin(math.rad(argsya))+0.5)
local yup = math.floor(argsr*math.sin(math.rad(argsyb))+0.5)

local yr = argsr+0.5--半径計算
for i = ydown, yup do
    rlist[i-ydown+1] = argsr*math.cos(math.asin(i/yr))--各高さに対する半径を取得
end

turtle.up()
for yi, v in ipairs(rlist) do
    -- if type(v) ~= "number" then
    --  break
    -- end
    print("Y~",yi," radius",v)
    local xlist = {}
    local zlist = {}

    local index = 1
    xlist[index] = 0
    zlist[index] = 0

    for i = argsda, argsdb do
        local x = math.floor(v*argsa*math.cos(math.rad(i))+0.5)
        local z = math.floor(v*argsb*math.sin(math.rad(i))+0.5)

        local xold = xlist[index]
        local zold = zlist[index]

        if xold ~= x or zold ~= z then
            index = index+1
            xlist[index] = x
            zlist[index] = z
        end--座標が変化するなら格納
    end--円周の座標を配列に格納

    for i = 2,#xlist do
        print("Next",xlist[i],zlist[i])
        move(xlist[i],zlist[i])
    end--指定座標に移動、設置
    turtle.up()
end
