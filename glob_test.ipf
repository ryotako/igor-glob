#pragma rtGlobals=3		// Use modern global access method and strict wave access.
#pragma ModuleName = glob_test
#include "glob"
#include "unit-testing"

Menu "Test"
	"Test glob.ipf", DoWindow/F/H; RunTest("glob_test.ipf")
End

static Function Glob_DataFolders()
	NewDataFolder/O root:Packages:glob_test
	NewDataFolder/O root:Packages:glob_test:folder1
	NewDataFolder/O root:Packages:glob_test:folder2
	NewDataFolder/O root:Packages:glob_test:folder3
	
	Make/FREE/T/N=3 expected
	expected[0] = "root:Packages:glob_test:folder1:"
	expected[1] = "root:Packages:glob_test:folder2:"
	expected[2] = "root:Packages:glob_test:folder3:"
	CHECK_EQUAL_TEXTWAVES(  expected, glob("root:Packages:glob_test:*:") )

	Make/FREE/T/N=1 expected
	expected[0] = "root:Packages:glob_test:folder1:"	
	CHECK_EQUAL_TEXTWAVES(  expected, glob("root:Packages:glob_test:*1:") )

	Make/FREE/T/N=0 expected
	CHECK_EQUAL_TEXTWAVES(  expected, glob("root:Packages:glob_test:*4:") )

	KillDataFolder root:Packages:glob_test
End

static Function Glob_Objects()
	NewDataFolder/O root:Packages:glob_test
	NewDataFolder/O root:Packages:glob_test:DF_test	
	Variable/G root:Packages:glob_test:V_test
	String/G root:Packages:glob_test:S_test
	Make/O root:Packages:glob_test:W_test
	
	Make/FREE/T/N=4 expected
	expected[0] = "root:Packages:glob_test:W_test"
	expected[1] = "root:Packages:glob_test:V_test"
	expected[2] = "root:Packages:glob_test:S_test"
	expected[3] = "root:Packages:glob_test:DF_test"
	CHECK_EQUAL_TEXTWAVES(  expected, glob("root:Packages:glob_test:*") )
	CHECK_EQUAL_TEXTWAVES(  expected, glob("root:Packages:glob_test:*_test") )

	Make/FREE/T/N=1 expected
	expected[0] = "root:Packages:glob_test:W_test"
	CHECK_EQUAL_TEXTWAVES(  expected, glob("root:Packages:glob_test:W_*") )
	
	Make/FREE/T/N=0 expected
	CHECK_EQUAL_TEXTWAVES(  expected, glob("root:Packages:glob_test:no_*") )

	KillDataFolder root:Packages:glob_test
End

static Function Glob_RelativePaths()
	DFREF here = GetDataFolderDFR()
	NewDataFolder/O root:Packages:glob_test
	NewDataFolder/O root:Packages:glob_test:DF_test	
	Variable/G root:Packages:glob_test:V_test
	Variable/G root:Packages:glob_test:DF_test:V_test
	
	SetDataFolder root:Packages:glob_test
	
	Make/FREE/T/N=2 expected = {"V_test", "DF_test"}
	CHECK_EQUAL_TEXTWAVES(  expected, glob("*") )

	Make/FREE/T/N=2 expected = {":V_test", ":DF_test"}
	CHECK_EQUAL_TEXTWAVES(  expected, glob(":*") )

	Make/FREE/T/N=3 expected
	expected[0] = "V_test"
	expected[1] = "DF_test"
	expected[2] = "DF_test:V_test"
	CHECK_EQUAL_TEXTWAVES(  expected, glob("**") )
	
	expected = ":" + expected
	CHECK_EQUAL_TEXTWAVES(  expected, glob(":**") )

	KillDataFolder root:Packages:glob_test
	SetDataFolder here
End

