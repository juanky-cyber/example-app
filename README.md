## CONFIGURACION Y FUNCIONAMIENTO DESPLIGUE EN VERCEL:

Antes de empezar iniciar sesion o registrarse en vercel.
https://vercel.com/

## PREPARACION Y CONFIGURACION EL PROYECTO:
## Fuentes 
how-to-deploy-laravel-project-to-vercel-7b3c2800e974
laravel-vercel-serverless-de-forma-simple-y-gratuita-d370f294530f
https://laravel.com/docs/12.x/artisan

1. Creamos una carpeta api en la raiz del proyecto.

2. Dentro de la carpeta creamos un archivo "index.php"

3. Añade este contenido dentro de la carpeta index.php:
      <?php
      require __DIR__ . '/../public/index.php';

4. Crear .vercelignore: Crea este archivo en la raíz y añade:
      /vendor

5. Crear vercel.json: Crea este archivo en la raíz y añade:
{
    "version": 2,
      "framework": null,
    "functions": {
        "api/index.php": { "runtime": "vercel-php@0.7.1" }
    },
    "routes": [{
        "src": "/(.*)",
        "dest": "/api/index.php"
    }],
    "env": {
        "APP_ENV": "production",
        "APP_DEBUG": "true",
        "APP_URL": "https://example-app-deploy-vercel-8rrg7j8lq-juankys-projects-68b9f4b5.vercel.app/",

        "APP_CONFIG_CACHE": "/tmp/config.php",
        "APP_EVENTS_CACHE": "/tmp/events.php",
        "APP_PACKAGES_CACHE": "/tmp/packages.php",
        "APP_ROUTES_CACHE": "/tmp/routes.php",
        "APP_SERVICES_CACHE": "/tmp/services.php",
        "VIEW_COMPILED_PATH": "/tmp",

        "CACHE_DRIVER": "array",
        "LOG_CHANNEL": "stderr",
        "SESSION_DRIVER": "cookie"
    }
}

Una vez configurado todo esto, subelo al proyecto de github.

6. Configurar el directorio de salida en Vercel:
Creamos una carpeta dist en la raiz para engañar al sistema.

Instalamos vercel para desplegarlo desde la terminal con: 
npm install -g vercel

Desplegamos el proyecto usando este comando:

      vercel .

te saldra lo siguiente y vas dandole al enter y rellenando lo que haga falta

? Set up and deploy “~\Desktop\example-app-deploy_vercel”? yes
? Which scope should contain your project? juanky's projects
? Link to existing project? no
? What’s your project’s name? example-app-deploy-vercel
? In which directory is your code located? ./
Auto-detected Project Settings (Vite):
- Build Command: vite build
- Development Command: vite --port $PORT
- Install Command: `yarn install`, `pnpm install`, `npm install`, or `bun install`
- Output Directory: dist
? Want to modify these settings? no
? Do you want to change additional project settings? no
🔗  Linked to juankys-projects-68b9f4b5/example-app-deploy-vercel (created .vercel and added it to .gitignore)
? Detected a repository. Connect it to this project? yes
> Connecting GitHub repository: https://github.com/juanky-cyber/example-app
> Connected

Configurar la carpeta public:

Entramos nuestro proyecto en vercel.

ilustracion 2


Entramos a "settings".

ilustracion 2


En los ajustes:

Entramos a "Build and Deployment".

Dentro de "Framework Settings" En el apartado "Framework Preset" seleccionamos "Other".

Activamos el apartado "Output Directory" y ponemos "public".

Guardamos "save".

ilustracion 2

¿Por qué?: Laravel usa la carpeta public para proteger el código fuente y servir el archivo index.php de forma segura.


Con esto ya estaria hecho el despligue, si intentamos entrar a la web de despligue no saldra nada solo errores, ya que no nos hemos conectado a una base de datos.
7. Conexion con la base de datos:
En este caso me conectare a una base de datos postgres previamente configurada en render, pero bueno para la conexion es igual en todas.

Entramos en ajustes:

Entramos a "Environment Variables".
Damos en "Add Environment Variable".
Añadimos las variables para conectarnos con la base de datos.
ilustracion 3

Variables.

APP_KEY: Esta se saca del archivo ".env" del proyecto

DB_CONNECTION: pgsql (que base de datos es (Postres, MySQL, ...etc))

DB_HOST: host / dominio

DB_PORT: 5432

DB_DATABASE: Nombre de la base de datos

DB_USERNAME: El usuario

DB_PASSWORD: La contraseña


Pequeño inciso esto se puede poner tambien en el archivo ".env" o el el archivo "vercel.json" la cosa que configurar las variables en el panel de Vercel evita filtrar contraseñas en el historial de Git y permite mantener las credenciales locales del .env totalmente separadas de las de producción.

Error Read-only file system
Error debido a que la arquitectura de Vercel impide escribir en la carpeta storage del proyecto.

Solución: Se implementó $app->useStoragePath('/tmp'); para utilizar el directorio temporal /tmp, único espacio con permisos de escritura permitidos en entornos Serverless.
Poner esto al final de archivo bootstrap / app.php

// Comprueba en el archivo vercel.json si esta en producción.
   if (env('APP_ENV') === 'production') {
      $app->useStoragePath('/tmp');
   }
   return $app;

Visualizacion del despligue.

https://example-lo3dryhuk-antonios-projects-70787aa3.vercel.app

ilustracion 4

CONFIGURACIÓN DE BASE DE DATOS Y AUTO-INSTALACIÓN
Base de Datos: Se ha creado una instancia de PostgreSQL en Render.

Comenta esta linea de routes/web.php.

   Route::get('/', function () {
      return redirect()->route('players.index');
   });
Descomentar esto de routes/web.php.

Route::get('/', function () {
   // Si no están los jugadores, lanzamos la limpieza y carga automática
   if (!Schema::hasTable('players')) {
      try {
            // 'migrate:fresh' limpia la estructura y '--seed' carga los datos iniciales
            Artisan::call('migrate:fresh', [
               '--force' => true,
               '--seed' => true 
            ]);

            return "¡Base de datos configurada correctamente! <a href='".route('players.index')."'>Ver jugadores</a>";
      } catch (\Exception $e) {
            return "Error en la instalación: " . $e->getMessage();
      }
   }
   // Si ya existe la estructura, redirige al listado principal
   return redirect()->route('players.index');
});
Este código comprueba si la base de datos está vacía; si lo está, crea las tablas y mete los datos de prueba automáticamente, y si ya está todo listo, te manda directo a la lista de jugadores.

Poner las Variable de entorno que genera servicio postgres de render en vercel (apartado 7 de este documento).
