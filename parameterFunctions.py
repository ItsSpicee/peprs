# parameterFunctions.py contains functions that are called when parameter values are chosen

from PyQt5.QtGui import (QCursor)
from PyQt5.QtCore import (Qt)

def displayVsg(self,buttonPHover,buttonGreyPHover,buttonGreyP):
	awgChecked = self.ui.awgSetGeneral.isChecked()
	vsgChecked = self.ui.vsgSetGeneral.isChecked()
	scopeChecked = self.ui.scopeSet.isChecked()
	digChecked = self.ui.digSet.isChecked()
	uxaChecked = self.ui.uxaSet.isChecked()
	pxaChecked = self.ui.pxaSet.isChecked()
	i = self.ui.vsgSetup.currentIndex()
	if i == 0: # select
		self.ui.vsgEquipStack.setCurrentIndex(2)
		self.ui.vsgEquipStackAdv.setCurrentIndex(2)
		self.ui.vsgNextSteps.setCurrentIndex(0)
		self.ui.vsgWorkflows.setCurrentIndex(0)
		self.ui.vsaButton_vsg.setStyleSheet(buttonGreyP)
		self.ui.vsaButton_vsg.setCursor(QCursor(Qt.ArrowCursor))
	elif i == 1 or i == 2 or i == 3:
		self.ui.vsgEquipStack.setCurrentIndex(0)
		self.ui.vsgEquipStackAdv.setCurrentIndex(0)
		if i == 1: # AWG
			self.ui.vsgWorkflows.setCurrentIndex(1)
			self.ui.vsgWorkflowForVSA.setCurrentIndex(0) # vsa: awg
			self.ui.vsgWorkflowForDown.setCurrentIndex(0)
			if scopeChecked or digChecked or uxaChecked or pxaChecked:
				self.ui.vsaButton_vsg.setStyleSheet(buttonPHover)
				self.ui.vsaButton_vsg.setCursor(QCursor(Qt.PointingHandCursor))
			else:
				self.ui.vsaButton_vsg.setStyleSheet(buttonGreyPHover) # make vsa change colour on hover
				self.ui.vsaButton_vsg.setCursor(QCursor(Qt.PointingHandCursor)) # make cursor pointer over vsa
			if awgChecked:
				self.ui.vsgNextSteps.setCurrentIndex(5)
			else:
				self.ui.vsgNextSteps.setCurrentIndex(1)	
		if i == 2: # AWG & Up
			self.ui.vsgWorkflows.setCurrentIndex(2)
			self.ui.vsgWorkflowForVSA.setCurrentIndex(1) # vsa: awg and up
			self.ui.vsgWorkflowForDown.setCurrentIndex(1)
			self.ui.vsaButton_vsg.setCursor(QCursor(Qt.ArrowCursor))
			if awgChecked:
				self.ui.vsgNextSteps.setCurrentIndex(2)
			else:
				self.ui.vsgNextSteps.setCurrentIndex(1)
		if i == 3: # AWG & PSG
			self.ui.vsgWorkflows.setCurrentIndex(3)
			self.ui.vsgWorkflowForVSA.setCurrentIndex(2) # vsa: awg and psg
			self.ui.vsgWorkflowForDown.setCurrentIndex(2)
			if scopeChecked or digChecked or uxaChecked or pxaChecked:
				self.ui.vsaButton_vsg.setStyleSheet(buttonPHover)
				self.ui.vsaButton_vsg.setCursor(QCursor(Qt.PointingHandCursor))
			else:
				self.ui.vsaButton_vsg.setStyleSheet(buttonGreyP)
				self.ui.vsaButton_vsg.setCursor(QCursor(Qt.ArrowCursor))
			if awgChecked:
				self.ui.vsgNextSteps.setCurrentIndex(3)
			else:
				self.ui.vsgNextSteps.setCurrentIndex(1)
	elif i == 4: # VSG
		self.ui.vsgEquipStack.setCurrentIndex(1)
		self.ui.vsgEquipStackAdv.setCurrentIndex(1)
		self.ui.vsgNextSteps.setCurrentIndex(4)
		self.ui.vsgWorkflows.setCurrentIndex(4)
		self.ui.vsgWorkflowForVSA.setCurrentIndex(3) # vsa: vsg
		self.ui.vsgWorkflowForDown.setCurrentIndex(3)
		if scopeChecked or digChecked or uxaChecked or pxaChecked:
			self.ui.vsaButton_vsg.setStyleSheet(buttonPHover)
			self.ui.vsaButton_vsg.setCursor(QCursor(Qt.PointingHandCursor))
		else:
			self.ui.vsaButton_vsg.setStyleSheet(buttonGreyPHover)
			self.ui.vsaButton_vsg.setCursor(QCursor(Qt.PointingHandCursor))
		if vsgChecked:
			self.ui.vsgNextSteps.setCurrentIndex(5)
		else:
			self.ui.vsgNextSteps.setCurrentIndex(4)

