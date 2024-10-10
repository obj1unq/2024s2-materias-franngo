class Estudiante {
    const property carrerasCursando = #{}
    const property materiasAprobadas = #{} //set de instancias de Aprobacion
    var cantMateriasAprobadas = 0

    method registrarMateriaAprobada(materia, nota) {
        materia.registrarMateriaAprobada(self, nota)
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

    method tieneAprobada(materia) {
        return materiasAprobadas.any({instanciaAprobacion => instanciaAprobacion.materia()==materia})
    }

    method todasLasMateriasDeSusCarreras() {
        const materias = #{}
        carrerasCursando.forEach({carrera => materias.addAll(carrera.materias())})
        return materias
    }

}

class Materia {
    const property carrera = null

    method registrarMateriaAprobada(estudiante, nota) {
        //self.validarPrerrequisitos() 
        gestorAprobacion.registrarMateriaAprobada(estudiante, self, nota)
    }

}

object gestorAprobacion {

    method registrarMateriaAprobada(estudiante, materia, nota) {
        self.validarNoEstaAprobada(estudiante, materia)
        self.validarNotaAprobatoria(nota)
        const materiaAprobada = new Aprobacion (estudiante = estudiante, materia = materia, nota = nota)
        estudiante.materiasAprobadas().add(materiaAprobada)
        estudiante.sumarCantMateriasAprobadas()
    }

    method validarNoEstaAprobada(estudiante, materia) {
        if(estudiante.tieneAprobada(materia)) {
            self.error("No se puede registrar porque el estudiante ya aprobó la materia")
        }
    }

    method validarNotaAprobatoria(nota) {
        if(nota<4 || nota>10) {
            self.error("No se puede registrar porque la nota no es una nota aprobatoria")
        }
    }

}

class Aprobacion {
    const property estudiante = null
    const property materia = null
    const property nota = null
}

class Carrera{
    var property materias = #{}
}