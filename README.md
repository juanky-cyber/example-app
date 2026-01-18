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
- Connecting GitHub repository: https://github.com/juanky-cyber/example-app
-Connected

Configurar la carpeta public:

Entramos nuestro proyecto en vercel.


![build and deployment](/imagenes/image2.png)


7. Conexion con la base de datos:
Voy a usar la base de datos de render que ya teniamos de forma correcta

Entramos en ajustes:
Entramos a settings y rellenamos las variables de entorno con las de render

![captura variables](/imagenes/image.png)

Visualizacion del despligue.

![despliegue](/imagenes/despliegue.png)