def displayVsa(self,unsetBox,buttonGreyBHover,buttonGreyGHover,buttonGreyB):	
	vsaIdx = self.ui.vsaType.currentIndex()
	averaging = self.ui.averagingEnable.currentIndex()
	demod = self.ui.demodulationEnable.currentIndex()
	scopeChecked = self.ui.scopeSet.isChecked()
	uxaChecked = self.ui.uxaSet.isChecked()
	pxaChecked = self.ui.pxaSet.isChecked()
	digChecked = self.ui.digSet.isChecked()
	
	if vsaIdx == 0:
		self.ui.vsaWorkflow.setCurrentIndex(0)
		self.ui.vsaEquipStack.setCurrentIndex(3)
		self.ui.vsaAdvancedStack.setCurrentIndex(0)
		self.ui.vsaNextStack.setCurrentIndex(0)
	elif demod == 0:
		self.ui.uxaMod.setEnabled(False)
		self.ui.digMod.setEnabled(False)
		self.ui.scopeMod.setEnabled(False)
		if vsaIdx == 1:
			self.ui.vsaWorkflow.setCurrentIndex(1)
			self.ui.single_vsa_stack.setCurrentIndex(0)
			self.ui.vsaEquipStack.setCurrentIndex(1)
			self.ui.vsaAdvancedStack.setCurrentIndex(1)
		elif vsaIdx == 2:
			self.ui.vsaWorkflow.setCurrentIndex(1)
			self.ui.single_vsa_stack.setCurrentIndex(1)
			self.ui.vsaEquipStack.setCurrentIndex(2)
			self.ui.vsaAdvancedStack.setCurrentIndex(1)
		elif vsaIdx == 3:
			self.ui.vsaWorkflow.setCurrentIndex(1)
			self.ui.single_vsa_stack.setCurrentIndex(2)
			self.ui.vsaEquipStack.setCurrentIndex(0)
			self.ui.uxa_pxa_titleStack.setCurrentIndex(0)
			self.ui.vsaAdvancedStack.setCurrentIndex(2)
			self.ui.uxa_pxa_titleStackAdv.setCurrentIndex(0)
			self.ui.uxa_pxa_set.setCurrentIndex(0)
		elif vsaIdx == 4:
			self.ui.vsaWorkflow.setCurrentIndex(1)
			self.ui.single_vsa_stack.setCurrentIndex(3)
			self.ui.vsaEquipStack.setCurrentIndex(0)
			self.ui.uxa_pxa_titleStack.setCurrentIndex(1)
			self.ui.vsaAdvancedStack.setCurrentIndex(2)
			self.ui.uxa_pxa_titleStackAdv.setCurrentIndex(1)
			self.ui.uxa_pxa_set.setCurrentIndex(1)
		elif vsaIdx == 5:
			self.ui.vsaWorkflow.setCurrentIndex(4)
			self.ui.single_down_vsa_stack.setCurrentIndex(1)
			self.ui.vsaEquipStack.setCurrentIndex(1)
			self.ui.vsaAdvancedStack.setCurrentIndex(1)
		elif vsaIdx == 6:
			self.ui.vsaWorkflow.setCurrentIndex(4)
			self.ui.single_down_vsa_stack.setCurrentIndex(0)
			self.ui.vsaEquipStack.setCurrentIndex(2)
			self.ui.vsaAdvancedStack.setCurrentIndex(1)
	elif demod == 1:
		self.ui.uxaMod.setEnabled(True)
		self.ui.digMod.setEnabled(True)
		self.ui.scopeMod.setEnabled(True)
			
		if vsaIdx == 1:
			digOrScopeSet(self,1,averaging,scopeChecked,buttonGreyBHover)
			self.ui.vsaWorkflow.setCurrentIndex(2)
			self.ui.single_mod_vsa_stack.setCurrentIndex(0)
		elif vsaIdx == 2:
			digOrScopeSet(self,2,averaging,digChecked,buttonGreyBHover)
			self.ui.vsaWorkflow.setCurrentIndex(2)
			self.ui.single_mod_vsa_stack.setCurrentIndex(1)
		elif vsaIdx == 3:
			uxaOrPxaSet(self,0,averaging,uxaChecked,unsetBox,buttonGreyBHover)
			self.ui.vsaWorkflow.setCurrentIndex(2)
			self.ui.single_mod_vsa_stack.setCurrentIndex(2)
		elif vsaIdx == 4:
			uxaOrPxaSet(self,1,averaging,pxaChecked,unsetBox,buttonGreyBHover)
			self.ui.vsaWorkflow.setCurrentIndex(2)
			self.ui.single_mod_vsa_stack.setCurrentIndex(3)
		elif vsaIdx == 5:
			digOrScopeDownSet(self,1,averaging,scopeChecked,buttonGreyB,buttonGreyGHover)
			self.ui.vsaWorkflow.setCurrentIndex(3)
			self.ui.single_mod_down_vsa_stack.setCurrentIndex(0)
			self.ui.vsaWorkflowForDown.setCurrentIndex(1)
			self.ui.single_mod_down_down_stack.setCurrentIndex(0)
		elif vsaIdx == 6:
			digOrScopeDownSet(self,2,averaging,digChecked,buttonGreyB,buttonGreyGHover)
			self.ui.vsaWorkflow.setCurrentIndex(3)
			self.ui.single_mod_down_vsa_stack.setCurrentIndex(1)
			self.ui.vsaWorkflowForDown.setCurrentIndex(1)
			self.ui.single_mod_down_down_stack.setCurrentIndex(1)
	elif demod == 2:
		self.ui.uxaMod.setEnabled(False)
		self.ui.digMod.setEnabled(False)
		self.ui.scopeMod.setEnabled(False)
		if vsaIdx == 1:
			digOrScopeSet(self,1,averaging,scopeChecked,buttonGreyBHover)
			self.ui.vsaWorkflow.setCurrentIndex(1)
			self.ui.single_vsa_stack.setCurrentIndex(0)
		elif vsaIdx == 2:
			digOrScopeSet(self,2,averaging,digChecked,buttonGreyBHover)
			self.ui.vsaWorkflow.setCurrentIndex(1)
			self.ui.single_vsa_stack.setCurrentIndex(1)
		elif vsaIdx == 3:
			uxaOrPxaSet(self,0,averaging,uxaChecked,unsetBox,buttonGreyBHover)
			self.ui.vsaWorkflow.setCurrentIndex(1)
			self.ui.single_vsa_stack.setCurrentIndex(2)
		elif vsaIdx == 4:
			uxaOrPxaSet(self,1,averaging,pxaChecked,unsetBox,buttonGreyBHover)
			self.ui.vsaWorkflow.setCurrentIndex(1)
			self.ui.single_vsa_stack.setCurrentIndex(3)
		elif vsaIdx == 5:
			digOrScopeDownSet(self,1,averaging,scopeChecked,buttonGreyB,buttonGreyGHover)
			self.ui.vsaWorkflow.setCurrentIndex(4)
			self.ui.single_down_vsa_stack.setCurrentIndex(1)
			self.ui.vsaWorkflowForDown.setCurrentIndex(0)
			self.ui.single_down_down_stack.setCurrentIndex(1)
		elif vsaIdx == 6:	
			digOrScopeDownSet(self,2,averaging,digChecked,buttonGreyB,buttonGreyGHover)
			self.ui.vsaWorkflow.setCurrentIndex(4)
			self.ui.single_down_vsa_stack.setCurrentIndex(0)
			self.ui.vsaWorkflowForDown.setCurrentIndex(0)
			self.ui.single_down_down_stack.setCurrentIndex(0)			
				
