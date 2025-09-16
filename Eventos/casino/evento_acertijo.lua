local npc = 60032
local ficha = 49224

-- Este npc es un npc para jugar juegos como por ejemplo Trivia
local text =
    "¡Hola! Soy Riddler el Acertijo. Esto es un juego de Trivia, tienes que responder a mis preguntas para ganar premios. ¿Quieres intentarlo?\n\nEl costo es de 10 Fichas por intento. Puedes ganar 2 fichas por pregunta si respondes correctamente.\n\nPara responder solo debes enviar la opcion correcta.\n\nEjemplo: Ultimo Boss de ICC?\nOpcion 1: Lich King\nOpcion 2: Sindra\nOpcion 3: Lord Tuetano\n\nLa respuesta correcta es Opción 1 por tanto debes enviar el número 1"

local trivia = {
    {pregunta = "¿Quién fue el primer Rey Exánime?", opciones = {"Ner'zhul", "Arthas", "Kel'Thuzad", "Bolvar Fordragon"}, respuesta_correcta = 2},
    {
        pregunta = "¿Cuál es la capital de los enanos en Rasganorte?",
        opciones = {"Forjaz", "Ciudad de Ventormenta", "Cuenca de Sholazar", "Cima del Trueno"},
        respuesta_correcta = 1
    }, {
        pregunta = "¿Quién lidera la Horda en Rasganorte durante WotLK?",
        opciones = {"Garrosh Grito Infernal", "Thrall", "Vol'jin", "Cairne Pezuña de Sangre"},
        respuesta_correcta = 2
    }, {
        pregunta = "¿Quién lidera la Alianza en Rasganorte durante WotLK?",
        opciones = {"Anduin Wrynn", "Varian Wrynn", "Bolvar Fordragon", "Muradin Barbabronce"},
        respuesta_correcta = 2
    }, {pregunta = "¿Qué titán creó a los mogu?", opciones = {"Aman'Thul", "Sargeras", "Lei Shen", "Eonar"}, respuesta_correcta = 3}, {
        pregunta = "¿Quién fue el líder de los draenei que ayudó a la Cruzada Argenta?",
        opciones = {"Velen", "Nobundo", "Kil'jaeden", "Maraad"},
        respuesta_correcta = 1
    }, {
        pregunta = "¿Qué dragón rojo protege la vida en Azeroth?",
        opciones = {"Alexstrasza", "Deathwing", "Malygos", "Nozdormu"},
        respuesta_correcta = 1
    }, {
        pregunta = "¿Quién lideraba la Plaga durante WotLK?",
        opciones = {"Kel'Thuzad", "Loatheb", "Lich King Arthas", "Anub'arak"},
        respuesta_correcta = 3
    }, {
        pregunta = "¿Qué reino está bajo el dominio del Rey Exánime?",
        opciones = {"Dalaran", "Ventormenta", "Northrend", "Orgrimmar"},
        respuesta_correcta = 3
    }, {
        pregunta = "¿Quién es el señor del terror y líder de la Legión Ardiente?",
        opciones = {"Sargeras", "Kil'jaeden", "Archimonde", "Ner'zhul"},
        respuesta_correcta = 1
    }, {
        pregunta = "¿Quién es el jefe de la Plaga en la Ciudadela de la Corona de Hielo?",
        opciones = {"Lich King", "Sindragosa", "Marwyn", "Anub'arak"},
        respuesta_correcta = 1
    },
    {pregunta = "¿Qué titán restauró el mundo de Azeroth?", opciones = {"Aman'Thul", "Eonar", "Sargeras", "Norgannon"}, respuesta_correcta = 2},
    {pregunta = "¿Quién es el dragón del tiempo?", opciones = {"Malygos", "Nozdormu", "Ysera", "Deathwing"}, respuesta_correcta = 2},
    {pregunta = "¿Qué naga es conocido por su poder arcano?", opciones = {"Azshara", "Neptulon", "Lady Vashj", "Cho'gall"}, respuesta_correcta = 1},
    {
        pregunta = "¿Quién fundó la Cruzada Argenta?",
        opciones = {"Tirion Fordring", "Uther el Iluminado", "Bolvar Fordragon", "Alexstrasza"},
        respuesta_correcta = 1
    }, {
        pregunta = "¿Quién fue el primer humano en convertirse en Caballero de la Muerte?",
        opciones = {"Arthas", "Uther", "Bolvar", "Terenas"},
        respuesta_correcta = 1
    }, {
        pregunta = "¿Qué evento causó la caída de Lordaeron?",
        opciones = {"Invasión de la Legión", "Plaga de los no-muertos", "Caída de Arthas", "Guerra de los Ancestros"},
        respuesta_correcta = 2
    },
    {
        pregunta = "¿Qué titán maligno corrompió a los orcos?",
        opciones = {"Sargeras", "Kil'jaeden", "Archimonde", "Ner'zhul"},
        respuesta_correcta = 1
    }, {
        pregunta = "¿Cuál es la ciudadela de la Corona de Hielo?",
        opciones = {"Naxxramas", "Ciudadela de la Corona de Hielo", "Ulduar", "Karazhan"},
        respuesta_correcta = 2
    }, {pregunta = "¿Quién es la esposa de Thrall?", opciones = {"Aggra", "Sylvanas", "Jaina", "Tyrande"}, respuesta_correcta = 1},
    {pregunta = "¿Quién es el Rey Dragón Negro?", opciones = {"Deathwing", "Malygos", "Nozdormu", "Nefarian"}, respuesta_correcta = 1},
    {
        pregunta = "¿Qué titán dio origen a los elfos de la noche?",
        opciones = {"Aman'Thul", "Eonar", "Norgannon", "Sargeras"},
        respuesta_correcta = 3
    }, {
        pregunta = "¿Quién fue el traidor en Lordaeron que desató la Plaga?",
        opciones = {"Arthas", "Kel'Thuzad", "Uther", "Terenas"},
        respuesta_correcta = 1
    }, {
        pregunta = "¿Qué reino es el hogar de los elfos de sangre?",
        opciones = {"Quel'Thalas", "Lordaeron", "Dalaran", "Darnassus"},
        respuesta_correcta = 1
    }, {
        pregunta = "¿Quién es la líder de los elfos de la noche en Teldrassil?",
        opciones = {"Tyrande Susurraverdad", "Malfurion Tempestira", "Illidan", "Maiev"},
        respuesta_correcta = 1
    },
    {pregunta = "¿Quién protege el Árbol Mundo, Nordrassil?", opciones = {"Tyrande", "Malfurion", "Cenarius", "Illidan"}, respuesta_correcta = 2},
    {
        pregunta = "¿Qué jefe de Ulduar controla a los constructos de hierro?",
        opciones = {"Ignis el Maestro de la Caldera", "Thorim", "Hodir", "Freya"},
        respuesta_correcta = 1
    }, {
        pregunta = "¿Quién es el señor del hielo y gobernante de la Plaga?",
        opciones = {"Kel'Thuzad", "Arthas", "Bolvar", "Anub'arak"},
        respuesta_correcta = 2
    }, {
        pregunta = "¿Qué jefe de Naxxramas es el señor de los constructos muertos vivientes?",
        opciones = {"Kel'Thuzad", "Patchwerk", "Maexxna", "Gluth"},
        respuesta_correcta = 1
    },
    {pregunta = "¿Qué titán custodia la magia de Azeroth?", opciones = {"Norgannon", "Eonar", "Aman'Thul", "Khaz'goroth"}, respuesta_correcta = 1},
    {pregunta = "¿Quién fue el traidor en Ulduar?", opciones = {"Hodir", "Yogg-Saron", "Freya", "Thorim"}, respuesta_correcta = 2}, {
        pregunta = "¿Qué jefe de banda es conocido por su habilidad de controlar veneno?",
        opciones = {"Maexxna", "Gluth", "Sapphiron", "Anub'arak"},
        respuesta_correcta = 1
    }, {pregunta = "¿Quién lidera los draenei en la Exodar?", opciones = {"Velen", "Nobundo", "Maraad", "Kil'jaeden"}, respuesta_correcta = 1},
    {pregunta = "¿Quién es el señor del fuego negro?", opciones = {"Ragnaros", "Deathwing", "Malygos", "Nozdormu"}, respuesta_correcta = 2},
    {pregunta = "¿Qué dragón azul protege la magia?", opciones = {"Nozdormu", "Malygos", "Deathwing", "Alexstrasza"}, respuesta_correcta = 2}, {
        pregunta = "¿Qué jefe de Ulduar es conocido como El Vigía de la Tormenta?",
        opciones = {"Thorim", "Hodir", "Ignis", "Yogg-Saron"},
        respuesta_correcta = 1
    },
    {
        pregunta = "¿Quién creó la Ciudadela de la Corona de Hielo?",
        opciones = {"Arthas", "Kel'Thuzad", "Anub'arak", "Bolvar"},
        respuesta_correcta = 1
    },
    {pregunta = "¿Qué líder draenei se convirtió en chamán?", opciones = {"Velen", "Nobundo", "Kil'jaeden", "Maraad"}, respuesta_correcta = 2},
    {pregunta = "¿Quién es la Reina de los dragones negros?", opciones = {"Alexstrasza", "Ysera", "Sindragosa", "Malygos"}, respuesta_correcta = 3},
    {
        pregunta = "¿Qué jefe de banda tiene control sobre los muertos vivientes en Naxxramas?",
        opciones = {"Patchwerk", "Gluth", "Thaddius", "Instructor Razuvious"},
        respuesta_correcta = 2
    }, {
        pregunta = "¿Quién es la líder de los elfos de sangre?",
        opciones = {"Lor'themar Theron", "Kael'thas", "Sylvanas", "Tyrande"},
        respuesta_correcta = 1
    }, {
        pregunta = "¿Qué titán es conocido como el arquitecto de Ulduar?",
        opciones = {"Norgannon", "Khaz'goroth", "Aman'Thul", "Eonar"},
        respuesta_correcta = 1
    }, {
        pregunta = "¿Quién es la reina de los elfos de sangre durante WotLK?",
        opciones = {"Sylvanas", "Kael'thas", "Lor'themar", "Alexstrasza"},
        respuesta_correcta = 3
    }, {
        pregunta = "¿Qué jefe de banda es conocido por su habilidad de hielo en ICC?",
        opciones = {"Sindragosa", "Anub'arak", "Kel'Thuzad", "Lady Deathwhisper"},
        respuesta_correcta = 1
    }, {
        pregunta = "¿Qué titán enseñó a Nobundo la chamanería?",
        opciones = {"Eonar", "Aman'Thul", "Khaz'goroth", "Norgannon"},
        respuesta_correcta = 1
    },
    {
        pregunta = "¿Quién es el señor de los titanes caídos?",
        opciones = {"Sargeras", "Kil'jaeden", "Archimonde", "Ner'zhul"},
        respuesta_correcta = 1
    }, {
        pregunta = "¿Qué jefe de banda es un elemental de fuego en Ulduar?",
        opciones = {"Ignis", "Hodir", "Thorim", "Flame Leviathan"},
        respuesta_correcta = 1
    }, {
        pregunta = "¿Qué héroe humano se convirtió en caballero de la muerte?",
        opciones = {"Arthas", "Uther", "Bolvar", "Terenas"},
        respuesta_correcta = 1
    }, {pregunta = "¿Qué jefe de ICC es el Lich King?", opciones = {"Arthas", "Kel'Thuzad", "Sindragosa", "Anub'arak"}, respuesta_correcta = 1}, {
        pregunta = "¿Qué región de Northrend es hogar de los vrykuls?",
        opciones = {"Howling Fjord", "Borean Tundra", "Dragonblight", "Icecrown"},
        respuesta_correcta = 1
    },
    {pregunta = "¿Quién es la líder de los draenei en Shattrath?", opciones = {"Velen", "Nobundo", "Maraad", "Kil'jaeden"}, respuesta_correcta = 1},
    {
        pregunta = "¿Qué jefe de ICC protege el trono del Rey Exánime?",
        opciones = {"Lich King", "Sindragosa", "Kel'Thuzad", "Lady Deathwhisper"},
        respuesta_correcta = 1
    }, {
        pregunta = "¿Qué titán fue capturado por Sargeras y la Legión?",
        opciones = {"Norgannon", "Khaz'goroth", "Eonar", "Aman'Thul"},
        respuesta_correcta = 4
    }, {
        pregunta = "¿Qué jefe de banda tiene habilidades de veneno en Naxxramas?",
        opciones = {"Maexxna", "Gluth", "Thaddius", "Razuvious"},
        respuesta_correcta = 1
    }, {
        pregunta = "¿Quién es el dragón de la tierra en Azeroth?",
        opciones = {"Nozdormu", "Ysera", "Neltharion/Deathwing", "Alexstrasza"},
        respuesta_correcta = 3
    }, {
        pregunta = "¿Qué jefe de banda de Ulduar es el guardián de la tormenta?",
        opciones = {"Thorim", "Hodir", "Ignis", "Flame Leviathan"},
        respuesta_correcta = 1
    }, {
        pregunta = "¿Quién es la líder de los elfos de la noche?",
        opciones = {"Tyrande Susurraverdad", "Malfurion", "Illidan", "Maiev"},
        respuesta_correcta = 1
    }, {
        pregunta = "¿Qué jefe de ICC usa hielo y controla a los no-muertos?",
        opciones = {"Sindragosa", "Lady Deathwhisper", "Kel'Thuzad", "Lich King"},
        respuesta_correcta = 4
    }, {
        pregunta = "¿Quién es el líder de los elfos de sangre en Quel'Thalas?",
        opciones = {"Lor'themar Theron", "Kael'thas", "Sylvanas", "Alexstrasza"},
        respuesta_correcta = 1
    },
    {pregunta = "¿Qué titán enseñó magia a los draenei?", opciones = {"Norgannon", "Eonar", "Khaz'goroth", "Aman'Thul"}, respuesta_correcta = 2},
    {
        pregunta = "¿Qué jefe de ICC es conocido como el Señor del Terror?",
        opciones = {"Kel'Thuzad", "Arthas", "Sindragosa", "Anub'arak"},
        respuesta_correcta = 2
    },
    {pregunta = "¿Qué jefe de banda controla los constructos de hierro?", opciones = {"Ignis", "Thorim", "Hodir", "Freya"}, respuesta_correcta = 1},
    {pregunta = "¿Quién es la líder espiritual de los draenei?", opciones = {"Velen", "Nobundo", "Maraad", "Kil'jaeden"}, respuesta_correcta = 1},
    {
        pregunta = "¿Qué dragón es conocido como guardián de la magia arcana?",
        opciones = {"Malygos", "Nozdormu", "Deathwing", "Alexstrasza"},
        respuesta_correcta = 1
    },
    {
        pregunta = "¿Quién traicionó a los humanos y desató la Plaga?",
        opciones = {"Arthas", "Kel'Thuzad", "Uther", "Terenas"},
        respuesta_correcta = 1
    }, {
        pregunta = "¿Qué ciudad es hogar de los magos en Northrend?",
        opciones = {"Dalaran", "Ventormenta", "Forjaz", "Orgrimmar"},
        respuesta_correcta = 1
    }, {
        pregunta = "¿Quién es el maestro de los guardias de la Cripta de Ulduar?",
        opciones = {"Hodir", "Thorim", "Ignis", "Freya"},
        respuesta_correcta = 2
    }, {
        pregunta = "¿Qué titán es conocido como forjador de artefactos?",
        opciones = {"Khaz'goroth", "Norgannon", "Eonar", "Aman'Thul"},
        respuesta_correcta = 1
    }, {
        pregunta = "¿Quién es el líder de los Caballeros de la Muerte humanos?",
        opciones = {"Arthas", "Bolvar", "Uther", "Terenas"},
        respuesta_correcta = 2
    }, {
        pregunta = "¿Qué jefe de ICC es la líder de los sirvientes no-muertos?",
        opciones = {"Lady Deathwhisper", "Kel'Thuzad", "Sindragosa", "Anub'arak"},
        respuesta_correcta = 1
    }, {
        pregunta = "¿Qué dragón verde protege los sueños y la naturaleza?",
        opciones = {"Ysera", "Alexstrasza", "Nozdormu", "Deathwing"},
        respuesta_correcta = 1
    }, {
        pregunta = "¿Quién es el señor de la guerra de los vrykuls?",
        opciones = {"Volkhan", "King Ymiron", "King Varian", "Anub'arak"},
        respuesta_correcta = 2
    }, {
        pregunta = "¿Qué jefe de Ulduar controla la electricidad y las tormentas?",
        opciones = {"Thorim", "Hodir", "Ignis", "Freya"},
        respuesta_correcta = 1
    }, {
        pregunta = "¿Quién lidera los draenei en la lucha contra la Legión?",
        opciones = {"Velen", "Nobundo", "Kil'jaeden", "Maraad"},
        respuesta_correcta = 1
    }, {
        pregunta = "¿Qué titán es conocido como el protector de la vida?",
        opciones = {"Eonar", "Norgannon", "Khaz'goroth", "Aman'Thul"},
        respuesta_correcta = 1
    },
    {pregunta = "¿Quién es la reina de los dragones azules?", opciones = {"Sindragosa", "Malygos", "Alexstrasza", "Ysera"}, respuesta_correcta = 2},
    {
        pregunta = "¿Qué jefe de ICC es el dragón de hielo?",
        opciones = {"Sindragosa", "Kel'Thuzad", "Lady Deathwhisper", "Lich King"},
        respuesta_correcta = 1
    }, {pregunta = "¿Qué jefe de banda usa veneno en Naxxramas?", opciones = {"Maexxna", "Gluth", "Thaddius", "Razuvious"}, respuesta_correcta = 1},
    {
        pregunta = "¿Qué héroe draenei fue el primer chamán de su raza?",
        opciones = {"Velen", "Nobundo", "Kil'jaeden", "Maraad"},
        respuesta_correcta = 2
    }, {
        pregunta = "¿Qué dragón negro destruyó gran parte de Azeroth?",
        opciones = {"Deathwing", "Nefarian", "Malygos", "Nozdormu"},
        respuesta_correcta = 1
    }, {
        pregunta = "¿Qué jefe de banda es conocido como guardián de la tormenta?",
        opciones = {"Thorim", "Hodir", "Ignis", "Flame Leviathan"},
        respuesta_correcta = 1
    }, {
        pregunta = "¿Qué líder de los elfos de la noche es sumamente sabia y guerrera?",
        opciones = {"Tyrande Susurraverdad", "Malfurion", "Illidan", "Maiev"},
        respuesta_correcta = 1
    },
    {pregunta = "¿Quién lidera la ciudad de Dalaran en Northrend?", opciones = {"Khadgar", "Jaina", "Antonidas", "Medivh"}, respuesta_correcta = 1},
    {
        pregunta = "¿Quién es el señor del caos y la destrucción de los mundos?",
        opciones = {"Sargeras", "Kil'jaeden", "Archimonde", "Ner'zhul"},
        respuesta_correcta = 1
    },
    {pregunta = "¿Qué jefe de Ulduar controla los constructos de hielo?", opciones = {"Hodir", "Thorim", "Ignis", "Freya"}, respuesta_correcta = 1},
    {
        pregunta = "¿Qué titán ayudó a los draenei a sobrevivir?",
        opciones = {"Eonar", "Norgannon", "Khaz'goroth", "Aman'Thul"},
        respuesta_correcta = 1
    }, {
        pregunta = "¿Quién es el líder espiritual de los draenei en Azeroth?",
        opciones = {"Velen", "Nobundo", "Maraad", "Kil'jaeden"},
        respuesta_correcta = 1
    }, {
        pregunta = "¿Qué jefe de banda es conocido como el maestro de las trampas venenosas?",
        opciones = {"Maexxna", "Gluth", "Thaddius", "Razuvious"},
        respuesta_correcta = 1
    }, {
        pregunta = "¿Qué dragón verde protege la naturaleza y los sueños?",
        opciones = {"Ysera", "Alexstrasza", "Nozdormu", "Deathwing"},
        respuesta_correcta = 1
    },
    {pregunta = "¿Qué jefe de banda es un elemental de fuego?", opciones = {"Ignis", "Hodir", "Thorim", "Flame Leviathan"}, respuesta_correcta = 1},
    {
        pregunta = "¿Qué líder draenei se convirtió en chamán para guiar a su pueblo?",
        opciones = {"Velen", "Nobundo", "Maraad", "Kil'jaeden"},
        respuesta_correcta = 2
    }, {pregunta = "¿Qué jefe de ICC es el Rey Exánime?", opciones = {"Arthas", "Kel'Thuzad", "Sindragosa", "Anub'arak"}, respuesta_correcta = 1},
    {
        pregunta = "¿Qué región de Northrend es hogar de los vrykuls?",
        opciones = {"Howling Fjord", "Borean Tundra", "Dragonblight", "Icecrown"},
        respuesta_correcta = 1
    },
    {pregunta = "¿Qué líder draenei ayuda a la Cruzada Argenta?", opciones = {"Velen", "Nobundo", "Kil'jaeden", "Maraad"}, respuesta_correcta = 1},
    {
        pregunta = "¿Qué titán fue capturado por la Legión Ardiente?",
        opciones = {"Aman'Thul", "Norgannon", "Khaz'goroth", "Eonar"},
        respuesta_correcta = 1
    }, {pregunta = "¿Quién protege la magia de Azeroth?", opciones = {"Norgannon", "Khaz'goroth", "Eonar", "Aman'Thul"}, respuesta_correcta = 1},
    {pregunta = "¿Quién es el guardián de los sueños?", opciones = {"Ysera", "Alexstrasza", "Malygos", "Nozdormu"}, respuesta_correcta = 1},
    {pregunta = "¿Qué jefe de banda controla la electricidad?", opciones = {"Thorim", "Hodir", "Ignis", "Freya"}, respuesta_correcta = 1}, {
        pregunta = "¿Qué héroe humano se convierte en caballero de la muerte?",
        opciones = {"Arthas", "Uther", "Bolvar", "Terenas"},
        respuesta_correcta = 1
    }, {
        pregunta = "¿Quién es el dragón negro que destruye Azeroth?",
        opciones = {"Deathwing", "Nefarian", "Malygos", "Nozdormu"},
        respuesta_correcta = 1
    },
    {pregunta = "¿Quién lidera la ciudad de Dalaran en Northrend?", opciones = {"Khadgar", "Jaina", "Antonidas", "Medivh"}, respuesta_correcta = 1},
    {
        pregunta = "¿Qué líder de los elfos de sangre gobierna Quel'Thalas?",
        opciones = {"Lor'themar Theron", "Kael'thas", "Sylvanas", "Alexstrasza"},
        respuesta_correcta = 1
    }
}

