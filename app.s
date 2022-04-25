.equ SCREEN_WIDTH, 		640
.equ SCREEN_HEIGH, 		480
.equ BITS_PER_PIXEL,  	32

// Implementamos las funciones necesarias en un nuevo archivo "funciones.s".
.include "funciones.s"

.globl main
main:
	mov x20, x0
	mov x0, x20

// Escena HORA:
			
		// Dibujamos Fondo: 
		mov w10, 0
		mov x1, SCREEN_WIDTH
		mov x2, SCREEN_HEIGH
		mov x3, 0
		mov x4, 0
		BL funcion_dibujar_cuadrado
		
		// Dibujamos Hora:
			movz w10, 0xff, lsl 16
			movk w10, 0xffff, lsl 00
			// Numero 0:
				mov x3, 113
				mov x4, 178
				BL funcion_numero_0_hora
			// Numero 8:
				mov x3, 214
				mov x4, 178
				BL funcion_numero_8_hora
			// Dos Puntos
				BL funcion_dos_puntos_hora
			// Numero 5:
				mov x3, 359
				mov x4, 178
				BL funcion_numero_5_hora
			// Numero 9:
				mov x3, 440
				mov x4, 178
				BL funcion_numero_9_hora

			// Hacemos titilar los dos puntos de la hora:
			movz x8, 0x7FF, lsl 16 		// x8 -> Tiempo de delay
			movk x8, 0xFFF, lsl 00
			mov x5, 3					// x3 -> Cantidad de veces que titilan los dos puntos:
			loop_tiempo:
				BL funcion_delay
				mov w10, 0
				Bl funcion_dos_puntos_hora
				BL funcion_delay
				movz w10, 0xff, lsl 16
				movk w10, 0xffff, lsl 00
				BL funcion_dos_puntos_hora
				sub x5, x5, 1
			cbnz x5, loop_tiempo	
		
			// Repintamos Fondo (Ahora el reloj cambia de 8:59 a 9:00):
			mov w10, 0
			mov x1, SCREEN_WIDTH
			mov x2, SCREEN_HEIGH
			mov x3, 0
			mov x4, 0
			BL funcion_dibujar_cuadrado		

			// Dibujamos Hora: (Color Rojo)
			movz w10, 0xff, lsl 16 
				// Numero 0:
					mov x3, 113
					mov x4, 178
					BL funcion_numero_0_hora
				// Numero 9:
					mov x3, 214
					mov x4, 178
					BL funcion_numero_9_hora
				// Dos Puntos
					BL funcion_dos_puntos_hora
				// Numero 0:
					mov x3, 359
					mov x4, 178
					BL funcion_numero_0_hora
				// Numero 0:
					mov x3, 455
					mov x4, 178
					BL funcion_numero_0_hora

				mov x5, 3 // Numero de veces que titilan los dos puntos.
				loop_tiempo1:
					BL funcion_delay
					mov w10, 0
					Bl funcion_dos_puntos_hora
					BL funcion_delay
					movz w10, 0xff, lsl 16
					BL funcion_dos_puntos_hora
					sub x5, x5, 1
				cbnz x5, loop_tiempo1

				movz x8, 0xFFF, lsl 16	// Damos un tiempo de delay para cambiar de escena.
				movk x8, 0xFFFF, lsl 00
				BL funcion_delay

