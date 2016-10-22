# MFP
This is a D-language-based program (source code, executable, and input files) that models multiphase fluid flow (water, gas, NAPL) in one-, two-, or three-dimensional porous media. Capillary forces are only partially modeled (the liquid phases is modeled as a fluid with a composite average capillary curve, based on relative fluid saturations). Capillary forces in water-NAPL only systems are not considered at all.
The simulator solves flux equations for each phase using small time steps, adjusting relatively permeability and storage factors as functions or pressure or saturation. The pressure equation is solved implicitly using a tri-diagonal for 1-D problems and successive over-relaxation for 2-D and 3-D problems. The program is an experimental work-in-progress and may converge slowly or not at all, depending on problem definition. It seems to work best when a gas phase is present; NAPL-water-only problems involving density and viscosity contrasts seem to run very slowly.

The following tab-delimited input files are required:

* cells.txt - properties of individual cells/volume elements within the model
* controls.txt - basic operating controls for the model (time step, convergence, etc.)
* grid.txt - spatial scale and discretization
* liquids.txt - physical properties of liquids
* source_napl.txt and source-water.txt - liquid fluxes, referenced to specific cells

More background information can be found here: https://numericalenvironmental.wordpress.com/2016/07/11/multiphase-flow/

An example application is presented here: https://numericalenvironmental.wordpress.com/2016/10/03/napl-migration-through-a-correlated-random-field/

Email me with questions at walt.mcnab@gmail.com. 

