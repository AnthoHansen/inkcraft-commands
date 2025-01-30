# IC-Commands
A FiveM resource that allows server administrators to generate and send a list of available commands to Discord using webhooks.

## Warning
**This script is intended for development and testing purposes only.** It is not recommended for use in production environments, as any player with access to the command can execute it and potentially expose sensitive command information. Always ensure proper permissions and security measures are in place before deploying any scripts on a live server.

## Installation
1. Download the resource
2. Place it in your FiveM resources folder
3. Add `ensure ic-commands` to your `server.cfg`
4. Configure your Discord webhook URL in the script
5. Restart your server. Et voilà.

## Configuration
Edit the `config.lua` file to customize:

## Features
- **Command Filtering**: Automatically retrieves all registered server commands but excluding system commands and those matching blacklisted prefixes.
- **Discord Integration**: Sends formatted command list to Discord via configurable webhook.
- **Chunk Management**: Handles large command lists by splitting them into chunkss to comply with Discord's character limits.
- Alphabetically sorts commands for better readability.
- Configurable command.
- Configurable blacklisted commands.
- **Rate Limiting**: Implements delays between messages to prevent Discord rate limiting.
- **Error Handling**: Includes comprehensive error checking and debug like: Invalid command list validation, Empty command list detection, Webhook sending confirmation, Player feedback for execution status.

## Dependencies
- FiveM server
- Discord webhook URL

## Technical Details
- Written in Lua.
- Uses FiveM's native functions.
- Implements Discord webhook API.
- Handles messages up to 2000 characters (Discord limit).
- Includes built-in rate limiting protection.

## Error Handling
The script includes various error checks:

## Contributing
Feel free to fork this repository and submit pull requests. For major changes, please open an issue first to discuss what you would like to change.