-- tabla para guardar índices ya usados
local usadas = {}
local preguntaActual = nil
local count = 10

local cache = {}

-- función para obtener una pregunta aleatoria que no se haya repetido
local function getPreguntaAleatoria(player)
    -- si ya salieron todas, reinicia
    if #cache[player:GetGUIDLow()].usadas >= #trivia then cache[player:GetGUIDLow()].usadas = {} end

    local index
    repeat index = math.random(1, #trivia) until not cache[player:GetGUIDLow()].usadas[index]

    cache[player:GetGUIDLow()].usadas[index] = true
    return trivia[index]
end

local function verificarRespuesta(pregunta, respuestaJugador)
    if type(respuestaJugador) ~= "number" then return false end
    if respuestaJugador < 1 or respuestaJugador > #pregunta.opciones then return false end
    return respuestaJugador == pregunta.respuesta_correcta
end

-- Función para crear un conteo regresivo de 10 segundos  
function StartCountdown(eventid, delay, repeats, player)
    if cache[player:GetGUIDLow()].count > 0 then
        player:SendRaidNotification("Conteo regresivo: " .. cache[player:GetGUIDLow()].count)
        cache[player:GetGUIDLow()].count = cache[player:GetGUIDLow()].count - 1
    else
        player:SendRaidNotification("¡Tiempo terminado!")
        cache[player:GetGUIDLow()].preguntaActual = nil
        cache[player:GetGUIDLow()].count = 10
        cache[player:GetGUIDLow()].usadas = {}
        player:GossipComplete()
        player:RemoveEvents() -- Detener el evento
    end
end

local function OnGossipHello(event, player, object)
    player:GossipClearMenu()
    if cache[player:GetGUIDLow()] == nil then
        cache[player:GetGUIDLow()] = {
            preguntaActual = nil,
            count = 10,
            usadas = {}
        }
    end

    if cache[player:GetGUIDLow()].preguntaActual == nil then
        player:GossipMenuAddItem(0, "Iniciar Juego", 0, 1, false, "¿Quieres intentarlo? debes depositar 10 Fichas.")
        player:GossipMenuAddItem(0, "Salir", 0, 3)

        player:SendGossipText(text, npc)
    else
        player:SendRaidNotification("¡Nueva pregunta! Responde rápido.")
        local pregunta = cache[player:GetGUIDLow()].preguntaActual.pregunta .. "\n\nOpciones:\n" .. "\n1. " .. cache[player:GetGUIDLow()].preguntaActual.opciones[1] .. "\n2. " ..
        cache[player:GetGUIDLow()].preguntaActual.opciones[2] .. "\n3. " .. cache[player:GetGUIDLow()].preguntaActual.opciones[3] .. "\n4. " .. cache[player:GetGUIDLow()].preguntaActual.opciones[4] ..
                             "\n\nTienes 10 segundos para enviar la respuesta (1-4)."
        player:GossipMenuAddItem(0, "Responder opción (1-4)", 0, 2, true)
        player:SendGossipText(pregunta, npc)
        -- Crear evento para el siguiente segundo (1000ms = 1 segundo)  
        player:RegisterEvent(StartCountdown, 1000, 11)
    end

    player:GossipSendMenu(npc, object)
end

RegisterCreatureGossipEvent(npc, 1, OnGossipHello)

local function OnGossipSelect(event, player, object, sender, intid, code, menu_id)
    if intid == 1 then
        if player:HasItem(ficha, 10) then
            player:RemoveItem(ficha, 10)
            player:SendRaidNotification("Que empiece el juego!")
            cache[player:GetGUIDLow()].preguntaActual = getPreguntaAleatoria(player)
            OnGossipHello(event, player, object)
        else
            player:SendNotification("No tienes suficientes Fichas para jugar. Necesitas 10 Fichas.")
        end
    elseif intid == 2 then
        if cache[player:GetGUIDLow()].preguntaActual == nil then
            player:SendNotification("No hay una pregunta activa. Inicia un nuevo juego.")
            player:GossipComplete()
            return
        end

        if verificarRespuesta(cache[player:GetGUIDLow()].preguntaActual, tonumber(code)) then
            player:SendNotification("|CFF00FF00¡Correcto! Has ganado 2 Fichas.|r")
            player:AddItem(ficha, 2)
            player:RemoveEvents() -- Detener el conteo regresivo
            cache[player:GetGUIDLow()].count = 10
            cache[player:GetGUIDLow()].preguntaActual = getPreguntaAleatoria(player)
            OnGossipHello(event, player, object)
        else
            local correcta = cache[player:GetGUIDLow()].preguntaActual.opciones[cache[player:GetGUIDLow()].preguntaActual.respuesta_correcta]
            player:SendNotification("Incorrecto. La respuesta correcta era: " .. correcta .. ". ¡Inténtalo de nuevo!")
            player:RemoveEvents() -- Detener el conteo regresivo
            cache[player:GetGUIDLow()].count = 10
            cache[player:GetGUIDLow()].preguntaActual = 
            cache[player:GetGUIDLow()].usadas = {}
            player:GossipComplete()
        end
    elseif intid == 3 then
        player:SendUnitSay("¡Hasta luego!", 0)
        player:GossipComplete()
    end
end

RegisterCreatureGossipEvent(npc, 2, OnGossipSelect)
