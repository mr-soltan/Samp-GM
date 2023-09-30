/*
 * Irresistible Gaming (c) 2018
 * Developed by Lorenc
 * Module: irresistible\cnr\discord\discord.pwn
 * Purpose: discord implementation in-game
 /

/ Enable or disable discord /
// #define DISCORD_DISABLED //			 !!!! DISABLED BY DEFAULT !!!!

/* ** Includes ** */
#include 							< YSI\y_hooks >

/* ** Disable if discord connector not enabled * **/
#if !defined DISCORD_DISABLED
	#tryinclude 						< discord-connector >
	#tryinclude							< discord-command >
#endif

#if !defined dcconnector_included && !defined DISCORD_DISABLED
	#warning "Discord is disabled as the connector is not found. (https://github.com/maddinat0r/samp-discord-connector)"
	#define DISCORD_DISABLED
#endif

#if !defined _discordcmd_included && !defined DISCORD_DISABLED
	#warning "Discord is disabled as the command handler is not found. (https://github.com/AliLogic/discord-command)"
	#define DISCORD_DISABLED
#endif

/* ** Definitions ** */
/* Guild */
#define DISCORD_GUILD				"899372085464416257"

/* Channels */
#define DISCORD_ADMIN_CHAN			"1119360956624023593"
#define DISCORD_LOG_CHAN			"929304660907528193"
#define DISCORD_CHAT_CHAN			"929304660907528193"
#define DISCORD_COMMANDS_CHAN		"929304947252678686"
#define DISCORD_ASK_CHAN			"1119360713148870787"

/* Roles */
#define DISCORD_ROLE_EXEC 			"920007078335102997"
#define DISCORD_ROLE_DEV 			"925718221439508541"
#define DISCORD_ROLE_COUNCIL 		"919620419936452649"
#define DISCORD_ROLE_LEAD 			"899379777402728458"
#define DISCORD_ROLE_SENIOR 		"919620319294160906"
#define DISCORD_ROLE_GENERAL 		"899374209673859112"
#define DISCORD_ROLE_TRIAL 			"911179211736252467"
#define DISCORD_ROLE_SUPPORT 		"925718439648178246"
#define DISCORD_ROLE_VIP 			"910584788283432971"
#define DISCORD_ROLE_MEMBER 		"933682460649222154"

/* ** Variables ** */
new stock
	DCC_Guild: discordGuild,

	DCC_Channel: discordAdminChan,
	DCC_Channel: discordLogChan,
	DCC_Channel: discordChatChan,
	DCC_Channel: discordCmdsChan,
	DCC_Channel: discordAskChan,

	DCC_Role: discordRoleExec,
	DCC_Role: discordRoleDev,
	DCC_Role: discordRoleCouncil,
	DCC_Role: discordRoleLead,
	DCC_Role: discordRoleSenior,
	DCC_Role: discordRoleGeneral,
	DCC_Role: discordRoleTrial,
	DCC_Role: discordRoleSupport,
	DCC_Role: discordRoleVIP,
	DCC_Role: discordRoleMember
;

/* ** Error Checking ** */
#if defined DISCORD_DISABLED
	stock TMP_DCC_SendChannelMessage( DCC_Channel: channel, const message[ ] ) {
		#pragma unused channel
		#pragma unused message
		return 1;
	}

    #if defined _ALS_DCC_SendChannelMessage
        #undef DCC_SendChannelMessage
    #else
        #define _ALS_DCC_SendChannelMessage
    #endif
    #define DCC_SendChannelMessage TMP_DCC_SendChannelMessage

	stock DCC_SendUserMessage( DCC_User: author, const message[ ] )
	{
		#pragma unused author
		#pragma unused message
		return 1;
	}

	stock DCC_SendChannelMessageFormatted( DCC_Channel: channel, const format[ ], va_args< > ) {
		#pragma unused channel
		#pragma unused format
		return 1;
	}
	#endinput
#endif

