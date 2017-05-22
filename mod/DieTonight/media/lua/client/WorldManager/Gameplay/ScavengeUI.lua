--
-- Created by RJ
-- Overriten by Onkeen to match die tonight's foraging
--

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
    self.options:addOption("Weapons & tools", "Mushrooms");
    self.options:addOption("Objects", "Berries");
    self.options:addOption("Food", "Insects");
    self.options:addOption("Pharmaceuticals", "MedicinalPlants");
    if savedScavengeOptions then
        for i=1,#self.options.optionData do
            if savedScavengeOptions[ self.options.optionData[i] ] then
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

function ISScavengeUI:prerender()
    local z = 20;
    local splitPoint = 100;
    local x = 10;
    self:drawRect(0, 0, self.width, self.height, self.backgroundColor.a, self.backgroundColor.r, self.backgroundColor.g, self.backgroundColor.b);
    self:drawRectBorder(0, 0, self.width, self.height, self.borderColor.a, self.borderColor.r, self.borderColor.g, self.borderColor.b);
    self:drawText("Scavenge area for...", self.width/2 - (getTextManager():MeasureStringX(UIFont.Medium, "Scavenge area for...") / 2), z, 1,1,1,1, UIFont.Medium);
end