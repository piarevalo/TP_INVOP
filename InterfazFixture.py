import tkinter as tk
from PIL import Image, ImageTk
from ArmadoFixture import fixture
from chequeos import esquema

# Funcion para pasarle un fixture por consola (Estilo SCIP)
fixture = fixture()
esquema(fixture)

# Diccionario de equipos
equipos = {
    1: 'argentina', 
    2: 'brasil', 
    3: 'uruguay', 
    4: 'colombia', 
    5: 'ecuador', 
    6: 'chile', 
    7: 'bolivia', 
    8: 'paraguay', 
    9: 'peru', 
    10: 'venezuela'
}

# Cantidad de recuadros por fila y tamaño de recuadro
recuadros_por_fila = 6
tamaño_recuadro = (100, 25)  # Ancho y alto de cada recuadro reducido
fuente = "Calibri Light"

partidos_por_equipo = {equipo: [] for equipo in equipos.keys()}
for fecha, partidos in fixture.items():
    for local, visitante in partidos:
        partidos_por_equipo[local].append((fecha, "local", visitante))
        partidos_por_equipo[visitante].append((fecha, "visitante", local))

def cargar_bandera(nombre_pais, w=30, h=18):
    imagen = Image.open(f"flags/{nombre_pais}.png")
    imagen = imagen.resize((w, h), Image.LANCZOS)
    return ImageTk.PhotoImage(imagen)

def mostrar_partidos(equipo_id):
    equipo_nombre = equipos[equipo_id].capitalize()
    partidos = partidos_por_equipo[equipo_id]

    ventana_partidos = tk.Toplevel()
    ventana_partidos.title(f"Partidos de {equipo_nombre}")

    # Crear un canvas con scrollbar para la ventana de partidos
    canvas_partidos = tk.Canvas(ventana_partidos)
    scrollbar_partidos = tk.Scrollbar(ventana_partidos, orient="vertical", command=canvas_partidos.yview)
    scrollable_frame_partidos = tk.Frame(canvas_partidos)

    scrollable_frame_partidos.bind(
        "<Configure>",
        lambda e: canvas_partidos.configure(scrollregion=canvas_partidos.bbox("all"))
    )

    canvas_partidos.create_window((0, 0), window=scrollable_frame_partidos, anchor="nw")
    canvas_partidos.configure(yscrollcommand=scrollbar_partidos.set)

    canvas_partidos.pack(side="left", fill="both", expand=True)
    scrollbar_partidos.pack(side="right", fill="y")

    for fecha, condicion, rival_id in partidos:
        # Marco para cada partido
        marco_partido = tk.Frame(scrollable_frame_partidos, padx=5, pady=2)
        marco_partido.pack(fill="x", pady=2)

        # Si es local, mostrar bandera del equipo seleccionado a la izquierda
        if condicion == "local":
            bandera_equipo = cargar_bandera(equipos[equipo_id], 25, 15)
            bandera_rival = cargar_bandera(equipos[rival_id], 25, 15)
            tk.Label(marco_partido, text=f"Fecha {fecha}", font=(fuente, 9)).pack(side="left", padx=5)
            tk.Label(marco_partido, image=bandera_equipo).pack(side="left", padx=3)
            tk.Label(marco_partido, text="vs", font=(fuente, 9, "bold")).pack(side="left", padx=3)
            tk.Label(marco_partido, image=bandera_rival).pack(side="left", padx=3)
        else:
            bandera_rival = cargar_bandera(equipos[rival_id], 25, 15)
            bandera_equipo = cargar_bandera(equipos[equipo_id], 25, 15)
            tk.Label(marco_partido, text=f"Fecha {fecha}", font=(fuente, 9)).pack(side="left", padx=5)
            tk.Label(marco_partido, image=bandera_rival).pack(side="left", padx=3)
            tk.Label(marco_partido, text="vs", font=(fuente, 9, "bold")).pack(side="left", padx=3)
            tk.Label(marco_partido, image=bandera_equipo).pack(side="left", padx=3)

        # Guardar referencias a las imágenes para evitar que se destruyan
        ventana_partidos.banderas = ventana_partidos.banderas if hasattr(ventana_partidos, 'banderas') else []
        ventana_partidos.banderas.append(bandera_equipo)
        ventana_partidos.banderas.append(bandera_rival)

# Crear ventana principal
root = tk.Tk()
root.title("Fixture de Eliminatorias CONMEBOL")

# Crear canvas con barra de desplazamiento
canvas = tk.Canvas(root)
scrollbar = tk.Scrollbar(root, orient="vertical", command=canvas.yview)
scrollable_frame = tk.Frame(canvas)

scrollable_frame.bind(
    "<Configure>",
    lambda e: canvas.configure(scrollregion=canvas.bbox("all"))
)

canvas.create_window((0, 0), window=scrollable_frame, anchor="nw")
canvas.configure(yscrollcommand=scrollbar.set)

# Posicionar canvas y scrollbar en la ventana principal
canvas.pack(side="left", fill="both", expand=True)
scrollbar.pack(side="right", fill="y")

# Crear un marco principal con borde negro
marco_principal = tk.Frame(scrollable_frame, highlightbackground="black", highlightthickness=2, padx=5, pady=5)
marco_principal.pack(padx=10, pady=10)  # Márgenes para separar el borde del resto de la ventana

fila_actual = tk.Frame(marco_principal)
fila_actual.pack(fill="x", padx=5, pady=5)  # Márgenes reducidos

banderas_referencias = {}
for i, (fecha, partidos) in enumerate(fixture.items(), 1):
    if (i - 1) % recuadros_por_fila == 0:
        fila_actual = tk.Frame(marco_principal)
        fila_actual.pack(fill="x", padx=5, pady=5)  # Márgenes reducidos

    marco_fecha = tk.LabelFrame(fila_actual, text=f"Fecha {fecha}", padx=3, pady=3, width=tamaño_recuadro[0])
    marco_fecha.pack(side="left", padx=5, pady=5)

    for local, visitante in partidos:
        marco_partido = tk.Frame(marco_fecha, width=tamaño_recuadro[0], height=tamaño_recuadro[1])
        marco_partido.pack_propagate(False)
        marco_partido.pack(pady=2)

        bandera_local = cargar_bandera(equipos[local], 25, 15)
        etiqueta_local = tk.Label(marco_partido, image=bandera_local, cursor="hand2")
        etiqueta_local.pack(side="left", padx=3)
        etiqueta_local.bind("<Button-1>", lambda e, equipo_id=local: mostrar_partidos(equipo_id))

        tk.Label(marco_partido, text="vs", font=(fuente, 10, "bold")).pack(side="left", padx=3)

        bandera_visitante = cargar_bandera(equipos[visitante], 25, 15)
        etiqueta_visitante = tk.Label(marco_partido, image=bandera_visitante, cursor="hand2")
        etiqueta_visitante.pack(side="left", padx=3)
        etiqueta_visitante.bind("<Button-1>", lambda e, equipo_id=visitante: mostrar_partidos(equipo_id))

        banderas_referencias[(local, visitante)] = (bandera_local, bandera_visitante)

root.update_idletasks()
width = min(canvas.bbox("all")[2], root.winfo_screenwidth())
root.geometry(f"{width}x600")  # Reducir altura inicial de la ventana

root.mainloop()