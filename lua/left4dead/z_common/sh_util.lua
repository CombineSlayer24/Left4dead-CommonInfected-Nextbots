---------------------------------------------------------------------------------------------------------------------------------------------
-- Returns the position and angle of a specified bone
function ENT:GetBoneTransformation( bone, target )
    target = ( target or self )

    local pos, ang = target:GetBonePosition( bone )
    if !pos or pos:IsZero() or pos == target:GetPos() then
        local matrix = target:GetBoneMatrix( bone )
        if matrix and ismatrix( matrix ) then
            pos = matrix:GetTranslation()
            ang = matrix:GetAngles()
        end
    end
    
    return { Pos = pos, Ang = ang, Bone = bone }
end
---------------------------------------------------------------------------------------------------------------------------------------------
-- Returns a table that contains a position and angle with the specified type. hand or eyes
local eyeOffAng = Angle( 20, 0, 0 )
function ENT:GetAttachmentPoint( pointtype )
    local attachData = { Pos = self:WorldSpaceCenter(), Ang = self:GetForward():Angle(), Index = 0 }

    if pointtype == "hand" then
        local lookup = self:LookupAttachment( "anim_attachment_RH" )
        local handAttach = self:GetAttachment( lookup )

        if !handAttach then
            local bone = self:LookupBone( "ValveBiped.Bip01_R_Hand" )
            if isnumber( bone ) then attachData = self:GetBoneTransformation( bone ) end
        else
            attachData = handAttach
            attachData.Index = lookup
        end
    elseif pointtype == "eyes" then
        local lookup = self:LookupAttachment( "eyes" )
        local eyeAttach = self:GetAttachment( lookup )

        if !eyeAttach then 
            attachData.Pos = ( attachData.Pos + vector_up * 30 )
            attachData.Ang = ( attachData.Ang + eyeOffAng )
        else
            attachData = eyeAttach
            attachData.Index = lookup
        end
    end

    return attachData
end
---------------------------------------------------------------------------------------------------------------------------------------------
if SERVER then
    ---------------------------------------------------------------------------------------------------------------------------------------------
    function ENT:GetWaterLevel()
        return ( self:GetAttachmentPoint( "eyes" ).Pos:IsUnderwater() and 3 or self:WorldSpaceCenter():IsUnderwater() and 2 or self:GetPos():IsUnderwater() and 1 or 0 )
    end
    ---------------------------------------------------------------------------------------------------------------------------------------------
end
---------------------------------------------------------------------------------------------------------------------------------------------