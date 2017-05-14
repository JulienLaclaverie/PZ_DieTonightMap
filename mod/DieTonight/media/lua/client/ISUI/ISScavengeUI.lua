--
-- Created by RJ
-- Overriten by Onkeen to match die tonight's foraging
--

ISScavengeUI = ISPanel:derive("ISScavengeUI");
ISScavengeUI.messages = {};

--************************************************************************--
--** ISScavengeUI:initialise
--**
--************************************************************************--

function ISScavengeUI:initialise()
    ISPanel.initialise(self);
    local btnWid = 100
    local btnHgt = 25
    local padBottom = 10

    self.no = ISButton:new(self:getWidth() - btnWid - 10, self:getHeight() - padBottom - btnHgt, btnWid, btnHgt, getText("UI_Cancel"), self, ISScavengeUI.onClick);
    self.no.internal = "CANCEL";
    self.no.anchorTop = false
    self.no.anchorBottom = true
    self.no:initialise();
    self.no:instantiate();
    self.no.borderColor = self.buttonBorderColor;
    self:addChild(self.no);

    self.ok = ISButton:new(10, self:getHeight() - padBottom - btnHgt, btnWid, btnHgt, getText("UI_Ok"), self, ISScavengeUI.onClick);
    self.ok.internal = "OK";
    self.ok.anchorTop = false
    self.ok.anchorBottom = true
    self.ok:initialise();
    self.ok:instantiate();
    self.ok.borderColor = self.buttonBorderColor;
    self:addChild(self.ok);

    print(getGameTime():getMinutesPerDay(), getGameTime():getMultiplier());

    self.options = ISTickBox:new(10, 50, 200, 20, "")
    self.options.choicesColor = {r=1, g=1, b=1, a=1}
    self.options:initialise()
    self.options:addOption("Resources", "ForestGoods");
    self.options:addOption("Objects", "Berries");
    self.options:addOption("Food", "Insects");
    self.options:addOption("Pharmaceuticals", "MedicinalPlants");
    if savedScavengeOptions then
        for i=1,#self.options.optionData do
            if savedScavengeOptions[self.options.optionData[i]] then
                self.options:setSelected(i, true);
            end
        end
    else
        for i=1,#self.options.options do
            self.options:setSelected(i, true);
        end
    end
    self:addChild(self.options)
end


function ISScavengeUI:render()
    self:updateButtons();
end

function ISScavengeUI:prerender()
    local z = 20;
    local splitPoint = 100;
    local x = 10;
    self:drawRect(0, 0, self.width, self.height, self.backgroundColor.a, self.backgroundColor.r, self.backgroundColor.g, self.backgroundColor.b);
    self:drawRectBorder(0, 0, self.width, self.height, self.borderColor.a, self.borderColor.r, self.borderColor.g, self.borderColor.b);
    self:drawText("Scavenge area for...", self.width/2 - (getTextManager():MeasureStringX(UIFont.Medium, "Scavenge area for...") / 2), z, 1,1,1,1, UIFont.Medium);
end

function ISScavengeUI:updateButtons()
    self.ok.enable = false;
    for i=1,#self.options.options do
        if self.options:isSelected(i) then
            self.ok.enable = true;
            break;
        end
    end
end

function ISScavengeUI:onClick(button)
    if button.internal == "OK" then
        if luautils.walkAdj(self.player, self.clickedSquare) then
            savedScavengeOptions = {};
            for i=1,#self.options.options do
                if self.options:isSelected(i) then
                    savedScavengeOptions[self.options.optionData[i]] = true;
                end
            end

            ISTimedActionQueue.add(ISScavengeAction:new(self.player, self.zone, savedScavengeOptions))
        end
    end
    self:setVisible(false);
    self:removeFromUIManager();
end

--************************************************************************--
--** ISScavengeUI:new
--**
--************************************************************************--
function ISScavengeUI:new(x, y, width, height, player, zone, clickedSquare)
    local o = {}
    local playerNum = player:getPlayerNum()
    if y == 0 then
        y = getPlayerScreenTop(playerNum) + (getPlayerScreenHeight(playerNum) - height) / 2
    end
    if x == 0 then
        x = getPlayerScreenLeft(playerNum) + (getPlayerScreenWidth(playerNum) - width) / 2
    end
    o = ISPanel:new(x, y, width, height);
    setmetatable(o, self)
    self.__index = self
    if y == 0 then
        o.y = o:getMouseY() - (height / 2)
        o:setY(o.y)
    end
    if x == 0 then
        o.x = o:getMouseX() - (width / 2)
        o:setX(o.x)
    end
    o.borderColor = {r=0.4, g=0.4, b=0.4, a=1};
    o.backgroundColor = {r=0, g=0, b=0, a=0.8};
    o.width = width;
    o.height = height;
    o.player = player;
    o.zone = zone;
    o.clickedSquare = clickedSquare;
    o.moveWithMouse = true;
    o.buttonBorderColor = {r=0.7, g=0.7, b=0.7, a=0.5};
    return o;
end