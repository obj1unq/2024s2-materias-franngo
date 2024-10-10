import aprobacion.*
import carrera.*
import gestorAprobacion.*
import materia.*

class Estudiante {
    const property carrerasCursando = #{} //set de instancias de Carrera
    const property materiasAprobadas = #{} //set de instancias de Aprobacion
    var cantMateriasAprobadas = 0
    const property materiasCursando = #{} //set de instancias de Materia

    method registrarMateriaAprobada(materia, nota) {
        gestorAprobacion.registrarMateriaAprobada(self, materia, nota)
    }

    method validarNoEstaAprobada(materia) {
        if(self.tieneAprobada(materia)) {
            self.error("No se puede registrar porque el estudiante ya aprobó la materia")
        }
    }

    method tieneAprobada(materia) {
        return materiasAprobadas.any({instanciaAprobacion => instanciaAprobacion.materia()==materia})
    }

    method sumarCantMateriasAprobadas() {
        cantMateriasAprobadas += 1
    }

    method cantMateriasAprobadas() {
        return cantMateriasAprobadas
    }

    method promedio() {
        const sumaNotas = materiasAprobadas.sum({instanciaAprobacion => instanciaAprobacion.nota()})
        return sumaNotas / cantMateriasAprobadas
    }

    method todasLasMateriasDeSusCarreras() {
        const materias = #{}
        carrerasCursando.forEach({carrera => materias.addAll(carrera.materias())})
        return materias
    }

    method puedeInscribirseA(materia) {

    }

}