import aprobacion.*
import carrera.*
import estudiante.*
import gestores.*

class Materia {
    const property carrera = null
    const property prerrequisitos = #{}

    method validarPrerrequisitos() {

    }

    method existeCoincidenciaCarreraEstudiante(estudiante) {
        return estudiante.carrerasCursando().any({carreraEst => carreraEst==carrera})
    }

}