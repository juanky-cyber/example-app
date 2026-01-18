## CONFIGURACION Y FUNCIONAMIENTO DESPLIGUE EN VERCEL:

### Antes de empezar iniciar sesion / registrarse en vercel.
   - https://vercel.com/


## PREPARACION Y CONFIGURACION EL PROYECTO:

   - Funtes sacadas de "Medium" y documentacion del Laravel.
     - https://rezamandala.medium.com/how-to-deploy-laravel-project-to-vercel-7b3c2800e974
     - https://cvallejo.medium.com/laravel-vercel-serverless-de-forma-simple-y-gratuita-d370f294530f
     - https://laravel.com/docs/12.x/artisan
  
     ### 1. Crea una carpeta "api" en la raiz del proyecto.

     ### 2. Dentro de la carpeta creamos un archivo "index.php"

      ![ilustracion 1](Image/vercel/api.png)
      
      <br>
      
     ### 3. Añade este contenido dentro de la carpeta **index.php**:
   
      ```php
            <?php
            require __DIR__ . '/../public/index.php';
      ```

      - **¿Qué hace?** Redirige todas las peticiones que recibe Vercel hacia el archivo principal de Laravel en la carpeta public.
      
      <br>

     ### 4. Crear **.vercelignore**: Crea este archivo en la raíz y añade:
      
      ```bash
            /vendor
      ```
      - **¿Qué hace?** Evita que subas la carpeta de dependencias a Vercel; la plataforma las instalará automáticamente durante el despliegue.
  
      <br>

     ### 5. Crear vercel.json: Crea este archivo en la raíz y añade:
   
      ```json
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
                  "APP_URL": "https://example-9pp5npl8y-antonios-projects-70787aa3.vercel.app/",

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
      ```

      - **Runtime**: Define el motor de PHP (ej. vercel-php@0.7.1) para procesar el código.

      - **Routes**: Configura que cualquier URL (/(.*)) sea procesada por el archivo que creamos en /api/index.php.

      - **Variables de Entorno (env)**: * Redirige todas las rutas de caché (APP_CONFIG_CACHE, VIEW_COMPILED_PATH, etc.) a la carpeta /tmp.

        - **¿Por qué?** Vercel tiene un sistema de archivos de "solo lectura". La carpeta /tmp es el único lugar donde Laravel tiene permiso para escribir archivos temporales.
  
      ### Una vez configurado todo esto, subelo al proyecto de github.
   

     ### 6. Configurar el directorio de salida en Vercel:

     - Creamos una carpeta **dist** en la raiz para engañar al sistema, ya que sin esa carpeta vercel no se despliega pero realmente no se usara ya que laravel no la utiliza, en su defecto usa la carpeta public que vamos a configurarla en vercel:
  
      <br>
  
      1. Desplegamos el proyecto usando este comando:

         ```vercel
               vercel .
         ```

         ? Set up and deploy “~\Herd\example-app”? **yes**
         <br>

         ? Which scope should contain your project? **vuestro proyecto**
         <br>
         
         ? Link to existing project? **no**
         <br>

         ? What’s your project’s name? **nombre de vuestro proyecto**
         <br>

         ? In which directory is your code located? **./**
         <br>

         ? Want to modify these settings? **no**
         <br>

         ? Do you want to change additional project settings? **no**
         🔗  Linked to antonios-projects-70787aa3/example-app (created .vercel)
         <br>

         ? Detected a repository. Connect it to this project? **yes**
         > Connecting GitHub repository: https://github.com/antoniorb1913/example-app
         > Connected

      <br>

      2. Configurar la carpeta **public**:

         1. Entramos nuestro proyecto en vercel.

            ![ilustracion 2](Image/vercel/proyecto.png)
         
         <br>

         2. Entramos a "settings".
  
            ![ilustracion 2](Image/vercel/settings.png)

         <br>
         
         3. En los ajustes:

            1. Entramos a "Build and Deployment".
            2. Dentro de "Framework Settings" En el apartado "Framework Preset" seleccionamos "Other".
            3. Activamos el apartado "Output Directory" y ponemos "public".
            4. Guardamos "save".
  
               ![ilustracion 2](Image/vercel/public.png)
   
               ¿Por qué?: Laravel usa la carpeta public para proteger el código fuente y servir el archivo index.php de forma segura.

         <br>

         - **Con esto ya estaria hecho el despligue**, si intentamos entrar a la web de despligue no saldra nada solo errores, ya que no nos hemos conectado a una base de datos.


     ### 7. Conexion con la base de datos:

      En este caso me conectare a una base de datos postgres previamente configurada en render, pero bueno para la conexion es igual en todas.

      1. Entramos en ajustes:

         1. Entramos a "Environment Variables".
         2. Damos en "Add Environment Variable".
         3. Añadimos las variables para conectarnos con la base de datos.

      ![ilustracion 3](Image/vercel/variables.png)

      - Variables.

         **APP_KEY**: Esta se saca del archivo ".env" del proyecto

         **DB_CONNECTION**: pgsql (que base de datos es (Postres, MySQL, ...etc))

         **DB_HOST**: host / dominio

         **DB_PORT**: 5432

         **DB_DATABASE**: Nombre de la base de datos

         **DB_USERNAME**: El usuario

         **DB_PASSWORD**: La contraseña

         <br>
      
      **Pequeño inciso** esto se puede poner tambien en el archivo "**.env**" o el el archivo "**vercel.json**" la cosa que configurar las variables en el panel de Vercel evita filtrar contraseñas en el historial de Git y permite mantener las credenciales locales del .env totalmente separadas de las de producción.

 ### Error Read-only file system 
   
   Error debido a que la arquitectura de Vercel impide escribir en la carpeta storage del proyecto.

   - **Solución**: Se implementó **$app->useStoragePath('/tmp')**; para utilizar el directorio temporal /tmp, único espacio con permisos de escritura permitidos en entornos Serverless.
   - Poner esto al final de archivo **bootstrap / app.php**

  <br>

   ```php
   // Comprueba en el archivo vercel.json si esta en producción.
      if (env('APP_ENV') === 'production') {
         $app->useStoragePath('/tmp');
      }
      return $app;
   ```

   <br>

   Visualizacion del despligue.

   https://example-lo3dryhuk-antonios-projects-70787aa3.vercel.app

   ![ilustracion 4](Image/vercel/despliegue.png)

## CONFIGURACIÓN DE BASE DE DATOS Y AUTO-INSTALACIÓN

   1. **Base de Datos**: Se ha creado una instancia de PostgreSQL en Render.
   2. **Comenta** esta linea de routes/web.php.

      ```php
         Route::get('/', function () {
            return redirect()->route('players.index');
         });
      ```
   3. **Descomentar** esto de routes/web.php.

      ```php
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
      ```
      - Este código comprueba si la base de datos está vacía; si lo está, crea las tablas y mete los datos de prueba automáticamente, y si ya está todo listo, te manda directo a la lista de jugadores.

   <br>
   
   4. Poner las Variable de entorno que genera servicio postgres de render en vercel (apartado 7 de este documento).

   
<hr>

### Documentación realizada por:

- #### antoniorb1913