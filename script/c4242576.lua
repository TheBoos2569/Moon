--Lunar Phase Beast: Moon Burst Vandalizing
function c4242576.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	
		--Search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(4242576,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCost(c4242576.descon1)
	e1:SetTarget(c4242576.destg1)
	e1:SetOperation(c4242576.desop1)
	c:RegisterEffect(e1)
	--On death kill pend scale
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(4242576,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetCountLimit(1,42425761)
--	e2:SetCondition(c4242576.condition)
	e2:SetTarget(c4242576.target)
	e2:SetOperation(c4242576.operation)
	c:RegisterEffect(e2)
	
	-- Once per turn: You can shuffle 1 "Lunar Phase" monster you control into the Deck; 
	-- Special Summon 1 "Lunar Phase" monster with a different name from your Deck.
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_PZONE)
	e3:SetTarget(c4242576.tg)
	e3:SetOperation(c4242576.op)
	e3:SetCountLimit(1)
	c:RegisterEffect(e3)

end


--Effect 1 (Search) Code
function c4242576.descon1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGraveAsCost() and c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c4242576.filter(c)
	return c:IsCode(4242564) and c:IsAbleToHand()
end
function c4242576.destg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c4242576.filter,tp,0x51,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,0x51)
end
function c4242576.desop1(e,tp,eg,ep,ev,re,r,rp,chk)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tg=Duel.SelectMatchingCard(tp,c4242576.filter,tp,0x51,0,1,1,nil):GetFirst()
	if tg then
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
	end
end
--On death kill pend scale
function c4242576.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_BATTLE)
end
function c4242576.desfilter(c)
	return c:IsType(TYPE_MONSTER)
end
function c4242576.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c4242576.desfilter(chkc) and chkc~=e:GetHandler() end
	if chk==0 then return Duel.IsExistingTarget(c4242576.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c4242576.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c4242576.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end

function c4242576.filter1(c,e,tp)
	local code=c:GetCode()
	return c:IsFaceup() and c:IsSetCard(0x666) and c:IsAbleToDeckAsCost()
		and Duel.IsExistingMatchingCard(c4242576.filter2,tp,LOCATION_DECK,0,1,nil,code,e,tp)
end
function c4242576.filter2(c,code,e,tp)
	return c:IsSetCard(0x666) and c:GetCode()~=code and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c4242576.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(c4242576.filter1,tp,LOCATION_MZONE,0,1,nil,e,tp)
	end
	local rg=Duel.SelectMatchingCard(tp,c4242576.filter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	e:SetLabel(rg:GetFirst():GetCode())
	Duel.SendtoDeck(rg,nil,2,REASON_COST)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c4242576.op(e,tp,eg,ep,ev,re,r,rp)
if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local code=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c4242576.filter2,tp,LOCATION_DECK,0,1,1,nil,code,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
