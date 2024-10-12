import aprobacion.*
import estudiante.*
import gestores.*
import materia.*

class Carrera{
    var property materias = #{}

    method materiasDeAnho(anho) {
        return materias.filter({materia => materia.anhoMateria()==anho})
    }

}