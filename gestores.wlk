import aprobacion.*
import carrera.*
import estudiante.*
import materia.*

object gestorAprobacion {

    //Aclaración = Se implementa el sistema bajo la idea de que, para que se pueda registrar la aprobación de una materia, la misma debe
    //estar siendo cursada por dicho estudiante, por lo que se valida que este se encuentre cursando la misma. De no ser así, no se
    //registra dicha aprobación
    //(que la esté cursando implica que existeCoincidenciaCarreraEstudiante() y tieneAprobadosRequisitos() se cumplen, por lo que no
    //se vuelve a validar eso)
    method registrarMateriaAprobada(estudiante, materia, nota) {
        estudiante.validarEstaEfectivamenteInscrito(materia)
        estudiante.validarNoEstaAprobada(materia) //esto ya se chequea al inscribirse, así que es medio redundante
        self.validarNotaAprobatoria(nota)
        const materiaAprobada = new Aprobacion (estudiante = estudiante, materia = materia, nota = nota)
        estudiante.materiasAprobadas().add(materiaAprobada)
        materia.liberarCupoDe(estudiante)
    }

    method validarNotaAprobatoria(nota) {
        if(nota<4 || nota>10) {
            self.error("No se puede registrar la nota porque la nota no es una nota aprobatoria")
        }
    }

}

object gestorInscripcion {

    method puedeInscribirseA(estudiante, materia) {
        return materia.existeCoincidenciaCarreraEstudiante(estudiante) && !estudiante.tieneAprobada(materia) &&
               !estudiante.estaCursandoOEnEspera(materia) && materia.cumplePrerrequisitosEstudiante(estudiante)
    }

    method inscribirEstudianteEn(estudiante, materia) {
        self.validarPuedeInscribirseA(estudiante, materia)
        materia.inscribirEstudiante(estudiante)
    }

    method validarPuedeInscribirseA(estudiante, materia) {
        if(!self.puedeInscribirseA(estudiante, materia)) {
            self.error("No se puede realizar la inscripción porque el estudiante no está habilitado a inscribirse a esa materia")
        }
    }

    method darDeBajaEstudianteEn(estudiante, materia) {
        estudiante.validarEstaEfectivamenteInscrito(materia)
        materia.liberarCupoDe(estudiante)
    }

}

/*
    ## Bonus
### Formas de manejar la lista de espera
Por otro lado, diferentes materias pueden tener diferentes _estrategias para manejar su lista de espera_, a saber:
- Por orden de llegada: si te querés inscribir y no hay lugar vas a la lista de espera por llegar último
- Elitista: entran los que tengan mejor promedio.
- Por grado de avance: Inscribimos al estudiante con más materias aprobadas en la carrera.

*/

