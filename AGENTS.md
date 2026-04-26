# AGENTS.md

## Project goal
Create a **3D printable planter shell**.

## Functional requirements
- The planter must be a **shell** design intended to be printed in **PETG**.
- The hollow interior of the shell is intended to be filled with **polyurethane foam** after printing.
- The **minimum internal clear size** must be **50 cm × 50 cm × 50 cm**.

## Manufacturing / print constraints
- The model must be designed so it can be printed on smaller printers.
- Therefore, the planter must be **split into multiple printable pieces/modules**.
- Piece segmentation should prioritize:
  - reliable bed fit on smaller printers,
  - strong joining geometry,
  - straightforward post-processing and assembly.

## Preferred deliverables
When generating design outputs, provide:
1. A master parametric model.
2. Split part files ready for printing.
3. Assembly guidance (join method, orientation, and foam fill notes).

## Notes for assistants
- Treat the internal 50×50×50 cm requirement as a hard minimum.
- Favor practical printability and assembly robustness over visual complexity.
- Default material assumption: PETG shell + polyurethane foam core/fill.
