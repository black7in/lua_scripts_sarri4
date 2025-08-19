CLASS_WARRIOR = 1
CLASS_PALADIN = 2
CLASS_HUNTER = 3
CLASS_ROGUE = 4
CLASS_PRIEST = 5
CLASS_DEATH_KNIGHT = 6
CLASS_SHAMAN = 7
CLASS_MAGE = 8
CLASS_WARLOCK = 9
-- CLASS_MONK = 10
CLASS_DRUID = 11

RACE_HUMAN = 1
RACE_ORC = 2
RACE_DWARF = 3
RACE_NIGTH_ELF = 4
RACE_UNDEAD = 5
RACE_TAUREN = 6
RACE_GNOME = 7
RACE_TROLL = 8
-- RACE_GOBLIN = 9
RACE_BLOOD_ELF = 10
RACE_DRAENEI = 11

LEVEL_TYPE_NORMAL = 0
LEVEL_TYPE_HARDCORE = 1
LEVEL_TYPE_ARTESANO = 2
LEVEL_TYPE_MURLOCFOBICO = 3
LEVEL_TYPE_MAESTRO = 4


local SMSG_MESSAGECHAT = 0x096
function Player:SendRaidNotification(message)
    local data = CreatePacket(SMSG_MESSAGECHAT, string.len(message) + 1 + 40)
    data:WriteUByte(40)
    data:WriteULong(0)
    data:WriteGUID(0)
    data:WriteULong(0)
    data:WriteGUID(0)
    data:WriteULong(string.len(message) + 1)
    data:WriteString(message)
    data:WriteUByte(0)
    self:SendPacket(data)
end

function Player:SendGossipText(text, npc_text)
    local data = CreatePacket(384, 100);
    data:WriteULong(npc_text) -- id npc_text
    for i = 1, 10 do
        data:WriteFloat(0)
        data:WriteString(text)
        data:WriteString(text)
        data:WriteULong(0)
        data:WriteULong(0)
        data:WriteULong(0)
        data:WriteULong(0)
        data:WriteULong(0)
        data:WriteULong(0)
        data:WriteULong(0)
    end
    self:SendPacket(data)
end