Class {
	#name : 'StDebuggerCommandTest',
	#superclass : 'TestCase',
	#instVars : [
		'debuggerProvider'
	],
	#category : 'NewTools-Debugger-Tests-Model',
	#package : 'NewTools-Debugger-Tests',
	#tag : 'Model'
}

{ #category : 'running' }
StDebuggerCommandTest >> setUp [
	"Hooks that subclasses may override to define the fixture of test."

	super setUp.
	debuggerProvider := StTestDebuggerProvider new
]

{ #category : 'running' }
StDebuggerCommandTest >> tearDown [
	debuggerProvider terminate.
	(StTestDebuggerProvider lookupSelector:
		 #buildDebuggerWithMissingClassContext) ifNotNil: [ :method | 
		method removeFromSystem ].
	super tearDown
]

{ #category : 'tests' }
StDebuggerCommandTest >> testCommandsInDNUContext [

	| debugger |
	debugger := debuggerProvider debuggerWithDNUContext.

	"Executable commands relative to context"
	self assert:
		(StDefineMethodCommand forContext: debugger) canBeExecuted.
	self assert:
		(StDefineMissingEntityCommand forContext: debugger) canBeExecuted.
	self assert: (StRestartCommand forContext: debugger) canBeExecuted.
	self assert:
		(StReturnValueCommand forContext: debugger) canBeExecuted.

	"Non-executable commands relative to context"
	self deny: (StStepIntoCommand forContext: debugger) canBeExecuted.
	self deny: (StStepOverCommand forContext: debugger) canBeExecuted.
	self deny: (StStepThroughCommand forContext: debugger) canBeExecuted.
	self deny:
		(StRunToSelectionCommand forContext: debugger) canBeExecuted.
	self deny: (StProceedCommand forContext: debugger) canBeExecuted.
	self deny: (StDefineClassCommand forContext: debugger) canBeExecuted.
	self deny:
		(StDefineSubclassResponsabilityCommand forContext: debugger)
			canBeExecuted.
	self deny:
		(StGenerateAndProceedCommand forContext: debugger) canBeExecuted.

	"Executable commands, whatever the context"
	self assert:
		(StCopyStackToClipboardCommand forContext: debugger) canBeExecuted.
	self assert:
		(StFileOutMethodCommand forContext: debugger) canBeExecuted.
	self assert:
		(StPeelToFirstCommand forContext: debugger) canBeExecuted.
	self assert: (StWhereIsCommand forContext: debugger) canBeExecuted.

	debugger debuggerActionModel clear
]

{ #category : 'tests' }
StDebuggerCommandTest >> testCommandsInDeadContext [

	| debugger |
	debugger := debuggerProvider debuggerWithErrorContext.
	debugger debuggerActionModel contextPredicate context pc: nil.

	"Non-executable commands relative to context"
	self deny: (StRestartCommand forContext: debugger) canBeExecuted.
	self deny: (StReturnValueCommand forContext: debugger) canBeExecuted.
	self deny: (StStepIntoCommand forContext: debugger) canBeExecuted.
	self deny: (StStepOverCommand forContext: debugger) canBeExecuted.
	self deny: (StStepThroughCommand forContext: debugger) canBeExecuted.
	self deny:
		(StRunToSelectionCommand forContext: debugger) canBeExecuted.
	self deny: (StProceedCommand forContext: debugger) canBeExecuted.
	self deny: (StDefineClassCommand forContext: debugger) canBeExecuted.
	self deny:
		(StDefineSubclassResponsabilityCommand forContext: debugger)
			canBeExecuted.
	self deny: (StDefineMethodCommand forContext: debugger) canBeExecuted.
	self deny:
		(StDefineMissingEntityCommand forContext: debugger) canBeExecuted.
	self deny:
		(StGenerateAndProceedCommand forContext: debugger) canBeExecuted.

	"Executable commands, whatever the context"
	self assert:
		(StCopyStackToClipboardCommand forContext: debugger) canBeExecuted.
	self assert:
		(StFileOutMethodCommand forContext: debugger) canBeExecuted.
	self assert:
		(StPeelToFirstCommand forContext: debugger) canBeExecuted.
	self assert: (StWhereIsCommand forContext: debugger) canBeExecuted.

	debugger debuggerActionModel clear
]

{ #category : 'tests' }
StDebuggerCommandTest >> testCommandsInErrorContext [

	| debugger |
	debugger := debuggerProvider debuggerWithErrorContext.

	"Executable commands relative to context"
	self assert: (StRestartCommand forContext: debugger) canBeExecuted.
	self assert:
		(StReturnValueCommand forContext: debugger) canBeExecuted.

	"Non-executable commands relative to context"
	self deny: (StStepIntoCommand forContext: debugger) canBeExecuted.
	self deny: (StStepOverCommand forContext: debugger) canBeExecuted.
	self deny: (StStepThroughCommand forContext: debugger) canBeExecuted.
	self deny:
		(StRunToSelectionCommand forContext: debugger) canBeExecuted.
	self deny: (StProceedCommand forContext: debugger) canBeExecuted.
	self deny: (StDefineClassCommand forContext: debugger) canBeExecuted.
	self deny:
		(StDefineSubclassResponsabilityCommand forContext: debugger)
			canBeExecuted.
	self deny: (StDefineMethodCommand forContext: debugger) canBeExecuted.
	self deny:
		(StDefineMissingEntityCommand forContext: debugger) canBeExecuted.
	self deny:
		(StDefineMissingEntityCommand forContext: debugger) canBeExecuted.
	self deny:
		(StGenerateAndProceedCommand forContext: debugger) canBeExecuted.

	"Executable commands, whatever the context"
	self assert:
		(StCopyStackToClipboardCommand forContext: debugger) canBeExecuted.
	self assert:
		(StFileOutMethodCommand forContext: debugger) canBeExecuted.
	self assert:
		(StPeelToFirstCommand forContext: debugger) canBeExecuted.
	self assert: (StWhereIsCommand forContext: debugger) canBeExecuted.

	debugger debuggerActionModel clear
]

{ #category : 'tests' }
StDebuggerCommandTest >> testCommandsInFailingTestContext [

	| debugger |
	debugger := debuggerProvider debuggerWithFailingTestContext.
	self flag:
		'Cannot work until we can properly detect a failing assertion context'.

	"Executable commands relative to context"
	self assert: (StRestartCommand forContext: debugger) canBeExecuted.
	self assert:
		(StReturnValueCommand forContext: debugger) canBeExecuted.

	"Non-executable commands relative to context"
	self deny: (StStepIntoCommand forContext: debugger) canBeExecuted.
	self deny: (StStepOverCommand forContext: debugger) canBeExecuted.
	self deny: (StStepThroughCommand forContext: debugger) canBeExecuted.
	self deny:
		(StRunToSelectionCommand forContext: debugger) canBeExecuted.
	self deny: (StProceedCommand forContext: debugger) canBeExecuted.
	self deny: (StDefineClassCommand forContext: debugger) canBeExecuted.
	self deny:
		(StDefineSubclassResponsabilityCommand forContext: debugger)
			canBeExecuted.
	self deny: (StDefineMethodCommand forContext: debugger) canBeExecuted.
	self deny:
		(StDefineMissingEntityCommand forContext: debugger) canBeExecuted.
	self deny:
		(StDefineMissingEntityCommand forContext: debugger) canBeExecuted.
	self deny:
		(StGenerateAndProceedCommand forContext: debugger) canBeExecuted.

	"Executable commands, whatever the context"
	self assert:
		(StCopyStackToClipboardCommand forContext: debugger) canBeExecuted.
	self assert:
		(StFileOutMethodCommand forContext: debugger) canBeExecuted.
	self assert:
		(StPeelToFirstCommand forContext: debugger) canBeExecuted.
	self assert: (StWhereIsCommand forContext: debugger) canBeExecuted.
	debugger debuggerActionModel clear
]

{ #category : 'tests' }
StDebuggerCommandTest >> testCommandsInGeneratingCodeContext [

	| debugger |
	debugger := debuggerProvider debuggerWithGeneratingCodeContext.

	"Executable commands relative to context"
	self assert: (StRestartCommand forContext: debugger) canBeExecuted.
	self assert:
		(StReturnValueCommand forContext: debugger) canBeExecuted.
	self assert:
		(StGenerateAndProceedCommand forContext: debugger) canBeExecuted.

	"Non-executable commands relative to context"
	self deny: (StProceedCommand forContext: debugger) canBeExecuted.
	self deny: (StStepIntoCommand forContext: debugger) canBeExecuted.
	self deny: (StStepOverCommand forContext: debugger) canBeExecuted.
	self deny: (StStepThroughCommand forContext: debugger) canBeExecuted.
	self deny:
		(StRunToSelectionCommand forContext: debugger) canBeExecuted.
	self deny: (StProceedCommand forContext: debugger) canBeExecuted.
	self deny:
		(StDefineSubclassResponsabilityCommand forContext: debugger)
			canBeExecuted.
	self deny: (StDefineMethodCommand forContext: debugger) canBeExecuted.
	self deny: (StDefineClassCommand forContext: debugger) canBeExecuted.
	self deny:
		(StDefineMissingEntityCommand forContext: debugger) canBeExecuted.

	"Executable commands, whatever the context"
	self assert:
		(StCopyStackToClipboardCommand forContext: debugger) canBeExecuted.
	self assert:
		(StFileOutMethodCommand forContext: debugger) canBeExecuted.
	self assert:
		(StPeelToFirstCommand forContext: debugger) canBeExecuted.
	self assert: (StWhereIsCommand forContext: debugger) canBeExecuted
]

{ #category : 'tests' }
StDebuggerCommandTest >> testCommandsInMissingClassContext [
	"When a class is missing, it is possible we are trying to send it a message.
	Define new class and define new method must be possible. "

	| debugger |
	StTestDebuggerProvider compileMissingClassContextBuilder.
	debugger := debuggerProvider debuggerWithMissingClassContext.

	"Executable commands relative to context"
	self assert:
		(StDefineClassCommand forContext: debugger) canBeExecuted.
	self deny: (StDefineMethodCommand forContext: debugger) canBeExecuted.
	self assert:
		(StDefineMissingEntityCommand forContext: debugger) canBeExecuted.
	self assert: (StRestartCommand forContext: debugger) canBeExecuted.
	self assert:
		(StReturnValueCommand forContext: debugger) canBeExecuted.

	"Non-executable commands relative to context"
	self assert: (StStepIntoCommand forContext: debugger) canBeExecuted.
	self assert: (StStepOverCommand forContext: debugger) canBeExecuted.
	self assert:
		(StStepThroughCommand forContext: debugger) canBeExecuted.
	self assert:
		(StRunToSelectionCommand forContext: debugger) canBeExecuted.
	self assert: (StProceedCommand forContext: debugger) canBeExecuted.
	self deny:
		(StDefineSubclassResponsabilityCommand forContext: debugger)
			canBeExecuted.
	self deny:
		(StGenerateAndProceedCommand forContext: debugger) canBeExecuted.

	"Executable commands, whatever the context"
	self assert:
		(StCopyStackToClipboardCommand forContext: debugger) canBeExecuted.
	self assert:
		(StFileOutMethodCommand forContext: debugger) canBeExecuted.
	self assert:
		(StPeelToFirstCommand forContext: debugger) canBeExecuted.
	self assert: (StWhereIsCommand forContext: debugger) canBeExecuted.
	debugger debuggerActionModel clear
]

{ #category : 'tests' }
StDebuggerCommandTest >> testCommandsInMissingSubclassResponsibilityContext [

	| debugger |
	debugger := debuggerProvider
		            debuggerWithMissingSubclassResponsibilityContext.

	"Executable commands relative to context"
	self assert:
		(StDefineSubclassResponsabilityCommand forContext: debugger)
			canBeExecuted.
	self assert:
		(StDefineMissingEntityCommand forContext: debugger) canBeExecuted.
	self assert: (StRestartCommand forContext: debugger) canBeExecuted.
	self assert:
		(StReturnValueCommand forContext: debugger) canBeExecuted.

	"Non-executable commands relative to context"
	self deny: (StStepIntoCommand forContext: debugger) canBeExecuted.
	self deny: (StStepOverCommand forContext: debugger) canBeExecuted.
	self deny: (StStepThroughCommand forContext: debugger) canBeExecuted.
	self deny:
		(StRunToSelectionCommand forContext: debugger) canBeExecuted.
	self deny: (StProceedCommand forContext: debugger) canBeExecuted.
	self deny: (StDefineClassCommand forContext: debugger) canBeExecuted.
	self deny: (StDefineMethodCommand forContext: debugger) canBeExecuted.
	self deny:
		(StGenerateAndProceedCommand forContext: debugger) canBeExecuted.

	"Executable commands, whatever the context"
	self assert:
		(StCopyStackToClipboardCommand forContext: debugger) canBeExecuted.
	self assert:
		(StFileOutMethodCommand forContext: debugger) canBeExecuted.
	self assert:
		(StPeelToFirstCommand forContext: debugger) canBeExecuted.
	self assert: (StWhereIsCommand forContext: debugger) canBeExecuted.

	debugger debuggerActionModel clear
]

{ #category : 'tests' }
StDebuggerCommandTest >> testCommandsInMissingSubclassResponsibilityContextWithSteps [

	| debugger |
	[
	debugger := debuggerProvider
		            debuggerWithMissingSubclassResponsibilityContextWithSteps.
	self assert: debugger debuggerActionModel
			isInterruptedContextSubclassResponsibilityException.

	"Executable commands relative to context"
	self assert:
		(StDefineSubclassResponsabilityCommand forContext: debugger)
			canBeExecuted.
	self assert:
		(StDefineMissingEntityCommand forContext: debugger) canBeExecuted.
	self assert: (StRestartCommand forContext: debugger) canBeExecuted.
	self assert:
		(StReturnValueCommand forContext: debugger) canBeExecuted.

	"Non-executable commands relative to context"
	self deny: (StStepIntoCommand forContext: debugger) canBeExecuted.
	self deny: (StStepOverCommand forContext: debugger) canBeExecuted.
	self deny: (StStepThroughCommand forContext: debugger) canBeExecuted.
	self deny:
		(StRunToSelectionCommand forContext: debugger) canBeExecuted.
	self deny: (StProceedCommand forContext: debugger) canBeExecuted.
	self deny: (StDefineClassCommand forContext: debugger) canBeExecuted.
	self deny: (StDefineMethodCommand forContext: debugger) canBeExecuted.
	self deny:
		(StGenerateAndProceedCommand forContext: debugger) canBeExecuted.

	"Executable commands, whatever the context"
	self assert:
		(StCopyStackToClipboardCommand forContext: debugger) canBeExecuted.
	self assert:
		(StFileOutMethodCommand forContext: debugger) canBeExecuted.
	self assert:
		(StPeelToFirstCommand forContext: debugger) canBeExecuted.
	self assert: (StWhereIsCommand forContext: debugger) canBeExecuted ]
		ensure: [ debugger ifNotNil: [ debugger clear ] ]
]

{ #category : 'tests' }
StDebuggerCommandTest >> testCommandsInRunnableContext [

	| debugger |
	debugger := debuggerProvider debuggerWithRunnableContext.

	"Executable commands relative to context"
	self assert: (StStepIntoCommand forContext: debugger) canBeExecuted.
	self assert: (StStepOverCommand forContext: debugger) canBeExecuted.
	self assert:
		(StStepThroughCommand forContext: debugger) canBeExecuted.
	self assert:
		(StRunToSelectionCommand forContext: debugger) canBeExecuted.
	self assert: (StProceedCommand forContext: debugger) canBeExecuted.
	self assert: (StRestartCommand forContext: debugger) canBeExecuted.
	self assert:
		(StReturnValueCommand forContext: debugger) canBeExecuted.

	"Non-executable commands relative to context"
	self deny:
		(StDefineSubclassResponsabilityCommand forContext: debugger)
			canBeExecuted.
	self deny: (StDefineMethodCommand forContext: debugger) canBeExecuted.
	self deny: (StDefineClassCommand forContext: debugger) canBeExecuted.
	self deny:
		(StDefineMissingEntityCommand forContext: debugger) canBeExecuted.
	self deny:
		(StGenerateAndProceedCommand forContext: debugger) canBeExecuted.

	"Executable commands, whatever the context"
	self assert:
		(StCopyStackToClipboardCommand forContext: debugger) canBeExecuted.
	self assert:
		(StFileOutMethodCommand forContext: debugger) canBeExecuted.
	self assert:
		(StPeelToFirstCommand forContext: debugger) canBeExecuted.
	self assert: (StProceedCommand forContext: debugger) canBeExecuted.
	self assert: (StWhereIsCommand forContext: debugger) canBeExecuted.
	debugger debuggerActionModel clear
]

{ #category : 'tests - execution' }
StDebuggerCommandTest >> testStCopyStackToClipboardCommandExecution [
	"Generated 5 June 2020"
	|debugger command|
	debugger := StDummyDebuggerPresenter new.
	command := StCopyStackToClipboardCommand forContext: debugger.
	"StCopyStackToClipboardCommand command calls the #copyStackToClipboard action interface of the debugger object"
	command execute.
	self assert: debugger tag equals: #copyStackToClipboard
]

{ #category : 'tests - execution' }
StDebuggerCommandTest >> testStDefineClassCommandExecution [
	"Generated 5 June 2020"
	|debugger command|
	debugger := StDummyDebuggerPresenter new.
	command := StDefineClassCommand forContext: debugger.
	"StDefineClassCommand command calls the #createMissingClass action interface of the debugger object"
	command execute.
	self assert: debugger tag equals: #createMissingClass
]

{ #category : 'tests - execution' }
StDebuggerCommandTest >> testStDefineMethodCommandExecution [
	"Generated 5 June 2020"
	|debugger command|
	debugger := StDummyDebuggerPresenter new.
	command := StDefineMethodCommand forContext: debugger.
	"StDefineMethodCommand command calls the #createMissingMethod action interface of the debugger object"
	command execute.
	self assert: debugger tag equals: #implementMissingMethod
]

{ #category : 'tests - execution' }
StDebuggerCommandTest >> testStDefineMissingEntityCommandExecution [

	| debugger command oldActionModel |
	StTestDebuggerProvider compileMissingClassContextBuilder.
	debugger := debuggerProvider debuggerWithDNUContext.
	command := StDefineMissingEntityCommand forContext: debugger.
	self
		assertCollection: (command subCommands collect: [ :c | c class ])
		equals: StDefineMissingEntityCommand allSubclasses.
	self
		assert: command applicableCommand class
		identicalTo: StDefineMethodCommand.

	oldActionModel := debugger debuggerActionModel.
	debugger := debuggerProvider debuggerWithMissingClassContext.
	command := StDefineMissingEntityCommand forContext: debugger.
	oldActionModel clear.
	oldActionModel session clear.
	self
		assert: command applicableCommand class
		identicalTo: StDefineClassCommand.

	oldActionModel := debugger debuggerActionModel.
	debugger := debuggerProvider
		            debuggerWithMissingSubclassResponsibilityContext.
	command := StDefineMissingEntityCommand forContext: debugger.

	self
		assert: command applicableCommand class
		identicalTo: StDefineSubclassResponsabilityCommand.

	oldActionModel clear.
	oldActionModel session clear.
	debugger debuggerActionModel clear
]

{ #category : 'tests - execution' }
StDebuggerCommandTest >> testStDefineSubclassResponsabilityCommandExecution [
	"Generated 5 June 2020"
	|debugger command|
	debugger := StDummyDebuggerPresenter new.
	command := StDefineSubclassResponsabilityCommand forContext: debugger.
	"StDefineSubclassResponsabilityCommand command calls the #createSubclassResponsibility action interface of the debugger object"
	command execute.
	self assert: debugger tag equals: #implementMissingMethod
]

{ #category : 'tests - execution' }
StDebuggerCommandTest >> testStFileOutMethodCommandExecution [
	"Generated 5 June 2020"
	|debugger command|
	debugger := StDummyDebuggerPresenter new.
	command := StFileOutMethodCommand forContext: debugger.
	"StFileOutMethodCommand command calls the #fileOutSelectedContext action interface of the debugger object"
	command execute.
	self assert: debugger tag equals: #fileOutSelectedContext
]

{ #category : 'tests' }
StDebuggerCommandTest >> testStGenerateAndProceedCommandExecution [

	| debugger command |
	debugger := StDummyDebuggerPresenter new.
	command := StGenerateAndProceedCommand forContext: debugger.
	"StGenerateAndProceedCommand command calls the #saveGeneratedCodeAndProceed action interface of the debugger object"
	command execute.
	self assert: debugger tag equals: #saveGeneratedCodeAndProceed
]

{ #category : 'tests - execution' }
StDebuggerCommandTest >> testStPeelToFirstCommandExecution [
	
	|debugger command|
	debugger := StDummyDebuggerPresenter new.
	command := StPeelToFirstCommand forContext: debugger.
	"StCopyStackToClipboardCommand command calls the #copyStackToClipboard action interface of the debugger object"
	command execute.
	self assert: debugger tag equals: #peelToFirstLike:
]

{ #category : 'tests - execution' }
StDebuggerCommandTest >> testStProceedCommandExecution [
	"Generated 5 June 2020"
	|debugger command|
	debugger := StDummyDebuggerPresenter new.
	command := StProceedCommand forContext: debugger.
	"StProceedCommand command calls the #proceedDebugSession action interface of the debugger object"
	command execute.
	self assert: debugger tag equals: #proceedDebugSession
]

{ #category : 'tests - execution' }
StDebuggerCommandTest >> testStRestartCommandExecution [
	"Generated 5 June 2020"
	|debugger command|
	debugger := StDummyDebuggerPresenter new.
	command := StRestartCommand forContext: debugger.
	"StRestartCommand command calls the #restartCurrentContext action interface of the debugger object"
	command execute.
	self assert: debugger tag equals: #restartCurrentContext
]

{ #category : 'tests - execution' }
StDebuggerCommandTest >> testStReturnValueCommandExecution [
	"Generated 5 June 2020"
	|debugger command|
	debugger := StDummyDebuggerPresenter new.
	command := StReturnValueCommand forContext: debugger.
	"StReturnValueCommand command calls the #returnEnteredValue action interface of the debugger object"
	command execute.
	self assert: debugger tag equals: #returnEnteredValue
]

{ #category : 'tests - execution' }
StDebuggerCommandTest >> testStRunToSelectionCommandExecution [
	"Generated 5 June 2020"
	|debugger command|
	debugger := StDummyDebuggerPresenter new.
	command := StRunToSelectionCommand forContext: debugger.
	"StRunToSelectionCommand command calls the #runToSelection action interface of the debugger object"
	command execute.
	self assert: debugger tag equals: #runToSelection
]

{ #category : 'tests - execution' }
StDebuggerCommandTest >> testStStepIntoCommandExecution [
	"Generated 5 June 2020"
	|debugger command|
	debugger := StDummyDebuggerPresenter new.
	command := StStepIntoCommand forContext: debugger.
	"StStepIntoCommand command calls the #stepInto action interface of the debugger object"
	command execute.
	self assert: debugger tag equals: #stepInto
]

{ #category : 'tests - execution' }
StDebuggerCommandTest >> testStStepOverCommandExecution [
	"Generated 5 June 2020"
	|debugger command|
	debugger := StDummyDebuggerPresenter new.
	command := StStepOverCommand forContext: debugger.
	"StStepOverCommand command calls the #stepOver action interface of the debugger object"
	command execute.
	self assert: debugger tag equals: #stepOver
]

{ #category : 'tests - execution' }
StDebuggerCommandTest >> testStStepThroughCommandExecution [
	"Generated 5 June 2020"
	|debugger command|
	debugger := StDummyDebuggerPresenter new.
	command := StStepThroughCommand forContext: debugger.
	"StStepThroughCommand command calls the #stepThrough action interface of the debugger object"
	command execute.
	self assert: debugger tag equals: #stepThrough
]

{ #category : 'tests - execution' }
StDebuggerCommandTest >> testStWhereIsCommandExecution [
	"Generated 5 June 2020"
	|debugger command|
	debugger := StDummyDebuggerPresenter new.
	command := StWhereIsCommand forContext: debugger.
	"StWhereIsCommand command calls the #selectNextExecutedExpression action interface of the debugger object"
	command execute.
	self assert: debugger tag equals: #selectNextExecutedExpression
]
