local phoneProp = 0
local phoneModel = joaat("prop_npc_phone_02")

local function loadAnim(dict)
    if not lib.requestAnimDict(dict, 10000) then
        error(("Animation dictionary '%s' could not be loaded"):format(dict))
    end
end

local function loadModel(model)
    if not lib.requestModel(model, 10000) then
        error(("Model '%s' could not be loaded"):format(model))
    end
end

local function checkAnimLoop()
    CreateThread(function()
        while PhoneData.AnimationData.lib and PhoneData.AnimationData.anim do
            local ped = PlayerPedId()

            if not IsEntityPlayingAnim(ped, PhoneData.AnimationData.lib, PhoneData.AnimationData.anim, 3) then
                loadAnim(PhoneData.AnimationData.lib)
                TaskPlayAnim(
                    ped,
                    PhoneData.AnimationData.lib,
                    PhoneData.AnimationData.anim,
                    3.0, 3.0, -1,
                    50, 0, false, false, false
                )
            end

            Wait(500)
        end
    end)
end

function newPhoneProp()
    deletePhone()

    loadModel(phoneModel)

    phoneProp = CreateObject(phoneModel, 1.0, 1.0, 1.0, true, true, false)

    local ped = PlayerPedId()
    local bone = GetPedBoneIndex(ped, 28422)

    if phoneModel == joaat("prop_qb-phone_01") then
        AttachEntityToEntity(phoneProp, ped, bone, 0.0, 0.0, 0.0, 50.0, 320.0, 50.0, true, true, false, false, 2, true)
    else
        AttachEntityToEntity(phoneProp, ped, bone, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, true, true, false, false, 2, true)
    end

    SetModelAsNoLongerNeeded(phoneModel)
end

function deletePhone()
    if phoneProp ~= 0 then
        DeleteObject(phoneProp)
        phoneProp = 0
    end
end

function DoPhoneAnimation(anim)
    local ped = PlayerPedId()
    local dict = IsPedInAnyVehicle(ped, false) and 'anim@cellphone@in_car@ps' or 'cellphone@'

    loadAnim(dict)

    TaskPlayAnim(
        ped,
        dict,
        anim,
        3.0, 3.0, -1,
        50, 0, false, false, false
    )

    PhoneData.AnimationData.lib = dict
    PhoneData.AnimationData.anim = anim

    checkAnimLoop()

    -- Anim dict opschonen wanneer animatie stopt
    CreateThread(function()
        while PhoneData.AnimationData.lib do
            Wait(500)
        end
        RemoveAnimDict(dict)
    end)
end