static Function Glob_ParentPaths()
	DFREF here = GetDataFolderDFR()
	NewDataFolder/O root:Packages:glob_test
	NewDataFolder/O root:Packages:glob_test:folder
	NewDataFolder/O root:Packages:glob_test:folder:sub
	NewDataFolder/O root:Packages:glob_test:folder:sub:subsub

	SetDataFolder root:Packages:glob_test:folder:sub:subsub
	
	Make/FREE/T/N=1 expected = {"root:Packages:glob_test:folder:sub:subsub"}
	CHECK_EQUAL_TEXTWAVES(  expected, glob("::*") )

	Make/FREE/T/N=1 expected = {"root:Packages:glob_test:folder:sub"}
	CHECK_EQUAL_TEXTWAVES(  expected, glob(":::*") )

	Make/FREE/T/N=1 expected = {"root:Packages:glob_test:folder:sub:subsub"}
	CHECK_EQUAL_TEXTWAVES(  expected, glob("::*::*::*::*") )

	KillDataFolder root:Packages:glob_test
	SetDataFolder here
End

static Function Glob_FreeNames()
	NewDataFolder/O root:Packages:glob_test
	NewDataFolder/O root:Packages:glob_test:normal_name
	Variable/G root:Packages:glob_test:normal_name:V_test
	NewDataFolder/O root:Packages:glob_test:'free name'
	Variable/G root:Packages:glob_test:'free name':V_test
	NewDataFolder/O root:Packages:glob_test:'!exclamation'
	Variable/G root:Packages:glob_test:'!exclamation':V_test
	
	Make/FREE/T/N=3 expected
	expected[0] = "root:Packages:glob_test:normal_name"
	expected[1] = "root:Packages:glob_test:'free name'"
	expected[2] = "root:Packages:glob_test:'!exclamation'"
	
	CHECK_EQUAL_TEXTWAVES(  expected, glob("root:Packages:glob_test:*") )
	expected += ":"
	CHECK_EQUAL_TEXTWAVES(  expected, glob("root:Packages:glob_test:*:") )

	Make/FREE/T/N=1 expected
	expected[0] = "root:Packages:glob_test:'!exclamation'"
	CHECK_EQUAL_TEXTWAVES(  expected, glob("root:Packages:glob_test:!*") )

	Make/FREE/T/N=2 expected
	expected[0] = "root:Packages:glob_test:normal_name"
	expected[1] = "root:Packages:glob_test:'free name'"
	CHECK_EQUAL_TEXTWAVES(  expected, glob("root:Packages:glob_test:*name") )

	Make/FREE/T/N=1 expected
	expected[0] = "root:Packages:glob_test:'free name'"
	CHECK_EQUAL_TEXTWAVES(  expected, glob("root:Packages:glob_test:'*name'") )

	KillDataFolder root:Packages:glob_test
End

static Function Glob_SubSubFolders()
	NewDataFolder/O root:Packages:glob_test
	NewDataFolder/O root:Packages:glob_test:folder1
	NewDataFolder/O root:Packages:glob_test:folder2
	NewDataFolder/O root:Packages:glob_test:folder3
	NewDataFolder/O root:Packages:glob_test:folder1:sub1
	NewDataFolder/O root:Packages:glob_test:folder1:sub2
	NewDataFolder/O root:Packages:glob_test:folder1:sub3
	NewDataFolder/O root:Packages:glob_test:folder2:sub1
	NewDataFolder/O root:Packages:glob_test:folder2:sub2
	NewDataFolder/O root:Packages:glob_test:folder2:sub3
	NewDataFolder/O root:Packages:glob_test:folder3:sub1
	NewDataFolder/O root:Packages:glob_test:folder3:sub2
	NewDataFolder/O root:Packages:glob_test:folder3:sub3

	Make/FREE/T/N=3 expected
	expected[0] = "root:Packages:glob_test:folder1:sub1:"
	expected[1] = "root:Packages:glob_test:folder2:sub1:"
	expected[2] = "root:Packages:glob_test:folder3:sub1:"

	CHECK_EQUAL_TEXTWAVES(  expected, glob("root:Packages:glob_test:*:*1:") )

	Make/FREE/T/N=4 expected
	expected[0] = "root:Packages:glob_test:folder1:"
	expected[1] = "root:Packages:glob_test:folder1:sub1:"
	expected[2] = "root:Packages:glob_test:folder2:sub1:"
	expected[3] = "root:Packages:glob_test:folder3:sub1:"

	CHECK_EQUAL_TEXTWAVES(  expected, glob("root:Packages:glob_test:**1:") )

	KillDataFolder root:Packages:glob_test	
End