// Escena Principal:
	// Dibujamos Fondo: 
		movz w10, 0x67, lsl 16
		movk w10, 0xACD8, lsl 00
		mov x1, SCREEN_WIDTH
		mov x2, SCREEN_HEIGH
		mov x3, 0
		mov x4, 0
		BL funcion_dibujar_cuadrado
		
	// Dibujamos Mesa:
		movz w10, 0x80, lsl 16
		movk w10, 0x4000, lsl 00
		mov x2, 240
		BL funcion_mesa_diagonal
		
	// Dibujar Mouse:
		// Contorno-Mouse
			mov w10, 0
			mov x1, 61
			mov x2, 102
			mov x3, 525
			mov x4, 358
			BL funcion_dibujar_cuadrado
		// Click-Izquierdo
			movz w10, 0xa0, lsl 16
			movk w10, 0x9c9c, lsl 00
			mov x1, 23
			mov x2, 42
			mov x3, 527
			mov x4, 361
			BL funcion_dibujar_cuadrado
		// CLick-Derecho
			mov x1, 32
			mov x2, 42
			mov x3, 552
			mov x4, 361
			BL funcion_dibujar_cuadrado
		// Parte-inferior-Mouse
			mov x1, 57
			mov x2, 51
			mov x3, 527
			mov x4, 406
			BL funcion_dibujar_cuadrado
			
	// Dibujar Monitor:
		mov w10, 0
		// Dibujamos Pantalla-Monitor
			mov x1, 502
			mov x2, 319
			mov x3, 19
			mov x4, 15
			BL funcion_dibujar_cuadrado
		// Dibujamos Soporte-Monitor
			mov x1, 56
			mov x2, 57
			mov x3, 245
			mov x4, 333
			BL funcion_dibujar_cuadrado
		// Dibujamos Base-Monitor
			mov x1, 230
			mov x2, 14
			mov x3, 157
			mov x4, 390
			BL funcion_dibujar_cuadrado
		// Dibujamos LED
			// Led apagado
				movz w10, 0xB3, lsl 16
				movk w10, 0x0F0F, lsl 00
				mov x1, 29
				mov x2, 4
				mov x3, 478
				mov x4, 325
				BL funcion_dibujar_cuadrado
			// Cambiamos el color de led (De apagado pasa a estar encendido)
				movz x8, 0xFFF, lsl 16
				movk x8, 0x000, lsl 00
				BL funcion_delay
			// Led encendido
				movz w10, 0x66ff, lsl 00
				mov x1, 29
				mov x2, 4
				mov x3, 478
				mov x4, 325
				BL funcion_dibujar_cuadrado
		
		// Delay para que encienda la pantalla
			movz x8, 0xFFF, lsl 16
			movk x8, 0x000, lsl 00
			BL funcion_delay

	// Pintamos Pantalla de carga de Windows:
		// Fondo negro de windows.
			movz w10, 0x18, lsl 16
			movk w10, 0x1818, lsl 00
			mov x1, 471
			mov x2, 290
			mov x3, 36
			mov x4, 30
			BL funcion_dibujar_cuadrado
		// Logo windows
			// Cuadrado celeste
				movz w10, 0x34, lsl 16
				movk w10, 0x98DB, lsl 00
				mov x1, 30
				mov x2, 35
				mov x3, 256
				mov x4, 100
				BL funcion_dibujar_cuadrado
			// Linea horizontal
				movz w10, 0x18, lsl 16
				movk w10, 0x1818, lsl 00
				mov x1, 30
				mov x2, 2
				mov x3, 256
				mov x4, 116
				BL funcion_dibujar_cuadrado
			// Linea vertical
				mov x1, 2
				mov x2, 35
				mov x3, 270
				mov x4, 100
				BL funcion_dibujar_cuadrado
		// Barra carga
			// Bordes
				movz w10, 0x39, lsl 16
				movk w10, 0x3939, lsl 00
				mov x1, 150
				mov x2, 15
				mov x3, 196
				mov x4, 180
				BL funcion_dibujar_cuadrado
			// Delay para que la barra empiece a cargar:
				movz x8, 0x555, lsl 16
				BL funcion_delay

			// Cargamos la barra de inicio de windows:
				movz w10, 0x34, lsl 16
				movk w10, 0x98DB, lsl 00
				mov x1, 1
				mov x2, 10
				mov x3, 198
				mov x4, 182
				mov x26, 145
				funcion_carga:
					BL funcion_dibujar_cuadrado
					movz x8, 0x90, lsl 16			// x8 -> tiempo de delay que tarda la barra de carga
					movk x8, 0x1111, lsl 00
					BL funcion_delay
					add x1, x1, 1
					sub x26, x26, 1
				cbnz x26, funcion_carga

		// Delay para que se muestre el inicio de windows:
			movz x8, 0xFFFF, lsl 00
			BL funcion_delay

		// Windows Escritorio
			// Fondo
				movz w10, 0x2C, lsl 16
				movk w10, 0x8ECF, lsl 00
				mov x1, 471
				mov x2, 290
				mov x3, 36
				mov x4, 30
				BL funcion_dibujar_cuadrado
			// Menu doc
				// Barra
					movz w10, 0x1B, lsl 16
					movk w10, 0x1B1B, lsl 00
					mov x1, 471
					mov x2, 20
					mov x3, 36
					mov x4, 300
					BL funcion_dibujar_cuadrado
				// Icono windows
					// Cuadrado blanco
						movz w10, 0xFF, lsl 16
						movk w10, 0xFFFF, lsl 00
						mov x1, 14
						mov x2, 14
						mov x3, 40
						mov x4, 303
						BL funcion_dibujar_cuadrado
					// Barra vertical
						movz w10, 0x1B, lsl 16
						movk w10, 0x1B1B, lsl 00
						mov x1, 2
						mov x2, 14
						mov x3, 46
						mov x4, 303
						BL funcion_dibujar_cuadrado
					// Barra horizontal
						mov x1, 14
						mov x2, 2
						mov x3, 40
						mov x4, 309
						BL funcion_dibujar_cuadrado
					// Icono google chrome
						mov x3, 70
						mov x4, 303
						BL funcion_google_chrome
					// Icono Carpeta
							// Pixeles Iniciales
							mov x3, 40
							mov x4, 35
							mov x5, 4 	// X5 -> Cantidad de carpetas. 
							dibujo_carpeta: 
								BL funcion_dibujar_carpeta
								sub x5, x5, 1
								add x4, x4, 20 // La siguiente carpeta se dibuja 20 pixeles abajo.
							cbnz x5, dibujo_carpeta
					// Icono de Google Chorme en el escritorio
					Bl funcion_google_chrome

		// Dibujamos puntero del mouse:
			mov w10, 0
			mov x3, 400
			mov x4, 145
			Bl funcion_dibujar_puntero
		// Le damos un delayt para que el mouse no se mueva instantaneamente
			movz x8, 0xFFF, lsl 16
			movk x8, 0xFFFF, lsl 00
			BL funcion_delay

		// Movimiento de Mouse y puntero:
			movz x8, 0x3F, lsl 16 		// x8 -> Tiempo de delay
			movk x8, 0xFFFF, lsl 00

			mov x26, 525				// Pixel X inicial del mouse
			mov x27, 400				// Pixel Y inicial del mouse

			mov x25, 174				// x25 -> Cantida de pixeles que se mueven los elementos
			loop_mov_mouse_izq:
				// Mover Mouse:
				BL funcion_delay
				mov x1, 61
				mov x2, 102
				mov x3, x26
				mov x4, 358

				cmp x3, 390				// Comparamenos x3 (pixel x del elemento) con 390 (pixel x donde termina el soporte del monitor).
				B.LS no_mov				// Si x3 es menor que 390, no lo muevo mas.
				BL funcion_mover_elem_izq
				no_mov:

				// Mover puntero:
				mov x1, 15
				mov x2, 20
				mov x3, x27
				mov x4, 133
				BL funcion_mover_elem_izq
				sub x27, x27, 1
				BL funcion_mover_elem_izq

				sub x26, x26, 1
				sub x27, x27, 1
				sub x25, x25, 1
			cbnz x25, loop_mov_mouse_izq

			// Click Mouse:
				movz x8, 0x5FF, lsl 16
				movk x8, 0xFFFF, lsl 00
				mov x1, 23
				mov x2, 42
				mov x3, 392
				mov x4, 361

				mov x25, 2
				loop_click_izq:			// Cantidad de veces que se clickea el mouse
					BL funcion_delay
					movz w10, 0x70, lsl 16
					movk w10, 0x6c6c, lsl 00
					BL funcion_dibujar_cuadrado

					BL funcion_delay
					movz w10, 0xa0, lsl 16
					movk w10, 0x9c9c, lsl 00
					BL funcion_dibujar_cuadrado		// El mouse vuelve al color original
					sub x25, x25, 1
				cbnz x25, loop_click_izq

				// Delay para luego mostrar el google chrome abierto:
				movz x8, 0xFFF, lsl 16
				movk x8, 0xFF50, lsl 00
				BL funcion_delay
 
		// Google meet pantalla inicio
			// Fondo
				movz w10, 0xFF, lsl 16
				movk w10, 0xFFFF, lsl 00
				mov x1, 471
				mov x2, 270
				mov x3, 36
				mov x4, 30
				BL funcion_dibujar_cuadrado

			// Doc
				// Fondo
					movz w10, 0xE4, lsl 16
					movk w10, 0xE4E4, lsl 00
					mov x1, 471
					mov x2, 25
					mov x3, 36
					mov x4, 30
					BL funcion_dibujar_cuadrado
				// Barra busqueda
					// Fondo
						movz w10, 0xFF, lsl 16
						movk w10, 0xFFFF, lsl 00
						mov x1, 300
						mov x2, 15
						mov x3, 121
						mov x4, 35
						BL funcion_dibujar_cuadrado
					// Texto
						mov w10, 0
						mov x5, 15
						mov x3, 125
						mov x4, 42
						BL funcion_dibujar_texto
				// Boton cerrar.
					movz w10, 0xCF, lsl 16
					movk w10, 0x2315, lsl 00
					mov x1, 8
					mov x2, 8
					mov x3, 498
					mov x4, 32
					BL funcion_dibujar_cuadrado
				// Boton maximizar.
					movz w10, 0xBB, lsl 16
					movk w10, 0xBBBB, lsl 00
					mov x1, 8
					mov x2, 8
					mov x3, 485
					mov x4, 32
					BL funcion_dibujar_cuadrado
				// Boton minimizar.
					movz w10, 0xBB, lsl 16
					movk w10, 0xBBBB, lsl 00
					mov x1, 8
					mov x2, 3
					mov x3, 472
					mov x4, 36
					BL funcion_dibujar_cuadrado
			// Camara.
				// Fondo.
					movz w10, 0x1B, lsl 16
					movk w10, 0x1B1B, lsl 00
					mov x1, 180
					mov x2, 120
					mov x3, 80
					mov x4, 120
					BL funcion_dibujar_cuadrado
				// Boton microfono.
					movz w10, 0xBB, lsl 16
					movk w10, 0xBBBB, lsl 00
					mov x1, 3
					mov x2, 10
					mov x3, 160
					mov x4, 220
					BL funcion_dibujar_cuadrado
				// Boton camara.
					movz w10, 0xff, lsl 16
					mov x1, 10
					mov x2, 10
					mov x3, 180
					mov x4, 220
					BL funcion_dibujar_cuadrado
				// Texto principal inicio - meet:
					mov w10, 0
					mov x5, 12
					mov x3, 305
					mov x4, 140
					BL funcion_dibujar_texto
					mov x5, 8
					mov x3, 317
					mov x4, 160
					BL funcion_dibujar_texto
			// Boton verde.
				movz w10, 0x30, lsl 16
				movk w10, 0x9651, lsl 00
				mov x1, 40
				mov x2, 18
				mov x3, 300
				mov x4, 180
				BL funcion_dibujar_cuadrado

				movz w10, 0xff, lsl 16
				movk w10, 0xffff, lsl 00
				mov x5, 3
				mov x3, 310
				mov x4, 188
				BL funcion_dibujar_texto
			// Boton gris.
				movz w10, 0xBB, lsl 16
				movk w10, 0xBBBB, lsl 00
				mov x1, 40
				mov x2, 18
				mov x3, 350
				mov x4, 180
				BL funcion_dibujar_cuadrado

				movz w10, 0x30, lsl 16
				movk w10, 0x9951, lsl 00
				mov x5, 3
				mov x3, 360
				mov x4, 188
				BL funcion_dibujar_texto	
		
		// Volvemos a dibujar al puntero del mouse en la pantalla del meet:
			mov w10, 0 
			mov x3, 270
			mov x4, 230
			Bl funcion_dibujar_puntero
			
			// Delay	
			movz x8, 0xFF, lsl 16
			movk x8, 0xFFFF, lsl 00
			BL funcion_delay

			movz x8, 0x3F, lsl 16
			movk x8, 0xFFFF, lsl 00
			mov x26, 390			// Pixel X inicial del mouse.
			mov x27, 270			// Pixel X inicial del puntero.
			mov x25, 25
			loop_mov_mouse_der:
				BL funcion_delay
				// Mover Mouse:
				mov x1, 61
				mov x2, 102
				mov x3, x26
				mov x4, 358
				BL funcion_mover_elem_derecha

				//Mover puntero:
				mov x1, 15
				mov x2, 16
				mov x3, x27
				mov x4, 218

				BL funcion_mover_elem_derecha
				add x27, x27, 1
				BL funcion_mover_elem_derecha

				add x26, x26, 1
				add x27, x27, 1
				sub x25, x25, 1
			cbnz x25, loop_mov_mouse_der

		
		// Añadimos puntero que sube y click en boton verde
				mov x26, 357
				mov x27, 217
				movz x8, 0xFF, lsl 16
				movk x8, 0xaa, lsl 00
				mov x25, 10
				desplazar_arriba:
					BL funcion_delay
					// Movemos mouse:
					mov x1, 61
					mov x2, 102
					mov x3, 415
					mov x4, x26

					cmp x26, 335 
					B.LS hacer_nada
					BL funcion_mover_elem_arr				
					hacer_nada:

					// Movemos puntero:
					mov x1, 15
					mov x2, 16
					mov x3, 320
					mov x4, x27
					BL funcion_mover_elem_arr
					sub x27, x27, 1
					BL funcion_mover_elem_arr

					sub x26, x26, 1
					sub x27, x27, 1
					sub x25, x25, 1
				cbnz x25, desplazar_arriba

			// Click Mouse:
				movz x8, 0x5FF, lsl 16
				movk x8, 0xFFFF, lsl 00
				mov x1, 23
				mov x2, 42
				mov x3, 417
				mov x4, 351
				mov x25, 2

				loop_click_izq1:			// Cantidad de veces que se clickea el mouse
					BL funcion_delay
					movz w10, 0x70, lsl 16
					movk w10, 0x6c6c, lsl 00
					BL funcion_dibujar_cuadrado

					BL funcion_delay
					movz w10, 0xa0, lsl 16
					movk w10, 0x9c9c, lsl 00
					BL funcion_dibujar_cuadrado		// El mouse vuelve al color original
					sub x25, x25, 1
				cbnz x25, loop_click_izq1

		// Delay para cuando se abra el google meet:
			movz x8, 0xFFF, lsl 16
			movk x8, 0xFFFF, lsl 00
			BL funcion_delay

		// Google meet llamada
			// Fondo
				movz w10, 0x7d, lsl 16
				movk w10, 0xcea0, lsl 0
				mov x1, 471
				mov x2, 245
				mov x3, 36
				mov x4, 55
				BL funcion_dibujar_cuadrado
			// Banderin
				// Color celeste
					movz w10, 0x67, lsl 16
					movk w10, 0xACD8, lsl 00
					mov x1, 50
					mov x2, 2
					mov x3, 400
					mov x4, 100
					BL funcion_dibujar_triangulo
				// Color blanco
					movz w10, 0xFF, lsl 16
					movk w10, 0xFFFF, lsl 0
					mov x1, 30
					mov x2, 2
					mov x3, 410
					mov x4, 120
					BL funcion_dibujar_triangulo
			// Mueble
				// Fondo
					movz w10, 0x5F, lsl 16
					movk w10, 0x3410, lsl 0
					mov x1, 80
					mov x2, 150
					mov x3, 36
					mov x4, 130
					BL funcion_dibujar_cuadrado
				// Borde superior
					movz w10, 0x7C, lsl 16
					movk w10, 0x3F0D, lsl 0
					mov x1, 81
					mov x2, 8
					mov x3, 36
					mov x4, 130
					BL funcion_dibujar_cuadrado
				// Borde derecho
					movz w10, 0x7C, lsl 16
					movk w10, 0x3F0D, lsl 0
					mov x1, 8
					mov x2, 150
					mov x3, 109
					mov x4, 130
					BL funcion_dibujar_cuadrado
				// Estante superior
					// Color
						movz w10, 0x7C, lsl 16
						movk w10, 0x3F0D, lsl 0
						mov x1, 80
						mov x2, 5
						mov x3, 36
						mov x4, 180
						BL funcion_dibujar_cuadrado
					// Sombra
						movz w10, 0x4E, lsl 16
						movk w10, 0x2707, lsl 0
						mov x1, 72
						mov x2, 2
						mov x3, 36
						mov x4, 186
						BL funcion_dibujar_cuadrado
				// Estante inferior
					// Color
						movz w10, 0x7C, lsl 16
						movk w10, 0x3F0D, lsl 0
						mov x1, 80
						mov x2, 5
						mov x3, 36
						mov x4, 230
						BL funcion_dibujar_cuadrado
					// Sombra
						movz w10, 0x4E, lsl 16
						movk w10, 0x2707, lsl 0
						mov x1, 72
						mov x2, 2
						mov x3, 36
						mov x4, 236
						BL funcion_dibujar_cuadrado
				// Libros
					// Libro 1
						movz w10, 0xBB, lsl 16
						movk w10, 0x1515, lsl 0
						mov x1, 8
						mov x2, 30
						mov x3, 101
						mov x4, 150
						BL funcion_dibujar_cuadrado
					// Libro 2
						movz w10, 0x1D, lsl 16
						movk w10, 0x55E0, lsl 0
						mov x1, 8
						mov x2, 35
						mov x3, 91
						mov x4, 145
						BL funcion_dibujar_cuadrado
					// Libro 3
						movz w10, 0x1D, lsl 16
						movk w10, 0x55E0, lsl 0
						mov x1, 8
						mov x2, 25
						mov x3, 101
						mov x4, 205
						BL funcion_dibujar_cuadrado
					// Libro 4
						movz w10, 0x3E, lsl 16
						movk w10, 0x9E0E, lsl 0
						mov x1, 5
						mov x2, 28
						mov x3, 66
						mov x4, 202
						BL funcion_dibujar_cuadrado

			// Menu google meet
				// Menu arriba
					// Fondo
						movz w10, 0xFF, lsl 16
						movk w10, 0xFFFF, lsl 00
						mov x1, 471
						mov x2, 20
						mov x3, 36
						mov x4, 55
						BL funcion_dibujar_cuadrado
					// Texto
						mov w10, 0
						mov x5, 10
						mov x3, 45
						mov x4, 65
						BL funcion_dibujar_texto
				// Menu abajo
					// Fondo
						movz w10, 0xFF, lsl 16
						movk w10, 0xFFFF, lsl 00
						mov x1, 471
						mov x2, 25
						mov x3, 36
						mov x4, 275
						BL funcion_dibujar_cuadrado
					//Botones
						//Apagar camara (boton rojo)
							movz w10, 0xCA, lsl 16
							movk w10, 0x2626, lsl 0
							mov x1, 15
							mov x2, 15
							mov x3, 300
							mov x4, 280
							BL funcion_dibujar_cuadrado
						//Cuadrado blanco dentro de apagar camara
							movz w10, 0xFF, lsl 16
							movk w10, 0xFFFF, lsl 0
							mov x1, 5
							mov x2, 5
							mov x3, 305
							mov x4, 285
							BL funcion_dibujar_cuadrado
						//Boton salir llamada
							movz w10, 0xCA, lsl 16
							movk w10, 0x2626, lsl 0
							mov x1, 10
							mov x2, 3
							mov x3, 270
							mov x4, 287
							BL funcion_dibujar_cuadrado
						//Boton microfono
							movz w10, 0xA2, lsl 16
							movk w10, 0xA2A2, lsl 0
							mov x1, 3
							mov x2, 10
							mov x3, 248
							mov x4, 283
							BL funcion_dibujar_cuadrado
							
			// Personaje
				// Cabeza
					movz w10, 0xFC, lsl 16
					movk w10, 0xD5BE, lsl 0
					mov x1, 105
					mov x2, 75
					mov x3, 222
					mov x4, 120
					BL funcion_dibujar_cuadrado
				// Pelo
					// Pelo principal
						movz w10, 0x4F, lsl 16
						movk w10, 0x360A, lsl 0
						mov x1, 105
						mov x2, 12
						mov x3, 222
						mov x4, 110
						BL funcion_dibujar_cuadrado
					// Pelos parados
						mov x1, 10
						mov x2, 12
						mov x3, 250
						mov x4, 108
						BL funcion_dibujar_cuadrado
						mov x1, 5
						mov x3, 252
						mov x4, 105
						BL funcion_dibujar_cuadrado
						mov x2, 10
						mov x3, 300
						mov x4, 108
						BL funcion_dibujar_cuadrado
				// Ojos
					mov w10, 0
					// Ojo izquierdo
						mov x1, 22
						mov x2, 8
						mov x3, 235
						mov x4, 140
						BL funcion_dibujar_cuadrado
					// Ojo derecha
						mov x3, 290
						BL funcion_dibujar_cuadrado
				// Boca personaje
					movz w10, 0xE5, lsl 16
					movk w10, 0xBE7A, lsl 0
					mov x1, 40
					mov x2, 3
					mov x3, 255
					mov x4, 170
					BL funcion_dibujar_cuadrado
				// Remera de boca (El mas grande papa)
					// Remera Azul
						movz w10, 0x10, lsl 16
						movk w10, 0x3f79, lsl 00
						mov x1, 60
						mov x2, 80
						mov x3, 243
						mov x4, 195
						BL funcion_dibujar_cuadrado
					// Remera Amarilla 
						movz w10, 0xf3, lsl 16
						movk w10, 0xb229, lsl 0
						mov x1, 60
						mov x2, 28
						mov x3, 243
						mov x4, 223
						BL funcion_dibujar_cuadrado

		// Delay para que se empiecen a agrandar los ojos:
			movz x8, 0xFFF, lsl 16
			movk x8, 0xffff, lsl 00
			BL funcion_delay

		// Agrandar ojos
			mov x14, 7
			mov x15, 9
			mov w10, 0
			delay_agrandar_ojos:
				movz x8, 0x0F5, lsl 16
				BL funcion_delay
				pintar_ojos:
					// Ojo izquierdo
						mov x1, 22
						mov x2, x15
						mov x3, 235
						mov x4, 140
						BL funcion_dibujar_cuadrado
					// Ojo derecho
						mov x1, 22
						mov x2, x15
						mov x3, 290
						BL funcion_dibujar_cuadrado
					sub x14, x14, 1
					add x15, x15, 1
				cbnz x14, delay_agrandar_ojos

		 	mov w10, 0
			mov x3, 380
			mov x4, 303
			Bl funcion_dibujar_puntero

			movz x8, 0x3F, lsl 16
			movk x8, 0xFFFF, lsl 00
			mov x26, 415			// Pixel X inicial del mouse.
			mov x27, 380			// Pixel X inicial del puntero.
			mov x25, 33
			loop_mov_mouse_izq1:
				BL funcion_delay
				// Mover Mouse:
				mov x1, 61
				mov x2, 102
				mov x3, x26
				mov x4, 348
				
				cmp x3, 390					// Comparamenos x3 (pixel x del elemento) con 390 (pixel x donde termina el soporte del monitor).
				B.LS no_mov1				// Si x3 es menor que 390, no lo muevo mas.
				BL funcion_mover_elem_izq
				no_mov1:

				//Mover puntero:
				mov x1, 15
				mov x2, 17
				mov x3, x27
				mov x4, 290
				BL funcion_mover_elem_izq
				sub x27, x27, 1
				BL funcion_mover_elem_izq

				sub x26, x26, 1
				sub x27, x27, 1
				sub x25, x25, 1
			cbnz x25, loop_mov_mouse_izq1

			// Click Mouse:
			movz x8, 0x5FF, lsl 16
			movk x8, 0xFFFF, lsl 00
			mov x1, 23
			mov x2, 42
			mov x3, 392
			mov x4, 351

			mov x25, 2
			loop_click_izq2:			// Cantidad de veces que se clickea el mouse
				BL funcion_delay
				movz w10, 0x70, lsl 16
				movk w10, 0x6c6c, lsl 00
				BL funcion_dibujar_cuadrado

				BL funcion_delay
				movz w10, 0xa0, lsl 16
				movk w10, 0x9c9c, lsl 00
				BL funcion_dibujar_cuadrado		// El mouse vuelve al color original
				sub x25, x25, 1
			cbnz x25, loop_click_izq2

			// Delay para luego apagar camara:
				movz x8, 0xFFF, lsl 16
				movk x8, 0xFF50, lsl 00
				BL funcion_delay

			// Dibujamos fondo camara apagada
				movz w10, 0x59, lsl 16
				movk w10, 0x5656, lsl 0
				mov x1, 471
				mov x2, 200
				mov x3, 36
				mov x4, 75
				BL funcion_dibujar_cuadrado

	InfLoop: 
		b InfLoop
		