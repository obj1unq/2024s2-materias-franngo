import aprobacion.*
import carrera.*
import estudiante.*
import gestores.*

class Materia {
    const property carrera = null
    const property prerrequisitos = #{}
    const property maximoEstudiantes = 3
    const property alumnosCursando = []
    const property listaDeEspera = [] //queue

    method existeCoincidenciaCarreraEstudiante(estudiante) {
        return estudiante.carrerasCursando().any({carreraEst => carreraEst==carrera})
    }

    method inscribirEstudiante(estudiante) {
        if(alumnosCursando.size() < maximoEstudiantes) {
            alumnosCursando.add(estudiante)
        } else {
            listaDeEspera.add(estudiante)
        }
    }

    method liberarCupoDe(estudiante) {
        alumnosCursando.remove(estudiante)
        if(alumnosCursando.size()==maximoEstudiantes-1 && listaDeEspera.size()>0) {
            alumnosCursando.add(listaDeEspera.head()) //inscribe efectivamente al que llevaba más tiempo esperando
            listaDeEspera.remove(listaDeEspera.head()) //lo borra de la lista de espera
        }
    }

}