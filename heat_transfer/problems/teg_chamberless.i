[Mesh]
    file = '/home/bse/projects/moose/modules/heat_transfer/chamberless_NTGV2.msh'
    dim = 3
[]

[Variables]
    [T]
      family = LAGRANGE
      order = FIRST
      initial_condition = 300.0
    []
[]

[Kernels]
    [heat_conduction]
      type = HeatConduction
      variable = T
      diffusion_coefficient = 'k'
    []
    [heat_time]
      type = HeatConductionTimeDerivative
      variable = T
      density_name = 'density'
    []
    [helium_heat_source]
      type = BodyForce
      variable = T
      block = 'Helium_Pipe'
      function = 'helium_heat_source'
    []
[]

[Functions]
    [helium_heat_source]
      type = ParsedFunction
      expression = 'if(t < 20, 7e5 * t / 10, 7e5)'  # Increased to reach ~1600 K
    []
    [hot_plate_temp]
      type = ParsedFunction
      expression = '100 * t'  # Ramps from 300 K to 1500 K over 20s (60 K/s)
    []
[]

[Materials]
    [helium]
      type = GenericConstantMaterial
      block = 'Helium_Pipe'
      prop_names = 'k density specific_heat'
      prop_values = '10 1.7 5200'
    []
    [teg]
      type = GenericConstantMaterial
      block = 'TEG1_Ceramic TEG2_Ceramic'
      prop_names = 'k density specific_heat'
      prop_values = '45 7700 200' 
    []
[]

[BCs]
    [teg1_cold]
      type = DirichletBC
      variable = T
      boundary = 'teg1_cold_surface'
      value = 300
    []
    [teg2_cold]
      type = DirichletBC
      variable = T
      boundary = 'teg2_cold_surface'
      value = 300
    []
    [teg1_hot]
      type = FunctionDirichletBC
      variable = T
      boundary = 'teg1_hot_surface'
      function = 'hot_plate_temp'
    []
    [teg2_hot]
      type = FunctionDirichletBC
      variable = T
      boundary = 'teg2_hot_surface'
      function = 'hot_plate_temp'
    []
[]

[VectorPostprocessors]
    [temp_sampler]
      type = LineValueSampler
      variable = T
      start_point = '0.03 0.05 0'    # Middle of bottom (TEG2 cold side)
      end_point = '0.03 0.05 0.06'   # Middle of top (TEG1 cold side)
      num_points = '20'
      sort_by = z
    []
[]

[Postprocessors]
    [max_temp]
      type = ElementExtremeValue
      variable = T
      value_type = max
      execute_on = 'timestep_end'
    []
    [avg_helium_temp]
      type = ElementAverageValue
      variable = T
      block = 'Helium_Pipe'
      execute_on = 'timestep_end'
    []
    [avg_teg1_hot]
      type = SideAverageValue
      variable = T
      boundary = 'teg1_hot_surface'
      execute_on = 'timestep_end'
    []
    [avg_teg2_hot]
      type = SideAverageValue
      variable = T
      boundary = 'teg2_hot_surface'
      execute_on = 'timestep_end'
    []
    [avg_teg1_cold]
      type = SideAverageValue
      variable = T
      boundary = 'teg1_cold_surface'
      execute_on = 'timestep_end'
    []
    [avg_teg2_cold]
      type = SideAverageValue
      variable = T
      boundary = 'teg2_cold_surface'
      execute_on = 'timestep_end'
    []
    [power_output]
      type = ParsedPostprocessor
      expression = '2*(2e-4)^2 * ((avg_teg1_hot - avg_teg1_cold) + (avg_teg2_hot - avg_teg2_cold))^2 / (4 * (3.33e-3 + 1.11e-3))'
      pp_names = 'avg_teg1_hot avg_teg1_cold avg_teg2_hot avg_teg2_cold'
      execute_on = 'timestep_end'
    []
[]

[Executioner]
    type = Transient
    dt = .01
    end_time = 15
    [TimeStepper]
      type = ConstantDT
      dt = .01
    []
    petsc_options_iname = '-pc_type -pc_hypre_type'
    petsc_options_value = 'hypre boomeramg'
[]

[Outputs]
    exodus = true
    csv = true
    print_linear_residuals = false
[]