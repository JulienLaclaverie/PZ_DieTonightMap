function MainScreen:prerender()

    ISPanel.prerender(self);
    if(self.inGame) then
        self:drawRect(0, 0, self.width, self.height, 0.5, self.backgroundColor.r, self.backgroundColor.g, self.backgroundColor.b);
    end
    self.delay = self.delay - 1;
    local textManager = getTextManager();

    self.time = self.time + (1.0 / 60);

    local lastIsSameTitle = false;
    local nextIsSameTitle = false;

    if self.time > 11.8 then
        if self.credits:size() > self.creditsIndex then
            if self.creditsIndex > 0 then
                if self.credits:get(self.creditsIndex-1).title == self.credits:get(self.creditsIndex).title then
                    lastIsSameTitle = true;
                end
            end

            if self.credits:size()-1 > self.creditsIndex then
                if self.credits:get(self.creditsIndex+1).title == self.credits:get(self.creditsIndex).title then
                    nextIsSameTitle = true;
                end
            end
        end
        local del = self.creditTime / self.creditTimeMax;
        local credAlpha = self.creditTime / self.creditTimeMax;
        if(credAlpha <= 0.5) then
            credAlpha = credAlpha * 2;
        elseif (credAlpha >= 0.8) then
            credAlpha = 1.0 - ((credAlpha - 0.8) * 5);
        else
            credAlpha = 1;
        end
        local credAlpha2 = self.creditTime / self.creditTimeMax;
        if(credAlpha2 <= 0.1) then
            credAlpha2 = credAlpha2 * 10;
            if lastIsSameTitle then credAlpha2 = 1; end
        elseif (credAlpha2 >= 0.9) then
            credAlpha2 = 1.0 - ((credAlpha2 - 0.9) * 10);
            if nextIsSameTitle then credAlpha2 = 1; end
        else
            credAlpha2 = 1;
        end

        self.creditTime = self.creditTime + (1 / 60.0);
        if self.creditTime > self.creditTimeMax then
            self.creditTime = 0;
            self.creditsIndex = self.creditsIndex + 1;
        end
        if self.credits:size() > self.creditsIndex and not self.inGame and ISDemoPopup.instance == nil then
            textManager:DrawString(UIFont.Cred1, 130 , getCore():getScreenHeight()*0.07, self.credits:get(self.creditsIndex).title, 1, 1, 1, credAlpha2);

            local x = 80;
            local xwid = textManager:MeasureStringX(UIFont.Cred2, self.credits:get(self.creditsIndex).name);
            if(x + xwid > getCore():getScreenWidth()) then
               x = x - ((x + xwid) - getCore():getScreenWidth()) - 10;
            end
            textManager:DrawString(UIFont.Cred2, x, (getCore():getScreenHeight()*0.07) + 26, self.credits:get(self.creditsIndex).name, 1, 1, 1, credAlpha);
        end

    end

    local mainScreen = MainScreenState.getInstance();
    if mainScreen ~= nil and (ISDemoPopup.instance == nil) then
        useTextureFiltering(true);
        local tex = getTexture("media/ui/PZ_Logo_New.png");
        useTextureFiltering(false);
        local x = 50;
        local y = (getCore():getScreenHeight()*0.45);
        local sw = getCore():getScreenWidth();

        local w = tex:getWidth();
        local h = tex:getHeight();
        local resdelta = sw / 1920;
        x = x * resdelta;
        y = y * resdelta;
        w = w * resdelta;
        h = h * resdelta;
        self:drawTextureScaled(tex, x, y, w, h, 1, 1, 1, 1.0);

    end

    if isDemo() and not self.inGame then
        if self.bottomPanel:getIsVisible() then
            if not self.demoMessagePanel then
                local y = self.bottomPanel:getY() - 35 * 3
                self.demoMessagePanel = ISRichTextPanel:new(self.width / 2 - 800 / 2, 0, 800, 35 * 3)
                self.demoMessagePanel:setAnchorTop(false)
                self.demoMessagePanel:setAnchorBottom(true)
                self.demoMessagePanel.font = UIFont.Medium
                self:addChild(self.demoMessagePanel)
                self.demoMessagePanel.text = getText("UI_Demo_Welcome")
                self.demoMessagePanel:paginate()
            end
            self.demoMessagePanel:setX(self.width / 2 - self.demoMessagePanel:getWidth() / 2)
            self.demoMessagePanel:setY(self.bottomPanel:getY() - 24 - self.demoMessagePanel:getHeight())
        end
        if self.demoMessagePanel then
            self.demoMessagePanel:setVisible(self.bottomPanel:getIsVisible())
        end
    end
end