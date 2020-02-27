local main = {};

main.players = game:GetService("Players");
main.inputService = game:GetService("UserInputService");
main.localPlayer = main.players.LocalPlayer;
main.currentCamera = workspace.CurrentCamera;

function main:GetClosestMob()
    local closestPlayer = nil;
    local shortestDistance = 9e9;
    
    for i, v in pairs(self.mobs:GetChildren()) do
        if v:FindFirstChild("Head") then
            local magnitude = (v.Head.Position - self.localPlayer.Character.HumanoidRootPart.Position).magnitude;

            if magnitude < shortestDistance then
                closestPlayer = v;
                shortestDistance = magnitude;
            end;
        end;
    end;
    
    return closestPlayer;
end;

function main:GetMelee()
    local sword;

    if self.chosenSword then
        sword = self.chosenSword;
    else
        for i, v in pairs(self.localPlayer.Backpack:GetChildren()) do
            if v:FindFirstChild("Handle") and v:FindFirstChild("ItemScriptClient") then
                sword = v;
            end;
        end;
    end;

    return sword;
end;

function main:EquipMelee()
    pcall(function()
        local melee = self:GetMelee();
        if not self.localPlayer.Character:FindFirstChildOfClass("Tool") then
            self.localPlayer.Character.Humanoid:EquipTool(melee);
        end;
    end);
end;

function main:Initiate()
    do --// Variable Setup
        getfenv().self = self;

        self.OwlLib = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/CriShoux/OwlHub/master/UILib.lua"))();
        self.mobs = workspace.Mobs;
        self.damageRemote = game:GetService("ReplicatedStorage").GameRemotes.DamageMelee;

        self.killAura = false;
        self.autoFarm = false;

        self.chosenSword = nil;
        self.chosenMob = "";
    end;

    do --// Main UI Setup
        local main = self.OwlLib:new("MAIN");
        main:newBtn("Kill Aura", function(enabled) self.killAura = enabled; end);
        main:newTextbox("Target Mob", function(text) 
            for i, v in pairs(self.mobs:GetChildren()) do
                if v:FindFirstChild("Head") and v.Name:lower():find(text:lower()) then
                    self.chosenMob = v.Name;
                end;
            end;
        end, "N/A", true);
        main:newTextbox("Sword", function(text) 
            for i, v in pairs(self.localPlayer.Backpack:GetChildren()) do
                if text:find("%S") and text:lower() ~= "n/a" and v.Name:lower():find(text:lower()) then
                    self.chosenSword = v;
                end;
            end;
        end, "N/A", true);
        main:newBtn("Mob Autofarm", function(enabled) self.autoFarm = enabled; end);
    end;

    do --// Kill Aura Setup
        game:GetService("RunService").RenderStepped:Connect(function()
            if self.killAura and self.localPlayer.Character and self.localPlayer.Character:FindFirstChild("HumanoidRootPart") then
                self.damageRemote:InvokeServer(self:GetClosestMob());
            end;
        end);
    end;

    do --// Autofarm Setup
        game:GetService("RunService").RenderStepped:Connect(function()
            if self.autoFarm then
                pcall(function()
                    self:EquipMelee();
                    self.localPlayer.Character.HumanoidRootPart.CFrame = self.mobs[self.chosenMob].Head.CFrame * CFrame.new(0, 0, 8.3);
                    game:GetService("ReplicatedStorage").GameRemotes.DamageMelee:InvokeServer(self.mobs[self.chosenMob]);
                end);
            end;
        end);
    end;
end;

main:Initiate();
