--SC2 Unit - Melee - Siege Tank
function c249000264.initial_effect(c)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c249000264.condition)
	e1:SetTarget(c249000264.target)
	e1:SetOperation(c249000264.operation)
	c:RegisterEffect(e1)
end
function c249000264.condition(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsDisabled() and e:GetHandler():IsDefencePos()
end
function c249000264.filter(c)
	return c:IsFaceup() and c:IsDestructable()
end
function c249000264.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsFaceup() and chkc:IsDestructable() end
	if chk==0 then return Duel.IsExistingTarget(c249000264.filtere,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c249000264.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c249000264.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
