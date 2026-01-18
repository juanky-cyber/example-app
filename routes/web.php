<?php

use App\Http\Controllers\PlayerController;
use Illuminate\Support\Facades\Route;
use Illuminate\Support\Facades\Artisan;
use Illuminate\Support\Facades\Schema;
use Illuminate\Support\Facades\DB;


Route::get('/', function () {
    return redirect()->route('players.index');
});
Route::resource('players', PlayerController::class);

/*
Route::get('/', function () {
    // Si no están los jugadores, lanzamos la limpieza y carga
    if (!Schema::hasTable('players')) {
        try {
            Artisan::call('migrate:fresh', [
                '--force' => true,
                '--seed' => true 
            ]);

            return "¡configurado correctamente! <a href='".route('players.index')."'>Ver jugadores</a>";
        } catch (\Exception $e) {
            return "Error en la instalación: " . $e->getMessage();
        }
    }
    return redirect()->route('players.index');
});
*/