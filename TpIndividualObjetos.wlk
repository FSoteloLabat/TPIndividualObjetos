
object impuestos {
    var property valor = 210
}

class Entrada {
    const property banda
    const property fecha = new Date()

    method precioAlPublico() = 1000 + impuestos.valor
}

object fan {
    method precioAPagar(entrada) = entrada.precioAlPublico()
    method bonificar() {}
}

class Vip {
    var descuento

    method precioAPagar(entrada) =
        entrada.precioAlPublico() * (1 - descuento)

    method bonificar() {
        descuento += 1
    }
}

class Asistente {
    const property entradas = []
    var saldo
    const abono

    method puedeComprarEntrada() = saldo > 0

    method comprarEntrada(entrada) {
        try {
            if (self.puedeComprarEntrada()) {
                entradas.add(entrada)
                saldo = saldo - abono.precioAPagar(entrada)
            } else {
                throw new NoPuedeComprar(
                    message = "No tiene saldo positivo para realizar la compra"
                )
            }
        } catch errorSaldo : NoPuedeComprar {
            console.println(errorSaldo.message())
        }
    }

    method entradasHaceUnAnio() =
        entradas.filter({ entrada =>
            diaDeLaFecha.fueElAnioPasado(entrada.fecha())
        })

    method nombreBandas() =
        entradas.map({ entrada => entrada.banda() }).asSet()

    method subirAbono() {
        abono.bonificar()
    }
}

object diaDeLaFecha {
    const hoy = new Date()

    method fueElAnioPasado(fecha) =
        fecha.year() == hoy.year() - 1
}

class Banda {
    const property nombre

    method popularidad()

    method precioFinal() = self.canon() + self.precioExtra()

    method canon() = 1000000

    method precioExtra() = 0
}

class Rock inherits Banda {
    var solosDeGuitarra

    override method popularidad() = 100 * solosDeGuitarra

    override method precioExtra() = 10000
}

class Trap inherits Banda {
    var tieneHielo

    override method popularidad() {
        if (tieneHielo) {
            return 1000
        } else {
            return 0
        }
    }

    override method canon() =
        super() * self.popularidad()
}

class Indie inherits Banda {
    var cantidadDeInstrumentos

    override method popularidad() = 3.14 * self.nombre().size()

    override method precioExtra() = 500 * cantidadDeInstrumentos
}

object productora {
    const property asistentes = #{}
    const property bandas = #{}

    method entradasXAsistente() =
        asistentes.map({ asistente => asistente.entradas() })

    method calcularActivos() =
        self.entradasXAsistente()
            .flatten()
            .map({ entrada => entrada.precioAlPublico() })
            .sum()

    method calcularPasivos() =
        bandas.map({ banda => banda.precioFinal() }).sum()

    method ganancias() =
        self.calcularActivos() - self.calcularPasivos()

    method entradasTotales() =
        self.entradasXAsistente().flatten().size()

    method cantidadEntradasXBanda(nombre) =
        self.entradasXAsistente()
            .flatten()
            .filter({ entrada =>
                entrada.banda().nombre() == nombre
            })
            .size()

    method bandaConMasEntradas() =
        bandas.max({ banda =>
            self.cantidadEntradasXBanda(banda.nombre())
        })

    method subirAbonos() {
        asistentes.forEach({ asistente =>
            asistente.subirAbono()
        })
    }
}

class NoPuedeComprar inherits Exception {}
