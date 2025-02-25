# inkcraft-commands
Un recurso de FiveM que permite a los administradores del servidor generar y enviar una lista de comandos disponibles a Discord mediante webhooks.

## Advertencia
**Este script está diseñado solo para desarrollo y pruebas.** No se recomienda su uso en entornos de producción, ya que cualquier jugador puede ejecutar el comando y exponer potencialmente información sensible. Asegúrate de establecer los permisos y medidas de seguridad adecuadas antes de implementar cualquier script en un servidor en vivo.

## Instalación
1. Descarga el recurso.
2. Colócalo en la carpeta de recursos de FiveM.
3. Agrega `ensure inkcraft-commands` en tu `server.cfg`.
4. Configura la URL del webhook de Discord en el script.
5. Reinicia tu servidor. ¡Y listo!

## Configuración
Edita el archivo `config.lua` para personalizarlo: BlacklistCommands, AdminGroups, Command, WebhookUrl y Framework.

## Características
- **Compatibilidad con Frameworks**: El script puede usarse como **Standalone** pero también es compatible con ESX, QBCore y QBox con los permisos de grupo.
- **Filtrado de Comandos**: Recupera automáticamente todos los comandos registrados en el servidor, excluyendo comandos del sistema y aquellos que coincidan con prefijos en lista negra.
- **Integración con Discord**: Envía la lista de comandos formateada a Discord mediante un webhook configurable.
- **Gestión de Bloques**: Maneja listas de comandos extensas dividiéndolas en bloques para cumplir con los límites de caracteres de Discord.
- Ordena los comandos alfabéticamente para mejor legibilidad.
- Comando configurable.
- Comandos configurables en blacklist.
- Lista de comandos en lista negra configurable.
- Configurable el apartado de grupos de administración.
- **Limitación de Tasa**: Implementa retrasos entre mensajes para evitar restricciones de envío en Discord.
- **Manejo de Errores**: Incluye validaciones de errores detalladas como: validación de listas de comandos inválidas, detección de listas vacías, confirmación de envío del webhook y retroalimentación para el jugador sobre el estado de ejecución.

## Dependencias
- Servidor FiveM
- URL del webhook de Discord
- Compatible con ESX, QBCore y QBox.

## Detalles Técnicos
- Escrito en Lua.
- Usa funciones nativas de FiveM.
- Implementa la API de webhooks de Discord.
- Maneja mensajes de hasta 2000 caracteres (límite de Discord).
- Incluye protección integrada contra limitaciones de tasa.

## Contribución
Si deseas mejorar este script, siéntete libre de hacer un fork del repositorio y enviar pull requests. Para cambios importantes, abre un issue primero para discutir qué te gustaría modificar.
