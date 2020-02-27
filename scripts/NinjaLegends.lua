do
    local anticonstdump = "Nice try on dumping constants noob, this easy way won't work hehe";
end
pcall(function()	
    local player = game.Players.LocalPlayer;local toggles={};local hookfunction = hookfunction or detour_function or replaceclosure;
    local pos={
        ["Sell"]=Vector3.new(66.9353867, 4.9517858, -42.6442146),
    };
	if not player:FindFirstChild("Cyilitics123") then
		local a=Instance.new("BoolValue", player);a.Name = "Cyilitics123"
		local library = loadstring(game:HttpGet("https://pastebin.com/raw/tqKTJQAA"))()
        local frm=library:CreateWindow("Farm");
        local hook=library:CreateWindow('Game Hooking');
        frm:Toggle('Pickup Coins', {location=toggles, flag='pc'}, function(tg)
            spawn(function()
                if tg then
                    repeat
                        for i,v in pairs(game.Workspace.spawnedCoins:GetDescendants()) do
                            if toggles.pc then 
                                if v:IsA'BasePart' then 
                                    player.Character.HumanoidRootPart.CFrame=v.CFrame;
                                    wait(0.2)
                                end	
                            else
                                break;
                            end    
                        end
                        wait()
                    until not toggles.pc    
                end    
            end)
        end)
        frm:Toggle('Pickup Hoops', {location=toggles, flag='ph'}, function(tg)
            spawn(function()
                if tg then
                    repeat
                        for i,v in pairs(game.Workspace.Hoops:GetChildren()) do
                            if toggles.ph then 
                                if v:IsA'BasePart' and not v:FindFirstChildOfClass("BoolValue") then 
                                    player.Character.HumanoidRootPart.CFrame=v.CFrame;
                                    wait(0.2)
                                end	
                            else
                                break;
                            end    
                        end
                        wait()
                    until not toggles.ph   
                end    
            end)
        end)
        frm:Section('Autofarm')
        frm:Toggle('Auto Swing', {location=toggles, flag='as'}, function(tg)
            spawn(function()
                if tg then
                    while tg do
                        wait(0.2)
                        player.ninjaEvent:FireServer("swingKatana")
                    end
                end 
            end)       
        end)
        frm:Toggle('Auto sell', {location=toggles, flag='asl'})
        hook:Toggle('Infinite Jump', {location=toggles, flag='ij'})
        local nidx
        nidx=hookfunction(getrawmetatable(game).__newindex, function(a,b,c)
            if not checkcaller() and toggles.asl and b=='Visible' and a.Name=='maxNinjitsuMenu' and c==true then
                player.Character.HumanoidRootPart.CFrame=CFrame.new(pos["Sell"])
                return nidx(a,b,c)
            end
            return nidx(a,b,c)
        end)
        local idx
        idx=hookfunction(getrawmetatable(game).__index, function(a,b)
            if not checkcaller() and toggles.ij and b=='Value' and a.Name=='multiJumpCount' then
                return math.huge;
            end
            return idx(a,b)
        end)
	end	
end)
