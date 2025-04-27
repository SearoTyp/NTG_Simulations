//* This file is part of the MOOSE framework
//* https://mooseframework.inl.gov
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html
#include "NTG_SimsTestApp.h"
#include "NTG_SimsApp.h"
#include "Moose.h"
#include "AppFactory.h"
#include "MooseSyntax.h"

InputParameters
NTG_SimsTestApp::validParams()
{
  InputParameters params = NTG_SimsApp::validParams();
  params.set<bool>("use_legacy_material_output") = false;
  params.set<bool>("use_legacy_initial_residual_evaluation_behavior") = false;
  return params;
}

NTG_SimsTestApp::NTG_SimsTestApp(InputParameters parameters) : MooseApp(parameters)
{
  NTG_SimsTestApp::registerAll(
      _factory, _action_factory, _syntax, getParam<bool>("allow_test_objects"));
}

NTG_SimsTestApp::~NTG_SimsTestApp() {}

void
NTG_SimsTestApp::registerAll(Factory & f, ActionFactory & af, Syntax & s, bool use_test_objs)
{
  NTG_SimsApp::registerAll(f, af, s);
  if (use_test_objs)
  {
    Registry::registerObjectsTo(f, {"NTG_SimsTestApp"});
    Registry::registerActionsTo(af, {"NTG_SimsTestApp"});
  }
}

void
NTG_SimsTestApp::registerApps()
{
  registerApp(NTG_SimsApp);
  registerApp(NTG_SimsTestApp);
}

/***************************************************************************************************
 *********************** Dynamic Library Entry Points - DO NOT MODIFY ******************************
 **************************************************************************************************/
// External entry point for dynamic application loading
extern "C" void
NTG_SimsTestApp__registerAll(Factory & f, ActionFactory & af, Syntax & s)
{
  NTG_SimsTestApp::registerAll(f, af, s);
}
extern "C" void
NTG_SimsTestApp__registerApps()
{
  NTG_SimsTestApp::registerApps();
}
