class Nave {
    var velocidad
    var direccion
    var combustible

    method acelerar(cantidad) {
        if (cantidad < 0) {
            self.error("El numero debe ser positivo")
        } else {
            velocidad = (velocidad + cantidad).min(100000)
        }
    }

    method desacelerar(cantidad) {
        if (cantidad < 0) {
            self.error("El numero debe ser positivo")
        } else {
          velocidad = (velocidad - cantidad).max(0)
        }
    }

    method irHaciaElSol() {direccion = 10}

    method escaparDelSol() {direccion = -10}

    method ponerseParaleloAlSol() {velocidad = 0}

    method acercarseUnPocoAlSol() {velocidad = (velocidad + 1).min(10)}

    method alejarseUnPocoDelSol() {velocidad = (velocidad - 1).max(-10)}

    method prepararViaje() {
        self.cargarCombustible(30000)
        self.acelerar(5000)
    }

    method cargarCombustible(cantidad) {combustible += cantidad}
    method descargarCombustible(cantidad) {combustible = (combustible - cantidad).max(0)}

    method estaTranquila() = combustible >= 400 and velocidad <= 1200

    method escapar()
    method avisar()
    method recibirAmenaza() {
        self.escapar()
        self.avisar()
    }

    method estaRelajo() = self.estaTranquila() 
}


class NaveBaliza inherits Nave {
    var property colorBaliza
    var cambioDeColor = false
    const validos = #{"rojo" , "verde" , "azul"}

    method cambiarColorDeBaliza(colorNuevo) {
      if (!validos.contains(colorNuevo)) {
         throw new Exception(message = "color invalido")
      } else {
        colorBaliza = colorNuevo
        cambioDeColor = true
      }
    }

    override method prepararViaje() {
        super()
        colorBaliza = "Verde"
        self.ponerseParaleloAlSol()
    }

    override method estaTranquila() = super() and colorBaliza != "rojo"

    override method escapar() {self.irHaciaElSol()}
    override method avisar() {colorBaliza = "rojo"}

    override method estaRelajo() = super() and !cambioDeColor
}


class NavePasajeros inherits Nave {
    var property cantPasajeros
    var racionesBebida = 0
    var racionesComida = 0
    var racionesServidas = 0

    method cargarComida(cantidad) {racionesComida += cantidad}
    method descargarCOmida(cantidad) {racionesComida = (racionesComida - cantidad).max(0)}
    method cargarBebidas(cantidad) {racionesBebida += cantidad}
    method descargarBebidas(cantidad) {
        racionesBebida = (racionesBebida - cantidad).max(0)
        racionesServidas += cantidad
        }

    override method prepararViaje() {
      super()
      self.cargarComida(4 * cantPasajeros)
      self.cargarBebidas(6 * cantPasajeros)
      self.acercarseUnPocoAlSol()
    }

    override method escapar() {velocidad *= 2}
    override method avisar() {
        self.descargarCOmida(1 * cantPasajeros)
        self.descargarBebidas(2 * cantPasajeros)
    }

    override method estaRelajo() = super() and racionesServidas < 50
}

class NaveHospital inherits NavePasajeros {
    var property tienePreparadosQuirofanos
    method prepararQuirofano() {tienePreparadosQuirofanos = true} 
    override method estaTranquila() = super() and not tienePreparadosQuirofanos
    override method recibirAmenaza() {
        super()
        self.prepararQuirofano()
    }
}

class NaveDeCombate inherits Nave {
    var estaVisible = false
    var misilesDesplegados = false
    const mensajes = []

    method ponerseVisible() {estaVisible = true}
    method ponerseInvisible() {estaVisible = false}
    method estaInvisible() = estaVisible
    method desplegarMisiles() {misilesDesplegados = true}
    method replegarMisiles() {misilesDesplegados = false} 
    method misilesDesplegados() = misilesDesplegados

    method emitirMensaje(mensaje){mensajes.add(mensaje)}
    method mensajesEmitidos() = mensajes
    method primerMensajeEmitido() = mensajes.first()
    method ultimoMensaje() = mensajes.last()
    method esCueta() = mensajes.any({m => m.length() > 30})

    override method prepararViaje() {
      super()
      self.ponerseInvisible()
      self.replegarMisiles()
      self.acelerar(5000)
      self.acelerar(15000)
      self.emitirMensaje("Saliendo en mision")
    }
    
    override method estaTranquila() = super() and not misilesDesplegados
    override method escapar() {
        self.acercarseUnPocoAlSol()
        self.acercarseUnPocoAlSol()
    }

    override method avisar() {self.emitirMensaje("Amenaza recibida")} 
}

class NaveCombateSigilosa inherits NaveDeCombate {
    override method estaTranquila() = super() and estaVisible

    override method recibirAmenaza() {
        super()
        self.desplegarMisiles()
        self.ponerseInvisible()
    }
}