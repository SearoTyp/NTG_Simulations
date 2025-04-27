[Mesh]
  file = '../Chamberless_NTG.msh'
  dim = 3
[]

[Variables]
  [T]
    family = LAGRANGE
    order = FIRST
    initial_condition = 300.0  # Initial temperature in K
  []
[]

[Kernels]
  [heat_diffusion]
    type = MatDiffusion
    variable = T
    diffusivity = thermal_conductivity
  []
  [heat_time]
    type = TimeDerivative
    variable = T
  []
  [heat_source]
    type = BodyForce
    variable = T
    block = 'Helium_Pipe'
    value = 1e7  # Reduced heat source to 1000 W/m³ (scaled by ρcₚ)
  []
[]

[Materials]
  [helium]
    type = GenericConstantMaterial
    block = 'Helium_Pipe'
    prop_names = 'thermal_conductivity'
    prop_values = '0.15'  # k = 0.15 W/m·K for helium
  []
  [teg]
    type = GenericConstantMaterial
    block = 'TEG1_Ceramic TEG2_Ceramic'
    prop_names = 'thermal_conductivity'
    prop_values = '1.5'  # k = 1.5 W/m·K for TEG ceramics
  []
[]

[BCs]
  [temperature_cold]
    type = DirichletBC
    variable = T
    boundary = 'teg1_cold_surface'
    value = 300  # Cold side of TEG1 at 300 K
    []
[]

[Postprocessors]
	[max_temp]
	type = ElementExtremeValue
	variable = T
	value_type = max
	[]
[]

[Executioner]
  type = Transient
  dt = 0.01
  end_time = 20  # Increased simulation time to 1000 s for more diffusion
  [TimeStepper]
    type = ConstantDT
    dt = 0.01
  []
[]

[Outputs]
  exodus = true
[]
