# TPIndividualObjetos

## Justificaciones a Elecciones teóricas

**Uso De clases** : En varios lugares del código, se utilizan clases por sobre objetos puntuales para que puedan ser mas de una instancia (*véase Asistente o Banda*)

**Herencia** : En el caso de la herencia, se utilizó sobre los tipos de bandas, ya que comparten un comportamiento en común, pero difieren en como calculan los valores. Esto da paso a que se pueda usar *Polimorfismo*, sobre dichos métodos, para tratar a todas las bandas de la misma manera.
```wollok
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
```
**Composición** : Caso contrario, tenemos a los abonos, que no pueden ser vistos como una clase, y pueden ser usados como dos objetos distintos (en este caso Vip es una clase), que tienen un comportamiento similar. Cabe recalcar que esto se debe a que  no es *responsabilidad* del Asistente realizar las acciones que corresponden a es par

```wollok
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
```

**Seters y Geters** : Estos se utilizan para que la variable sea publica, y todos puedan acceder a modificarla. Se usa principalmente a la hora de crear las listas dentro de la clase Asistente, para poder hacer uso de funciones como *Map* y *Filter*

```wollok
class Entrada {
    const property banda
    const property fecha = new Date()

    method precioAlPublico() = 1000 + impuestos.valor
}
```
Luego en Asistente :

```wollok
method entradasHaceUnAnio() =
        entradas.filter({ entrada =>
            diaDeLaFecha.fueElAnioPasado(entrada.fecha())
        })

    method nombreBandas() =
        entradas.map({ entrada => entrada.banda() }).asSet()
```

**Override** : Va de la mano con Herencia, se utiliza para modificar un método de la clase Padre (O super clase), pero que siga manteniendo el mismo nombre. Esto se hace para que todas los objetos de la sub clase tengan el comportamiento distinto, mientras que los de la clase padre tengan el método normal 
```wollok
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
```
## Decisiones a comentar 
 - Se decidió que el impuesto sea un objeto por fuera de la clase entrada, ya que se, según la consigna, se pide que sea posible cambiarlo en cualquier momento, y que debe ser el mismo para todas las entradas, en cuyo caso es mas pertinente colocarlo como un        objeto diferente.
 - Se decidió por el uso de Sets en vez de listas con las bandas y los Asistentes para que no haya repetidos.