# apply changes from one demod box to all demod boxes
def copyDemod(self,changedModField,replacedFieldOne,replacedFieldTwo):
	value = changedModField.toPlainText()
	replacedFieldOne.blockSignals(True)
	replacedFieldTwo.blockSignals(True)
	replacedFieldOne.setPlainText(value)
	replacedFieldTwo.setPlainText(value)
	replacedFieldOne.blockSignals(False)
	replacedFieldTwo.blockSignals(False)
	
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# functions called within parameterFunctions	

def uxaOrPxaSet(self,idx,averaging,equipChecked,unsetBox,buttonGreyBHover):	
	valueOne = self.ui.dllFile_uxa.toPlainText()
	valueTwo = self.ui.setupFile_uxa.toPlainText()
	valueThree = self.ui.dataFile_uxa.toPlainText()
	
	self.ui.vsaEquipStack.setCurrentIndex(0)
	self.ui.vsaAdvancedStack.setCurrentIndex(2)
	
	self.ui.uxa_pxa_titleStack.setCurrentIndex(idx)
	self.ui.uxa_pxa_titleStackAdv.setCurrentIndex(idx)
	self.ui.uxa_pxa_set.setCurrentIndex(idx)
	
	if averaging == 0:
		self.ui.vsaNextStack.setCurrentIndex(0)
	elif equipChecked:
		if valueOne == "" or valueTwo == "" or valueThree =="":
			self.ui.vsaNextStack.setCurrentIndex(1)
		else:
			self.ui.vsaNextStack.setCurrentIndex(3)
	else:
		self.ui.vsaNextStack.setCurrentIndex(1)
		self.ui.uxaEquipGeneralVSA.setStyleSheet(unsetBox)
		
	if equipChecked:
		self.ui.meterButton_vsa.setStyleSheet(buttonGreyBHover)
		self.ui.meterButton_vsa.setCursor(QCursor(Qt.PointingHandCursor))
	
