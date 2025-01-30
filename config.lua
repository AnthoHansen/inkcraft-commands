Config = {}

Config.Framework = 'standalone' -- Options: 'standalone', 'esx', 'qb' (qb-core and qbx-core compatible)

Config.WebhookUrl = 'YOUR_WEBHOOK_URL' -- Discord Webhook URL

Config.Command = 'commandlist' -- Command Name

Config.AdminGroups = { -- Permission Groups
    'admin'
}

Config.BlacklistCommands = { -- Blacklisted Commands (For not showing in the webhook command list)
    "+",
    "-",
    "_",
    "sv_",
    "adhesive_",
    "citizen_",
    "con_",
    "endpoint_",
    "fileserver",
    "load_server",
    "mysql_connection",
    "net_tcp",
    "netPort",
    "netlib",
    "onesync",
    "onesync_",
    "rateLimiter_",
    "svgui",
    "web_base",
    "temp_",
}