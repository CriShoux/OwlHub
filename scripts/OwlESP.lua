local OwlESP = {};

local localPlayer = game:GetService("Players").LocalPlayer;
local currentCamera = workspace.CurrentCamera;
local worldToViewportPoint = currentCamera.WorldToViewportPoint;
local setmetatable = setmetatable;
local newDrawing = Drawing.new;
local newVector2 = Vector2.new;
local newVector3 = Vector3.new;
local remove = table.remove;

local headOffset = newVector3(0, 0.5, 0);
local legOffset = newVector3(0, 3, 0);
local tracerStart = newVector2(currentCamera.ViewportSize.X / 2, currentCamera.ViewportSize.Y);

function OwlESP.new(data)
    local self = setmetatable({
        plr = data.plr,
        char = data.plr.Character,
        espBox = nil,
        name = nil,
        tracer = nil,
        espColor = data.espColor or fromRGB(255, 255, 255),
        teamCheck = data.teamCheck or false;
    }, {__index = OwlESP});

    local plr = data.plr;
    local char = self.char;
    local espBoxVisible = data.espBoxVisible;
    local tracerVisible = data.tracerVisible;
    local text = data.text;

    if not char then return; end;

    local rootPart = char.HumanoidRootPart;
    local head = char.Head;
    local rootPos, rootVis = worldToViewportPoint(currentCamera, rootPart.Position);
    local headPos = worldToViewportPoint(currentCamera, head.Position + headOffset);
    local legPos = worldToViewportPoint(currentCamera, rootPart.Position - legOffset);
    local visible = (self.teamCheck and plr.TeamColor ~= localPlayer.TeamColor) or (not self.teamCheck);

    local espBox = newDrawing("Square");
    espBox.Color = self.espColor;
    espBox.Thickness = 2;
    espBox.Filled = false;
    espBox.Transparency = 0.8;
    local tracer = newDrawing("Line");
    tracer.From = tracerStart;
    tracer.Color = self.espColor;
    tracer.Thickness = 2;
    tracer.Transparency = 0.8;
    local name = newDrawing("Text");
    name.Text = text;
    name.Size = 16;
    name.Color = self.espColor;
    name.Center = true;
    name.Outline = true;

    if rootVis then
        espBox.Size = newVector2(2350 / rootPos.Z, headPos.Y - legPos.Y);
        espBox.Position = newVector2(rootPos.X - espBox.Size.X / 2, rootPos.Y - espBox.Size.Y / 2);
        tracer.To = newVector2(rootPos.X, rootPos.Y - espBox.Size.Y / 2);
        name.Position = newVector2(rootPos.X, (rootPos.Y + espBox.Size.Y / 2) - 25);

        espBox.Visible = espBoxVisible and visible;
        tracer.Visible = tracerVisible and visible;
        name.Visible = espBoxVisible and visible;
    end;

    self.espBox = {espBox, espBoxVisible};
    self.tracer = {tracer, tracerVisible};
    self.name = {name, text};

    return self;
end;

function OwlESP:setESPBox(visible)
    self.espBox[2] = visible;
end;

function OwlESP:setTracer(visible)
    self.tracer[2] = visible;
end;

function OwlESP:setText(text)
    self.name[2] = text;
end;

function OwlESP:update()
    local plr, char, espBox, tracer, name = self.plr, self.char, self.espBox[1], self.tracer[1], self.name[1];
    local espBoxVisible, tracerVisible, text, espColor = self.espBox[2], self.tracer[2], self.name[2], self.espColor;
    local rootPart, head = char:FindFirstChild("HumanoidRootPart"), char:FindFirstChild("Head");

    if rootPart and head then
        local rootPos, rootVis = worldToViewportPoint(currentCamera, rootPart.Position);
        local headPos = worldToViewportPoint(currentCamera, head.Position + headOffset);
        local legPos = worldToViewportPoint(currentCamera, rootPart.Position - legOffset);
        local visible = (self.teamCheck and plr.TeamColor ~= localPlayer.TeamColor) or (not self.teamCheck);

        if rootVis then
            espBox.Size = newVector2(2350 / rootPos.Z, headPos.Y - legPos.Y);
            local espBoxSize = espBox.Size;
            espBox.Position = newVector2(rootPos.X - espBoxSize.X / 2, rootPos.Y - espBoxSize.Y / 2);
            espBox.Color = espColor;
            tracer.To = newVector2(rootPos.X, rootPos.Y - espBoxSize.Y / 2);
            tracer.Color = espColor;
            name.Position = newVector2(rootPos.X, (rootPos.Y + espBoxSize.Y / 2) - 25);
            name.Text = text;
            name.Color = espColor;

            espBox.Visible = espBoxVisible and visible;
            tracer.Visible = tracerVisible and visible;
            name.Visible = visible;
        else
            espBox.Visible = false;
            tracer.Visible = false;
            name.Visible = false;
        end;
    end;
end;

function OwlESP:remove()
    self.espBox[1]:Remove();
    self.tracer[1]:Remove();
    self.name[1]:Remove();
    function self:update() end;
end;

return OwlESP;
