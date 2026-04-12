# Estructura Base Modular Estandar
base de trabajo modular esteban daimuzv1

## 1) Objetivo

Estandarizar como se organiza un proyecto para:

- escalar sin desorden
- reducir deuda tecnica
- facilitar onboarding
- reutilizar patrones entre proyectos

## 2) Principios de arquitectura

- Separacion por dominios de negocio, no solo por tipo de archivo.
- Bajo acoplamiento entre modulos.
- Alta cohesion dentro de cada modulo.
- Contratos explicitos entre capas (tipos, DTOs, interfaces).
- Una sola responsabilidad por modulo/componente.
- Convenciones consistentes en nombres y estructura.

## 3) Estructura recomendada (monorepo)

```text
project-root/
  apps/
    web/
      src/
        app/
        features/
        shared/
      public/
      tests/
      package.json
    api/
      src/
        modules/
        common/
        infra/
      tests/
      package.json
  packages/
    ui/
    types/
    config-eslint/
    config-ts/
  infra/
    docker/
    scripts/
    ci/
  docs/
    architecture/
    decisions/
    runbooks/
  .github/
    workflows/
  package.json
  pnpm-workspace.yaml
  README.md
```

## 4) Estructura interna por modulo (backend)

```text
src/modules/<modulo>/
  application/
    use-cases/
    dto/
    mappers/
  domain/
    entities/
    value-objects/
    services/
    repositories/    # interfaces
  infrastructure/
    persistence/
    http/
    queue/
  presentation/
    controllers/
    routes/
    validators/
  index.ts
```

Reglas:

- domain no depende de infrastructure.
- application usa interfaces del dominio.
- infrastructure implementa interfaces.
- presentation solo orquesta entrada/salida.

## 5) Estructura interna por feature (frontend)

```text
src/features/<feature>/
  components/
  hooks/
  services/
  state/
  schemas/
  utils/
  types.ts
  index.ts
```

Reglas:

- Shared UI comun en src/shared/ui.
- Logica de negocio dentro de la feature, no en paginas globales.
- Evitar imports profundos entre features.
- Exportar API publica por index.ts de cada feature.

## 6) Shared y cross-cutting

```text
src/shared/
  ui/
  lib/
  constants/
  types/
  config/
  utils/
```

Usar shared solo para piezas realmente reutilizables. Si algo lo usa una sola feature, se queda en esa feature.

## 7) Convenciones de nombres

- Carpetas: kebab-case.
- Componentes React: PascalCase.
- Funciones y variables: camelCase.
- Tipos/interfaces: PascalCase.
- Archivos de pruebas: *.spec.ts o *.test.ts.

## 8) Contratos y limites

- Cada modulo/feature expone una API minima via index.ts.
- No importar archivos internos de otro modulo directamente.
- Definir DTOs de entrada/salida y validarlos.
- Versionar endpoints y eventos relevantes.

## 9) Calidad y gobernanza

Checklist minimo por proyecto:

- Lint + format + typecheck en CI.
- Tests unitarios por modulo.
- Tests de integracion para flujos criticos.
- Convencion de commits (Conventional Commits).
- Pull Request template con criterios de aceptacion.
- ADR (Architecture Decision Records) para decisiones clave.

## 10) Escalabilidad operativa

- Config por entorno (dev/stage/prod) fuera del codigo.
- Observabilidad base: logs estructurados, metricas, trazas.
- Migraciones versionadas para base de datos.
- Feature flags para despliegues seguros.
- Backups y runbooks de incidentes en docs/runbooks.

## 11) Plantilla de arranque rapido

1. Crear monorepo con apps y packages.
2. Definir 3 modulos core del negocio.
3. Implementar contratos (DTOs, interfaces, types).
4. Configurar CI con lint, typecheck y tests.
5. Crear docs iniciales: arquitectura, ADR-001 y runbook basico.
6. Publicar una feature end-to-end como referencia.

## 12) Anti-patrones a evitar

- Carpeta utils gigante sin ownership.
- Dependencias circulares entre modulos.
- Logica de negocio en controllers o componentes visuales.
- Reutilizacion prematura sin evidencia real.
- Shared convertido en "cajon de sastre".

## 13) Como replicar en nuevos proyectos

Usar este documento como standard y crear desde el dia 1:

- estructura base de carpetas
- reglas de dependencia
- convenciones de naming
- pipeline de calidad
- documentacion de decisiones
