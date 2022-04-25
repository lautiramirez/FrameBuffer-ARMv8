.equ SCREEN_WIDTH, 		640
.equ SCREEN_HEIGH, 		480	

/* ACA VAN LA IMPLEMENTACIÓN DE LAS FUNCIONES: */

	funcion_calcular_pixel:
		// 	Parametros:
		// 	x3 -> Pixel X.
		// 	x4 -> Pixel Y.
		// 	Return x0 -> Posición (x,y) en la imgen.

		mov x0, 640							// x0 = 640.
		mul x0, x0, x4						// x0 = 640 * y.		
		add x0, x0, x3						// x0 = (640 * y) + x.
		lsl x0, x0, 2						// x0 = ((640 * y) + x) * 4.
		add x0, x0, x20						// x0 = ((640 * y) + x) * 4 + A[0].
	ret										// Seguimos con la siguiente instrucción. -> BR x30

	funcion_dibujar_cuadrado:
		// 	Parametros:
		// 	w10 -> Color.
		//	x1 -> Ancho.
		//	x2 -> Alto.
		// 	x3 -> Pixel X.
		// 	x4 -> Pixel Y.

		SUB SP, SP, 8 						// Apuntamos en el stack.
		STUR X30, [SP, 0]					// Salvamos en el stack el registro de retorno (x30).
		BL funcion_calcular_pixel 			// Calculamos el pixel a dibujar con la función "calcular_pixel". Retorna x0.
		LDR X30, [SP, 0]					// Le asignamos x30 su posición de retorno desde el stack. (Anteriormente fue pisada al llamar calcular_pixel). 			
		ADD SP, SP, 8						// Dejamos el stack como antes.
		// Usamos los registros temporales: x9, x11, x12, x13
		mov x9, x2							// x9 = x2 --> A x9 le guardamos el alto de la imagen.
		mov x13, x0							// x13 = x0 --> A x13 le guardamos la posición de x0 calculada.	
		pintar_cuadrado:
			mov x11, x1						// x11 = x1 --> A x11 le asignamos el ancho de la fila.
			mov x12, x13					// x12 = x13 --> A x12 le guardamos x13 (En esta parte de la ejecucción a x12 se le guarda el pixel inicial de la fila).
			color_cuadrado:
				stur w10, [x13]				// Memory[x13] = w10 --> A x13 le asignamos en memoria el color que respresenta w10.
				add x13, x13, 4				// w13 = w13 + 4 --> x13 se mueve un pixel hacia la derecha.
				sub x11, x11, 1				// w11 = w11 - 1 --> x11 le restamos un pixel de ancho.
				cbnz x11, color_cuadrado	// Si x11 no es 0 (la fila no se termino de pintar), seguimos pintandola.
				mov x13, x12				// En esta parte, ya se termino de pintar la fila. x13 = x12. Volvemos al pixel de origen de la fila.
				add x13, x13, 2560			// x13 = x13 + 2560. La constante 2560 es el total de pixeles de una fila, entoces si lo sumamos es como dar un salto de linea.
				sub x9, x9, 1				// x9 = x9 - 1 --> Le restamos 1 al alto de la fila.
				cbnz x9, pintar_cuadrado	// Si el alto no es 0, es porque aún no se termino de pintar.
	ret


	funcion_dibujar_triangulo:
		// 	Parametros:
		// 	w10 -> Color.
		//	x1 -> Ancho.
		//  x2 -> Cantidad de filas a pintar antes de disminuir en 1 su valor (Altura = x1 * x2).
		// 	x3 -> Pixel X.
		// 	x4 -> Pixel Y.

		SUB SP, SP, 8 						// Apuntamos en el stack.
		STUR X30, [SP, 0]					// Salvamos en el stack el registro de retorno (x30).
		BL funcion_calcular_pixel 			// Calculamos el pixel a dibujar con la función "calcular_pixel". Retorna x0.
		LDR X30, [SP, 0]					// Le asignamos x30 su posición de retorno desde el stack. (Anteriormente fue pisada al llamar calcular_pixel). 			
		ADD SP, SP, 8						// Dejamos el stack como antes.
		
		// Usamos los registros temporales: x9, x11, x12, x13
		mov x13, x0							// x13 = x0 --> A x13 le guardamos la posición de x0 calculada.
		mov x14, x1							// x14 = x1 --> A x14 le asignamos el ancho de la fila.
		
		pintar_triangulo:
			mov x15, x2							// x15 = x2  --> A x15 le asignamos la cantidad de filas a pintar antes de disminuir el ancho de la fila actual.
			pintar_fila:
				mov x11, x14					// x11 = x14 --> A x11 le asignamos el ancho de la fila.
				mov x12, x13					// x12 = x13 --> A x12 le guardamos x13 (En esta parte de la ejecucción a x12 se le guarda el pixel inicial de la fila).
				
				color_triangulo:
					stur w10, [x13]				// Memory[x13] = w10 --> A x13 le asignamos en memoria el color que respresenta w10.
					add x13, x13, 4				// w13 = w13 + 4 --> x13 se mueve un pixel hacia la derecha.
					sub x11, x11, 1				// w11 = w11 - 1 --> x11 le restamos un pixel de ancho.
					cbnz x11, color_triangulo	// Si x11 <= 0 (la fila no se termino de pintar), seguimos pintandola.
					
				mov x13, x12					// En esta parte, ya se termino de pintar la fila. x13 = x12. Volvemos al pixel de origen de la fila.
				add x13, x13, 2560				// Pasamos a la siguiente fila.
				sub x15, x15, 1					// x15 = x15 - 1. Le restamos 1 a x15 para pintar al siguiente fila del mismo ancho que la anterior.
				cbnz x15, pintar_fila
				
				mov x13, x12				// En esta parte, ya se termino de pintar la fila. x13 = x12. Volvemos al pixel de origen de la fila.
				add x13, x13, 2564			// x13 = x13 + 2562. La constante 2560 es el total de pixeles de una fila, el numero 4 que se suma a 2560 sirve para movernos 
											//	1 pixel (4 posiciones) hacia la derecha. entonces si lo sumamos es como dar un salto de linea movido 1 pixeles a la derecha.
				sub x14, x14, 2				// x14 = x14 - 2. A x14 le restamos 2 para disminuir el ancho de la siguiente fila en 1 pixel.
				cbnz x14, pintar_triangulo
	ret


	funcion_dibujar_texto:
		// 	Parametros:
		// 	w10 -> Color.
		//	x5 -> Ancho.
		// 	x3 -> Pixel X.
		// 	x4 -> Pixel Y.

        // Salvamos x30 en el stack.
		SUB SP, SP, 8 						
		STUR X30, [SP, 0]	
        
        // Asignamos valores constantes.	
		mov x1, 5   // Ancho de la "letra".
		mov x2, 2   // Alto de la "letra".
        
		mov x14, x5 // Inicializamos x14, con el ancho del texto.
		texto:
			BL funcion_dibujar_cuadrado
			sub x14, x14, 1 // x14 = x14 - 1
			add x3, x3, x1  // x3 = x3 + x1 -> Sumamos el ancho de la letra a x3, asi x3 se posiciona al final de esa letra.
            add x3, x3, 2   // x3 = x3 + 2 -> Sumamos dos pixeles de ancho mas para generar espacio entre letras.
			cbnz x14, texto
        // Cargamos en x30 el valor salvado en el stack.
		LDR X30, [SP, 0]					 			
		ADD SP, SP, 8	
	ret


	funcion_delay:
		// 	Parametros:
		// 	x8 -> Duración DELAY.

		mov x9, x8  // Inicializo x9 con x8.
		delay:
			sub x9, x9, 1
			cbnz x9, delay
	ret


	funcion_mesa_diagonal:	
        // 	Parametros:
		// 	w10 -> Color.
        //  x2 -> Alto del escritorio.

        // Me ubico en el ultimo pixel de la imagen.
		movz x0, 0x12, lsl 16
		movk x0, 0xBFFC, lsl 00
		add x0, x0, x20
        mov x13, x2
		
        mov x9, 0  // x9 lleva la cuentas de cuantos pixeles hay que restar para armar la diagonal.					
		color_linea:
			mov x11, SCREEN_WIDTH           // x11 = 640 -> x11 Lleva la cuenta de pixeles recorridos por linea.	
			sub x11, x11, x9 		        // x11 = x11 - x9 -> Le resto x9 pixeles para armar la diagonal.	
			mov x12, x0                     // x12 = x0 -> x12 guarda el pixel de orignen de la linea. 
			pintar_linea:
				stur w10, [x0]              // Pintamos x0 del color que representa w10.
				sub x0, x0, 4               // Restamos un pixel a x0, para movernos al pixel de la izquierda.
				sub x11, x11, 1             // Restamos 1 al x11.
				cbnz x11, pintar_linea      // Si x11 no es 0, es que todavia no terminamos de pintar esa linea de la diagonal.
			sub x13, x13, 1 	            // Le restamos 1 a x13 que es el contador de altura.		
			add x9, x9, 1 				    // Le sumamos 1 a x9, asi en cada linea se le resta un 1 pixel de ancho a la mesa.
			mov x0, x12 				    // x0 vuelve a la posición de origen de la linea.
			sub x0, x0, 2560 			    // A x0 le restamos la constante 2560 para ubicarnos una linea mas arriba.
			cbnz x13, color_linea 	
	ret	

	funcion_dibujar_carpeta:
		// 	Parametros:
		// 	x3 -> Pixel X.
        //  x4 -> Pixel Y
		
		SUB SP, SP, 8 						// Guardamos x30 en el stack.	
		STUR X30, [SP, 0]	
		
		// Le damos color a w10.
		movz w10, 0xF1, lsl 16
		movk w10, 0xD33C, lsl 00

		// Asiganmos Ancho y Alto
		mov x1, 10
		mov x2, 10
		BL funcion_dibujar_cuadrado
		// Asignamos Ancho y Alto del segundo cuadrado.
		mov x1, 14
		add x4, x4, 2
		BL funcion_dibujar_cuadrado

		LDR X30, [SP, 0]					 			
		LDR W10, [SP, 8]
		ADD SP, SP, 16
	ret

	funcion_dos_puntos_hora:
		//Parametros:
		//w10: Color.
		SUB SP, SP, 16
		STUR w10, [SP, 8]
		STUR X30, [SP, 0]
		// Dos Puntos, le pasamos los parametros para dibujar los 2 puntos.
		mov x1, 22
		mov x2, 22
		mov x3, 311
		mov x4, 216
		BL funcion_dibujar_cuadrado
		mov x4, 262
		BL funcion_dibujar_cuadrado
		LDR X30, [SP, 0]
		LDR W10, [SP, 8]
		ADD SP, SP, 16
	ret

	funcion_numero_0_hora:
		SUB SP, SP, 16 				
		STUR w10, [SP, 8]
		STUR X30, [SP, 0]
			mov x1, 89
			mov x2, 126
			BL funcion_dibujar_cuadrado
			mov w10, 0
			mov x1, 50
			mov x2, 87
			add x3, x3, 19
			add x4, x4, 22
			BL funcion_dibujar_cuadrado
		LDR X30, [SP, 0]					 			
		LDR W10, [SP, 8]
		ADD SP, SP, 16
	ret

	funcion_numero_8_hora:
		SUB SP, SP, 16 				
		STUR w10, [SP, 8]
		STUR X30, [SP, 0]
			mov x1, 69
			mov x2, 126
			BL funcion_dibujar_cuadrado
				// Dentro de 8
					mov w10, 0
						mov x1, 30
						mov x2, 40
						add x3, x3, 18
						add x4, x4, 22
						BL funcion_dibujar_cuadrado
						mov x2, 30
						add x4, x4, 56
						BL funcion_dibujar_cuadrado
		LDR X30, [SP, 0]					 			
		LDR W10, [SP, 8]
		ADD SP, SP, 16
	ret

	funcion_numero_5_hora:
		SUB SP, SP, 16 				
		STUR w10, [SP, 8]
		STUR X30, [SP, 0]
			mov x1, 61	
			mov x2, 126
			BL funcion_dibujar_cuadrado
				// Dentro de 5
					mov w10, 0
						mov x1, 41
						mov x2, 39
						add x3, x3, 20
						add x4, x4, 21
						BL funcion_dibujar_cuadrado
						mov x2, 36
						sub x3, x3, 20
						add x4, x4, 53
						BL funcion_dibujar_cuadrado	
		LDR X30, [SP, 0]					 			
		LDR W10, [SP, 8]
		ADD SP, SP, 16
	ret

	funcion_numero_9_hora:
		SUB SP, SP, 16 				
		STUR w10, [SP, 8]
		STUR X30, [SP, 0]
			mov x1, 64	
			mov x2, 125
			BL funcion_dibujar_cuadrado
				// Dentro de 9
					mov w10, 0
						mov x1, 41
						mov x2, 62
						add x4, x4, 64
						BL funcion_dibujar_cuadrado
						mov x1, 21
						mov x2, 22
						add x3, x3, 20
						sub x4, x4, 42
						BL funcion_dibujar_cuadrado
		LDR X30, [SP, 0]					 			
		LDR W10, [SP, 8]
		ADD SP, SP, 16
	ret
	

	funcion_mover_elem_derecha:
		// Parametros
		// x1 -> Ancho del elemento.
		// x2 -> Alto del elemento.
		// x3 -> Pixel X del elemento.
		// x4 -> Pixel Y del elemento.
		// Return x0: Equina Superior Izquierda del elemento.

		// Guardamos x30 en el stack.
			SUB SP, SP, 24 										
			STUR x30, [SP, 16]
			STUR x1, [SP, 8]
			STUR x3, [SP, 0]
		// Hacemos cuentas nesesarias.
			add x3, x3, x1 								// x3 = x3 + x1
			sub x3, x3, 1 								// x3 = x3 -1
			add x1, x1, 1 								// x1 = x1 + 1
			BL funcion_calcular_pixel
			
				mov x16, x0 						// x16 = x0 -> Inicializo x16 con x0 (Pixel Derecho Superior).
				mov x17, x2							// x17 = x2 -> x17 alto del elemento
				mover_elemento:
					mov x18, x1 					// x18 = x1 -> Contador de Ancho
					mov x19, x16 					// x3 = x0 -> Actual Pixel
					mover_pixel0:
						mov x21, x19 				// x21 = x19 -> guardo en x21 el pixel actual
						add x21, x21, 4 			// x21+4 -> Me situo en el pixel de la derecha de x3
						ldr w5, [x19] 				// w5 = [x19] -> cargo en w5 el color de x19
						str w5, [x21] 				// pinto el pixel de x21, con el color guardado en w5
						sub x18, x18, 1 			// Resto 1 al contador de ancho
						sub x19, x19, 4 			// vuelvo un pixel atras en x19
						cbnz x18, mover_pixel0 		
						sub x17, x17, 1
						add x16, x16, 2560
						cbnz x17, mover_elemento

			// Devolvemos los valores originales.
			LDR x3, [SP, 0]					 			
			LDR x1, [SP, 8]
			LDR x30, [SP, 16]
			ADD SP, SP, 24	
			lsl x22, x1, 2
			sub x22, x22, 4		
			sub x0, x0, x22	
	ret


	funcion_mover_elem_izq:
		// Parametros
		// x1 -> Ancho del elemento.
		// x2 -> Alto del elemento.
		// x3 -> Pixel X del elemento.
		// x4 -> Pixel Y del elemento.
		// Return x0: Equina Superior Izquierda del elemento.

		// Guardamos x30 en el stack.
			SUB SP, SP, 24 										
			STUR x30, [SP, 16]
			STUR x1, [SP, 8]
			STUR x3, [SP, 0]
		
		// Hacemos cuentas nesesarias.
			add x1, x1, 1 								// x1 = x1 + 1
			BL funcion_calcular_pixel
			
				mov x16, x0 						// x16 = x0 -> Inicializo x16 con x0 (Pixel Superior Izquierdo).
				mov x17, x2							// x17 = x2 -> x17 alto del elemento
				mover_elemento_izq:
					mov x18, x1 					// x18 = x1 -> Contador de Ancho
					mov x19, x16 					// x19 = x16 -> Actual Pixel
					mover_pixel_izq:
						mov x21, x19 				// x21 = x19 -> guardo en x21 el pixel actual 
						sub x21, x21, 4 			// x21-4 -> Me situo en el pixel de la izquierda de x21
						ldr w5, [x19] 				// w5 = [x19] -> cargo en w5 el color de x19
						str w5, [x21] 				// pinto el pixel de x21, con el color guardado en w5
						sub x18, x18, 1 			// Resto 1 al contador de ancho
						add x19, x19, 4 			// vuelvo un pixel atras en x19
						cbnz x18, mover_pixel_izq
						sub x17, x17, 1
						add x16, x16, 2560
						cbnz x17, mover_elemento_izq
			
		// Devolvemos los valores originales.
			LDR x3, [SP, 0]					 			
			LDR x1, [SP, 8]
			LDR x30, [SP, 16]
			ADD SP, SP, 24	
			lsl x22, x1, 2
			sub x22, x22, 4		
			sub x0, x0, x22	
		ret


	funcion_dibujar_puntero:
		// Parametros
		// w10 -> COlor
		// x3 -> Pixel X del elemento.
		// x4 -> Pixel Y del elemento.
		
			SUB SP, SP, 8 						// Apuntamos en el stack.
			STUR X30, [SP, 0]	
				
				BL funcion_calcular_pixel
				mov x14, x0

				mov x12, 13
				dibujar_puntero:
				mov x13, x14
				mov x11, x12
				color_linea_puntero:
					stur w10, [x13]				
					add x13, x13, 4				
					sub x11, x11, 1				
					cbnz x11, color_linea_puntero
					sub x14, x14, 2560
					sub x12, x12, 1
					cmp x12, xzr
					B.GT dibujar_puntero

				mov x1, 5
				mov x2, 3
				add x3, x3, 4
				add x4, x4, 1
				BL funcion_dibujar_cuadrado


			LDR X30, [SP, 0]					// Le asignamos x30 su posición de retorno desde el stack. (Anteriormente fue pisada al llamar calcular_pixel). 			
			ADD SP, SP, 8	
		ret

	funcion_google_chrome:
			SUB SP, SP, 8 						// Apuntamos en el stack.
			STUR X30, [SP, 0]
				
				// Color rojo
					movz w10, 0xB3, lsl 16
					movk w10, 0x0F0F, lsl 00
					mov x1, 14
					mov x2, 4
					BL funcion_dibujar_cuadrado
				
				// Color verde
					movz w10, 0x21, lsl 16
					movk w10, 0xBF13, lsl 00
					mov x1, 10
					mov x2, 10
					add x4, x4, 4
					BL funcion_dibujar_cuadrado
				
				// Color azul
					movz w10, 0x40, lsl 16
					movk w10, 0x84FC, lsl 00
					mov x1, 5
					mov x2, 6
					add x3, x3, 4
					BL funcion_dibujar_cuadrado
				
				// Color amarillo
					movz w10, 0xF0, lsl 16
					movk w10, 0xEC14, lsl 00
					mov x1, 4
					mov x2, 10
					add x3, x3, 6
					BL funcion_dibujar_cuadrado
			LDR X30, [SP, 0]					// Le asignamos x30 su posición de retorno desde el stack. (Anteriormente fue pisada al llamar calcular_pixel). 			
			ADD SP, SP, 8	
		ret

		funcion_mover_elem_arr:
			// Guardamos en el stack los registros que queremos salvar:
			SUB SP, SP, 24 										
			STUR x30, [SP, 16]
			STUR x1, [SP, 8]
			STUR x3, [SP, 0]
		
		// Hacemos cuentas nesesarias.
			add x2, x2, 2 								// x2 = x2 + 1
			BL funcion_calcular_pixel
			
			mov x16, x0 						// x16 = x0 -> Inicializo x16 con x0 (Pixel Superior Izquierdo).
			mov x17, x1							// x17 = x2 -> x17 ancho del elemento
			mover_elemento_arr:
				mov x18, x2 					// x18 = x1 -> Contador de Alto
				mov x19, x16 					// x19 = x16 -> Actual Pixel
				mover_pixel_arr:
					mov x21, x19 				// x21 = x19 -> guardo en x21 el pixel actual 
					sub x21, x21, 2560 			// x21-2560 -> Me situo en el pixel de arriba de x21
					ldr w5, [x19] 				// w5 = [x19] -> cargo en w5 el color de x19
					str w5, [x21] 				// pinto el pixel de x21, con el color guardado en w5
					sub x18, x18, 1 			// Resto 1 al contador de alto
					add x19, x19, 2560 			// vuelvo un pixel mas abajo en x19
				cbnz x18, mover_pixel_arr
					sub x17, x17, 1				// Le resto uno al contador de ancho
					add x16, x16, 4				// Hago que en el proxima iteracion sea en el proximo pixel horizontal
			cbnz x17, mover_elemento_arr

			// Devolvemos los valores originales.
				LDR x3, [SP, 0]					 			
				LDR x1, [SP, 8]
				LDR x30, [SP, 16]
				ADD SP, SP, 24	
				lsl x22, x1, 2
				sub x22, x22, 4		
				sub x0, x0, x22	
		ret




