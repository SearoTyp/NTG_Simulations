#include "NTG_SimsApp.h"
#include "Moose.h"
#include "AppFactory.h"
#include "ModulesApp.h"
#include "MooseSyntax.h"

InputParameters
NTG_SimsApp::validParams()
{
  InputParameters params = MooseApp::validParams();
  params.set<bool>("use_legacy_material_output") = false;
  params.set<bool>("use_legacy_initial_residual_evaluation_behavior") = false;
  return params;
}

NTG_SimsApp::NTG_SimsApp(InputParameters parameters) : MooseApp(parameters)
{
  NTG_SimsApp::registerAll(_factory, _action_factory, _syntax);
}

NTG_SimsApp::~NTG_SimsApp() {}

void
NTG_SimsApp::registerAll(Factory & f, ActionFactory & af, Syntax & syntax)
{
  ModulesApp::registerAllObjects<NTG_SimsApp>(f, af, syntax);
  Registry::registerObjectsTo(f, {"NTG_SimsApp"});
  Registry::registerActionsTo(af, {"NTG_SimsApp"});

  /* register custom execute flags, action syntax, etc. here */
}

void
NTG_SimsApp::registerApps()
{
  registerApp(NTG_SimsApp);
}

/***************************************************************************************************
 *********************** Dynamic Library Entry Points - DO NOT MODIFY ******************************
 **************************************************************************************************/
extern "C" void
NTG_SimsApp__registerAll(Factory & f, ActionFactory & af, Syntax & s)
{
  NTG_SimsApp::registerAll(f, af, s);
}
extern "C" void
NTG_SimsApp__registerApps()
{
  NTG_SimsApp::registerApps();
}
