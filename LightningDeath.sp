#pragma semicolon 1

#include <sourcemod>
#include <sdktools>  

new g_LightningSprite;  
new g_SteamSprite;  

public Plugin:myinfo = 
{
	name = "LightningDeath",
	author = "https://vk.com/one7hop",
	version = "1.0"
}

public OnPluginStart()  
{  
    HookEvent("player_death", Event_PlayerDeath, EventHookMode_Post);  
}  

public OnMapStart()  
{  
    g_SteamSprite = PrecacheModel("sprites/steam1.vmt");   
    g_LightningSprite = PrecacheModel("sprites/lgtning.vmt");  
}  

public Event_PlayerDeath(Handle:event, const String:name[], bool:dontBroadcast)  
{ 
    //3) Делаем направление искр (к началу координат карты) 
    //4) Делаем цвет молнии (у нас синий) 
    new Float:pos[3], Float:startpos[3], Float:dir[3] = {0.0, 0.0, 0.0}, color[4] = {0, 0, 255, 255};  
     
    GetClientAbsOrigin(GetClientOfUserId(GetEventInt(event, "userid")), pos);  

    // Получаем верхнюю точку молнии + случайные позиции Х и У и выше нижней позиции на 800, чтобы молния била сверху вниз  
    startpos[0] = pos[0] + GetRandomInt(-500, 500);   
    startpos[1] = pos[1] + GetRandomInt(-500, 500);   
    startpos[2] = pos[2] + 800;   

    TE_SetupBeamPoints(startpos, pos, g_LightningSprite, 0, 0, 0, 0.2, 20.0, 10.0, 0, 2.0, color, 3); //Делаем лазер с амплитудой в 2 единицы  
    TE_SendToAll(); // Применяем  

    TE_SetupBeamPoints(startpos, pos, g_LightningSprite, 0, 0, 0, 0.2, 10.0, 5.0, 0, 1.0, {255, 255, 255, 255}, 3); //Делаем второй лазер (белый) с амплитудой в 1 единицу  
    TE_SendToAll(); // Применяем //И в 2 раза уже, чтобы молния смотрелась органично  

    TE_SetupSparks(pos, dir, 5000, 1000); //Делаем искры  
    TE_SendToAll(); // Применяем  

    TE_SetupEnergySplash(pos, dir, false); //Делаем всплеск энергии  
    TE_SendToAll(); // Применяем  

    TE_SetupSmoke(pos, g_SteamSprite, 5.0, 10); //Делаем дым  
    TE_SendToAll(); // Применяем  

    // TE_SetupBeamRingPoint(pos, 10.0, 70.0, g_BeamSprite, g_HaloSprite, 0, 15, 15.0, 2.0, 0.0, {255, 255, 0, 255}, 10, 0); //Можно добавить маяк, если хотите.   
    // TE_SendToAll();  
    if (!dontBroadcast) 
        SetEventBroadcast(event, true);  
}  