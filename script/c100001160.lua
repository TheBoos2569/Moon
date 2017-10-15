--scripted and created by rising phoenix
function c100001160.initial_effect(c)	
c:EnableReviveLimit()
	--special summon
		--special summon condition
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e7:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e7)
	local e30=Effect.CreateEffect(c)
	e30:SetType(EFFECT_TYPE_FIELD)
	e30:SetCode(EFFECT_SPSUMMON_PROC)
	e30:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e30:SetRange(LOCATION_HAND)
	e30:SetCondition(c100001160.spcon)
	e30:SetOperation(c100001160.spop)
	c:RegisterEffect(e30)
		--cannot attack
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e11:SetCode(EVENT_SUMMON_SUCCESS)
	e11:SetOperation(c100001160.atklimit)
	c:RegisterEffect(e11)
	local e12=e11:Clone()
	e12:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e12)
	local e13=e11:Clone()
	e13:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e13)
		--gr
		local e10=Effect.CreateEffect(c)
	e10:SetDescription(aux.Stringid(100001160,0))
	e10:SetCategory(CATEGORY_TOGRAVE)
	e10:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e10:SetCode(EVENT_LEAVE_FIELD)
	e10:SetTarget(c100001160.tdtg)
	e10:SetOperation(c100001160.tdop)
	c:RegisterEffect(e10)
		--remove field
	local e22=Effect.CreateEffect(c)
	e22:SetCategory(CATEGORY_REMOVE)
	e22:SetDescription(aux.Stringid(100001160,0))
	e22:SetRange(LOCATION_MZONE)
	e22:SetCountLimit(1)
	e22:SetTarget(c100001160.targetf)
	e22:SetOperation(c100001160.operationf)
		e22:SetHintTiming(TIMING_STANDBY_PHASE,0)
		e22:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
			e22:SetCode(EVENT_PHASE+PHASE_STANDBY)
				e22:SetCondition(c100001160.damconr)
	c:RegisterEffect(e22)
end
function c100001160.damconr(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer()
end
function c100001160.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,PLAYER_ALL,LOCATION_REMOVED)
end
function c100001160.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetFieldGroup(tp,0,LOCATION_REMOVED)
	Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
end
function c100001160.targetf(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsRemoveable,tp,0,LOCATION_DECK,1,c) end
	local sg1=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_DECK,c)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,sg1,sg1:GetCount(),0,0)
end
function c100001160.operationf(e,tp,eg,ep,ev,re,r,rp)
	local sg1=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_DECK,e:GetHandler())
	Duel.Remove(sg1,POS_FACEDOWN,REASON_EFFECT)
end
function c100001160.atklimit(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	e:GetHandler():RegisterEffect(e1)
end
function c100001160.spcfilter(c)
	return c:IsSetCard(0x11E) and c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost()
end
function c100001160.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local hg=Duel.GetMatchingGroup(c100001160.spcfilter,tp,LOCATION_HAND,0,c)
	return Duel.IsExistingMatchingCard(c100001160.spcfilter,tp,LOCATION_MZONE,0,3,nil)
end
function c100001160.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c100001160.spcfilter,tp,LOCATION_MZONE,0,3,3,nil)
	Duel.SendtoGrave(g,REASON_COST)
end