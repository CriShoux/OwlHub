local players=game:service("Players");local player=players.LocalPlayer;local toggles={};
if not player:FindFirstChild("C1y2i3l4i5t6i7c8s") then
    local a=Instance.new("BoolValue", player);
    a.Name = "C1y2i3l4i5t6i7c8s";
    local library=loadstring(game:HttpGet("https://pastebin.com/raw/tqKTJQAA", true))();
    local combat=library:CreateWindow("Combat Cheat");
    combat:Toggle("Big damage",{localtion=toggles, flag='bD'});
    combat:Toggle("Fast attacks",{localtion=toggles, flag='fA'});
    function getvictim() 
        local lastpos=math.huge;
        local nearest; 
        for i,v in pairs(game.Players:GetChildren()) do 
            if v~=player and v.Character:FindFirstChild("HumanoidRootPart") then 
                local newpos=(player.Character.HumanoidRootPart.Position - v.Character.HumanoidRootPart.Position).Magnitude;
                if newpos < lastpos then 
                    lastpos=newpos;
                    nearest = v;
                end	
            end	
        end	
        return nearest;
    end
    local fr;
    fr=hookfunction(getrawmetatable(game).__namecall, function(...)
        local args={...};
        if getnamecallmethod()=="FireServer" and args[1].Name=="Hit" and toggles.bD then
            args[4]=getvictim().Character.Humanoid;args[5]=getvictim().Character.HumanoidRootPart.CFrame;args[6]=99;
            return fr(unpack(args));
        end    
        return fr(...)
    end)
    local dl;
    dl=hookfunction(delay, function(a,b)
        if toggles.fA then
            return b()
        end
        return dl(a,b)    
    end)
end