def digOrScopeSet(self,idx,averaging,equipChecked,buttonGreyBHover):
	valueOne = self.ui.dllFile_uxa.toPlainText()
	valueTwo = self.ui.setupFile_uxa.toPlainText()
	valueThree = self.ui.dataFile_uxa.toPlainText()
	
	self.ui.vsaEquipStack.setCurrentIndex(idx)
	self.ui.vsaAdvancedStack.setCurrentIndex(1)
	
	if averaging == 0:
		self.ui.vsaNextStack.setCurrentIndex(0)
	elif equipChecked:
		if valueOne == "" or valueTwo == "" or valueThree =="":
			self.ui.vsaNextStack.setCurrentIndex(1)
		else:
			self.ui.vsaNextStack.setCurrentIndex(3)
	else:
		self.ui.vsaNextStack.setCurrentIndex(1)
		
	if equipChecked:
		self.ui.meterButton_vsa.setStyleSheet(buttonGreyBHover)
		self.ui.meterButton_vsa.setCursor(QCursor(Qt.PointingHandCursor))

def digOrScopeDownSet(self,idx,averaging,equipChecked,buttonGreyB,buttonGreyGHover):	
	valueOne = self.ui.dllFile_uxa.toPlainText()
	valueTwo = self.ui.setupFile_uxa.toPlainText()
	valueThree = self.ui.dataFile_uxa.toPlainText()
	
	self.ui.vsaEquipStack.setCurrentIndex(idx)
	self.ui.vsaAdvancedStack.setCurrentIndex(1)
	
	if averaging == 0:
		self.ui.vsaNextStack.setCurrentIndex(0)
	elif equipChecked:
		if valueOne == "" or valueTwo == "" or valueThree =="":
			self.ui.vsaNextStack.setCurrentIndex(1)
		else:
			self.ui.vsaNextStack.setCurrentIndex(2)
	else:
		self.ui.vsaNextStack.setCurrentIndex(1)
		
	if equipChecked:
		self.ui.meterButton_vsa.setStyleSheet(buttonGreyB)
		self.ui.meterButton_vsa.setCursor(QCursor(Qt.ArrowCursor))
		self.ui.downButton_vsa.setStyleSheet(buttonGreyGHover)
		self.ui.downButton_vsa_2.setStyleSheet(buttonGreyGHover)
		self.ui.downButton_vsa.setCursor(QCursor(Qt.PointingHandCursor))
		self.ui.downButton_vsa_2.setCursor(QCursor(Qt.PointingHandCursor))