/* ** Hooks ** */
hook OnGameModeInit( )
{
    discordGuild = DCC_FindGuildById( DISCORD_GUILD );

	discordAdminChan = DCC_FindChannelById( DISCORD_ADMIN_CHAN );
	discordLogChan = DCC_FindChannelById( DISCORD_LOG_CHAN );
	discordChatChan = DCC_FindChannelById( DISCORD_CHAT_CHAN );
	discordCmdsChan = DCC_FindChannelById( DISCORD_COMMANDS_CHAN );
	discordAskChan = DCC_FindChannelById( DISCORD_ASK_CHAN );

	discordRoleExec = DCC_FindRoleById ( DISCORD_ROLE_EXEC );
	discordRoleDev = DCC_FindRoleById ( DISCORD_ROLE_DEV );
	discordRoleCouncil = DCC_FindRoleById ( DISCORD_ROLE_COUNCIL );
	discordRoleLead = DCC_FindRoleById ( DISCORD_ROLE_LEAD );
	discordRoleSenior = DCC_FindRoleById ( DISCORD_ROLE_SENIOR );
	discordRoleGeneral = DCC_FindRoleById ( DISCORD_ROLE_GENERAL );
	discordRoleTrial = DCC_FindRoleById ( DISCORD_ROLE_TRIAL );
	discordRoleSupport = DCC_FindRoleById ( DISCORD_ROLE_SUPPORT );
	discordRoleVIP = DCC_FindRoleById ( DISCORD_ROLE_VIP );
	discordRoleMember = DCC_FindRoleById ( DISCORD_ROLE_MEMBER );

    DCC_SendChannelMessage( discordChatChan, "**[SG]BOT v1.0 is here.**" );
    return 1;
}

/* ** Functions ** */
stock ReturnDiscordName( DCC_User: author ) {
	static
		name[ 32 ];

	DCC_GetUserName( author, name, sizeof( name ) );
	return name;
}

stock discordLevelToString( DCC_User: author )
{
	static
		szRank[ 15 ],
		bool: hasExec, bool: hasDev, bool: hasCouncil, bool: hasLead, bool: hasSenior,
		bool: hasGeneral, bool: hasTrial, bool: hasSupport, bool: hasVIP, bool: hasMember;

	DCC_HasGuildMemberRole( discordGuild, author, discordRoleExec, hasExec );
	DCC_HasGuildMemberRole( discordGuild, author, discordRoleDev, hasDev );
	DCC_HasGuildMemberRole( discordGuild, author, discordRoleCouncil, hasCouncil );
	DCC_HasGuildMemberRole( discordGuild, author, discordRoleLead, hasLead );
	DCC_HasGuildMemberRole( discordGuild, author, discordRoleSenior, hasSenior );
	DCC_HasGuildMemberRole( discordGuild, author, discordRoleGeneral, hasGeneral );
	DCC_HasGuildMemberRole( discordGuild, author, discordRoleTrial, hasTrial );
	DCC_HasGuildMemberRole( discordGuild, author, discordRoleSupport, hasSupport );
	DCC_HasGuildMemberRole( discordGuild, author, discordRoleVIP, hasVIP );
	DCC_HasGuildMemberRole( discordGuild, author, discordRoleMember, hasMember );

	if ( hasExec ) szRank = "Executive";
	else if ( hasDev ) szRank = "Developer";
	else if ( hasCouncil ) szRank = "Council";
	else if ( hasLead ) szRank = "Lead Admin";
	else if ( hasSenior ) szRank = "Senior Admin";
	else if ( hasGeneral ) szRank = "General Admin";
	else if ( hasTrial ) szRank = "Trial Admin";
	else if ( hasSupport ) szRank = "Supporter";
	else if ( hasVIP ) szRank = "VIP";
	else if ( hasMember ) szRank = "Member";

    return szRank;
}

stock DCC_SendUserUsage( DCC_User: author, const message[ ] )
{
	static
		user_id[ 64 ];

	DCC_GetUserId( author, user_id, sizeof( user_id ) );
	format( szBigString, sizeof( szBigString ), "<@%s> %s", user_id, message );
	return DCC_SendChannelMessage( discordCmdsChan, szBigString );
}

public OnDiscordCommandPerformed(DCC_Channel: channel, DCC_User: author, bool: success)
{
	if (!success) {
		return DCC_SendChannelMessage(channel, "**[ERROR]** You have entered an invalid command. To display the command list type !commands.");
	}

	return 1;
}

public DCC_OnGuildMemberAdd(DCC_Guild:guild, DCC_User:user)
{
	DCC_SendUserUsage(user, "Hey there! I am **[SG]BOT**, i am here to help you out!\nUse **!commands** to see all commands i offer.\nYou need to have **member** role trough to use them, so first verify your account!");
	return 1;
}

stock DCC_SendChannelMessageFormatted( DCC_Channel: channel, const format[ ], va_args< > ) {
	return DCC_SendChannelMessage( channel, va_return( format, va_start< 2 > ) );
}
