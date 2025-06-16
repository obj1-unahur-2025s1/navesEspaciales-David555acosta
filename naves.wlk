class Nave {
    var property velocidad
    var property direccion

    method acelerar(cantidad) {
        velocidad = (velocidad + cantidad).min(100000)
    }

    method desacelerar(cantidad) {
      velocidad = (velocidad - cantidad).max(0)
    }

    method irHaciaElSol() {
        velocidad = (velocidad + 1).min(10)
    }

    method escaparDelSol() {
        velocidad = (velocidad - 1).max(-10)
    }

    method ponerseParaleloAlSol() {}
}