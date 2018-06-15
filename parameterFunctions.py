# parameterFunctions.py contains functions that are called when parameter values are chosen

from PyQt5.QtGui import (QCursor)
from PyQt5.QtCore import (Qt)
import setParameters as set

def displayVsg(self,buttonPHover,buttonGreyPHover,buttonGreyGHover,buttonGreyP):
	awgChecked = self.ui.awgSetGeneral.isChecked()
	vsgChecked = self.ui.vsgSetGeneral.isChecked()
	upChecked = self.ui.upSet.isChecked()
	psgChecked = self.ui.psgSet.isChecked()
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
			setVSGWorkflows(self,0)
			if awgChecked:
				self.ui.vsgNextSteps.setCurrentIndex(5)
				self.ui.vsaButton_vsg.setStyleSheet(buttonGreyPHover)
				self.ui.vsaButton_vsg.setCursor(QCursor(Qt.PointingHandCursor))
			else:
				self.ui.vsgNextSteps.setCurrentIndex(1)	
				self.ui.vsaButton_vsg.setStyleSheet(buttonGreyP)
				self.ui.vsaButton_vsg.setCursor(QCursor(Qt.ArrowCursor))
		if i == 2: # AWG & Up
			self.ui.vsgWorkflows.setCurrentIndex(2)
			setVSGWorkflows(self,1)
			self.ui.up_psg_next.setCurrentIndex(0)
			if upChecked == False:
				self.ui.vsaButton_vsg.setStyleSheet(buttonGreyP)
				self.ui.vsaButton_vsg.setCursor(QCursor(Qt.ArrowCursor))
			if awgChecked and upChecked == False:
				self.ui.vsgNextSteps.setCurrentIndex(2)
				self.ui.upButton_vsg.setStyleSheet(buttonGreyGHover)
				self.ui.upButton_vsg.setCursor(QCursor(Qt.PointingHandCursor))
			else:
				self.ui.vsgNextSteps.setCurrentIndex(1)
		if i == 3: # AWG & PSG
			self.ui.vsgWorkflows.setCurrentIndex(3)
			setVSGWorkflows(self,2)
			self.ui.up_psg_next.setCurrentIndex(1) 
			if psgChecked == False:
				self.ui.vsaButton_vsg.setStyleSheet(buttonGreyP)
				self.ui.vsaButton_vsg.setCursor(QCursor(Qt.ArrowCursor))
			if awgChecked and psgChecked == False:
				self.ui.vsgNextSteps.setCurrentIndex(3)
				self.ui.psgButton_vsg.setStyleSheet(buttonGreyGHover)
				self.ui.psgButton_vsg.setCursor(QCursor(Qt.PointingHandCursor))
			else:
				self.ui.vsgNextSteps.setCurrentIndex(1)
	elif i == 4: # VSG
		self.ui.vsgEquipStack.setCurrentIndex(1)
		self.ui.vsgEquipStackAdv.setCurrentIndex(1)
		self.ui.vsgNextSteps.setCurrentIndex(4)
		self.ui.vsgWorkflows.setCurrentIndex(4)
		setVSGWorkflows(self,3)
		self.ui.vsaButton_vsg.setStyleSheet(buttonGreyP)
		self.ui.vsaButton_vsg.setCursor(QCursor(Qt.ArrowCursor))
		if vsgChecked:
			self.ui.vsgNextSteps.setCurrentIndex(5)
			self.ui.vsaButton_vsg.setStyleSheet(buttonGreyPHover)
			self.ui.vsaButton_vsg.setCursor(QCursor(Qt.PointingHandCursor))
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
		self.ui.vsaWorkflow_vsg.setCurrentIndex(0)
		self.ui.vsaWorkflow_up.setCurrentIndex(0)
	elif demod == 0:
		self.ui.uxaMod.setEnabled(False)
		self.ui.digMod.setEnabled(False)
		self.ui.scopeMod.setEnabled(False)
		if vsaIdx == 1:
			self.ui.vsaWorkflow.setCurrentIndex(1)
			self.ui.single_vsa_stack.setCurrentIndex(0)
			self.ui.vsaEquipStack.setCurrentIndex(1)
			self.ui.vsaAdvancedStack.setCurrentIndex(1)
			setVSAWorkflowsNoModNoDown(self,1,0)
		elif vsaIdx == 2:
			self.ui.vsaWorkflow.setCurrentIndex(1)
			self.ui.single_vsa_stack.setCurrentIndex(1)
			self.ui.vsaEquipStack.setCurrentIndex(2)
			self.ui.vsaAdvancedStack.setCurrentIndex(1)
			setVSAWorkflowsNoModNoDown(self,1,1)
		elif vsaIdx == 3:
			self.ui.vsaWorkflow.setCurrentIndex(1)
			self.ui.single_vsa_stack.setCurrentIndex(2)
			self.ui.vsaEquipStack.setCurrentIndex(0)
			self.ui.uxa_pxa_titleStack.setCurrentIndex(0)
			self.ui.vsaAdvancedStack.setCurrentIndex(2)
			self.ui.uxa_pxa_titleStackAdv.setCurrentIndex(0)
			self.ui.uxa_pxa_set.setCurrentIndex(0)
			setVSAWorkflowsNoModNoDown(self,1,2)
		elif vsaIdx == 4:
			self.ui.vsaWorkflow.setCurrentIndex(1)
			self.ui.single_vsa_stack.setCurrentIndex(3)
			self.ui.vsaEquipStack.setCurrentIndex(0)
			self.ui.uxa_pxa_titleStack.setCurrentIndex(1)
			self.ui.vsaAdvancedStack.setCurrentIndex(2)
			self.ui.uxa_pxa_titleStackAdv.setCurrentIndex(1)
			self.ui.uxa_pxa_set.setCurrentIndex(1)
			setVSAWorkflowsNoModNoDown(self,1,3)
		elif vsaIdx == 5:
			self.ui.vsaEquipStack.setCurrentIndex(1)
			self.ui.vsaAdvancedStack.setCurrentIndex(1)
			setVSAWorkflowsNoModWithDown(self,4,0,1)
		elif vsaIdx == 6:
			self.ui.vsaEquipStack.setCurrentIndex(2)
			self.ui.vsaAdvancedStack.setCurrentIndex(1)
			setVSAWorkflowsNoModWithDown(self,4,0,0)
	elif demod == 1:
		self.ui.uxaMod.setEnabled(True)
		self.ui.digMod.setEnabled(True)
		self.ui.scopeMod.setEnabled(True)	
		if vsaIdx == 1:
			digOrScopeSet(self,1,averaging,demod,scopeChecked,buttonGreyBHover,unsetBox,vsaIdx)
			self.ui.vsaWorkflow.setCurrentIndex(2)
			self.ui.single_mod_vsa_stack.setCurrentIndex(0)
			setVSAWorkflowsWithModNoDown(self,2,0)
		elif vsaIdx == 2:
			digOrScopeSet(self,2,averaging,demod,digChecked,buttonGreyBHover,unsetBox,vsaIdx)
			self.ui.vsaWorkflow.setCurrentIndex(2)
			self.ui.single_mod_vsa_stack.setCurrentIndex(1)
			setVSAWorkflowsWithModNoDown(self,2,1)
		elif vsaIdx == 3:
			uxaOrPxaSet(self,0,averaging,demod,uxaChecked,buttonGreyBHover,unsetBox)
			self.ui.vsaWorkflow.setCurrentIndex(2)
			self.ui.single_mod_vsa_stack.setCurrentIndex(2)
			setVSAWorkflowsWithModNoDown(self,2,2)
		elif vsaIdx == 4:
			uxaOrPxaSet(self,1,averaging,demod,pxaChecked,buttonGreyBHover,unsetBox)
			self.ui.vsaWorkflow.setCurrentIndex(2)
			self.ui.single_mod_vsa_stack.setCurrentIndex(3)
			setVSAWorkflowsWithModNoDown(self,2,3)
		elif vsaIdx == 5:
			digOrScopeDownSet(self,1,averaging,demod,scopeChecked,buttonGreyB,buttonGreyGHover,unsetBox,vsaIdx)
			setVSAWorkflowsWithModWithDown(self,3,1,0)
		elif vsaIdx == 6:
			digOrScopeDownSet(self,2,averaging,demod,digChecked,buttonGreyB,buttonGreyGHover,unsetBox,vsaIdx)
			setVSAWorkflowsWithModWithDown(self,3,1,1)
	elif demod == 2:
		self.ui.uxaMod.setEnabled(False)
		self.ui.digMod.setEnabled(False)
		self.ui.scopeMod.setEnabled(False)
		if vsaIdx == 1:
			digOrScopeSet(self,1,averaging,demod,scopeChecked,buttonGreyBHover,unsetBox,vsaIdx)
			self.ui.vsaWorkflow.setCurrentIndex(1)
			self.ui.single_vsa_stack.setCurrentIndex(0)
			setVSAWorkflowsNoModNoDown(self,1,0)
		elif vsaIdx == 2:
			digOrScopeSet(self,2,averaging,demod,digChecked,buttonGreyBHover,unsetBox,vsaIdx)
			self.ui.vsaWorkflow.setCurrentIndex(1)
			self.ui.single_vsa_stack.setCurrentIndex(1)
			setVSAWorkflowsNoModNoDown(self,1,1)
		elif vsaIdx == 3:
			uxaOrPxaSet(self,0,averaging,demod,uxaChecked,buttonGreyBHover,unsetBox)
			self.ui.vsaWorkflow.setCurrentIndex(1)
			self.ui.single_vsa_stack.setCurrentIndex(2)
			setVSAWorkflowsNoModNoDown(self,1,2)
		elif vsaIdx == 4:
			uxaOrPxaSet(self,1,averaging,demod,pxaChecked,buttonGreyBHover,unsetBox)
			self.ui.vsaWorkflow.setCurrentIndex(1)
			self.ui.single_vsa_stack.setCurrentIndex(3)
			setVSAWorkflowsNoModNoDown(self,1,3)
		elif vsaIdx == 5:
			digOrScopeDownSet(self,1,averaging,demod,scopeChecked,buttonGreyB,buttonGreyGHover,unsetBox,vsaIdx)
			setVSAWorkflowsNoModWithDown(self,4,0,1)
		elif vsaIdx == 6:	
			digOrScopeDownSet(self,2,averaging,demod,digChecked,buttonGreyB,buttonGreyGHover,unsetBox,vsaIdx)
			setVSAWorkflowsNoModWithDown(self,4,0,0)	
				
# apply changes from one demod box to all demod boxes
def copyDemod(self,changedModField,replacedFieldOne,replacedFieldTwo):
	value = changedModField.toPlainText()
	replacedFieldOne.blockSignals(True)
	replacedFieldTwo.blockSignals(True)
	replacedFieldOne.setPlainText(value)
	replacedFieldTwo.setPlainText(value)
	replacedFieldOne.blockSignals(False)
	replacedFieldTwo.blockSignals(False)
	
def displaySa(self,buttonSelected,buttonColourFocus,buttonPHover,buttonHoverB,buttonHoverP,buttonGreyB):
	saIdx = self.ui.saType.currentIndex()
	saChecked = self.ui.saSet.isChecked()
	if saIdx == 0:
		self.ui.saNextStack.setCurrentIndex(4)
		self.ui.saEquipStandardStack.setCurrentIndex(1)
		self.ui.saEquipAdvStack.setCurrentIndex(0)
		self.ui.saButton_sa.setStyleSheet(buttonSelected)
		if saChecked == False:
			self.ui.saNextStack.setCurrentIndex(4)
			self.ui.meterNextStack.setCurrentIndex(1)
			self.ui.downNextStack.setCurrentIndex(2)
			self.ui.vsaNextStack.setCurrentIndex(4)
			self.ui.up_psg_next.setCurrentIndex(6)
			self.ui.vsgNextSteps.setCurrentIndex(8)
			self.ui.saButton_sa.setStyleSheet(buttonSelected)
			self.ui.saButton_sa_2.setStyleSheet(buttonSelected)
			self.ui.saButton_sa_3.setStyleSheet(buttonSelected)
			self.ui.saButton_sa_4.setStyleSheet(buttonSelected)
			set.setPrevSAButtons(self,buttonHoverP,buttonGreyB)
	elif saIdx == 1 or saIdx == 2:
		self.ui.saEquipStandardStack.setCurrentIndex(0)
		self.ui.saEquipAdvStack.setCurrentIndex(1)
		if saChecked == False:
			self.ui.saNextStack.setCurrentIndex(4)
			self.ui.meterNextStack.setCurrentIndex(1)
			self.ui.downNextStack.setCurrentIndex(2)
			self.ui.vsaNextStack.setCurrentIndex(4)
			self.ui.up_psg_next.setCurrentIndex(6)
			self.ui.vsgNextSteps.setCurrentIndex(8)
			self.ui.saButton_sa.setStyleSheet(buttonSelected)
			self.ui.saButton_sa_2.setStyleSheet(buttonSelected)
			self.ui.saButton_sa_3.setStyleSheet(buttonSelected)
			self.ui.saButton_sa_4.setStyleSheet(buttonSelected)
			set.setPrevSAButtons(self,buttonHoverP,buttonGreyB)
	elif saIdx == 3:
		self.ui.saNextStack.setCurrentIndex(0)
		self.ui.meterNextStack.setCurrentIndex(2)
		self.ui.downNextStack.setCurrentIndex(3)
		self.ui.vsaNextStack.setCurrentIndex(5)
		self.ui.up_psg_next.setCurrentIndex(7)
		self.ui.vsgNextSteps.setCurrentIndex(9)
		
		self.ui.saEquipStandardStack.setCurrentIndex(2)
		self.ui.saEquipAdvStack.setCurrentIndex(2)
		self.ui.saButton_sa.setStyleSheet(buttonColourFocus)
		self.ui.saButton_sa_2.setStyleSheet(buttonColourFocus)
		self.ui.saButton_sa_3.setStyleSheet(buttonColourFocus)
		self.ui.saButton_sa_4.setStyleSheet(buttonColourFocus)
		set.setPrevSAButtons(self,buttonPHover,buttonHoverB)
		
		
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# functions called within parameterFunctions	

def setVSGWorkflows(self,idx):
	self.ui.vsgWorkflowForVSA.setCurrentIndex(idx)
	self.ui.vsgWorkflowForDown.setCurrentIndex(idx)
	self.ui.vsgWorkflow_meter.setCurrentIndex(idx)
	self.ui.vsgWorkflow_sa.setCurrentIndex(idx)
	self.ui.vsgWorkflow_power1.setCurrentIndex(idx)
	self.ui.vsgWorkflow_power3.setCurrentIndex(idx)
	
def setVSAWorkflowsWithModNoDown(self,idx,subidx):
	self.ui.vsaWorkflow_vsg.setCurrentIndex(idx)
	self.ui.single_mod_vsg_stack.setCurrentIndex(subidx)
	self.ui.vsaWorkflow_up.setCurrentIndex(idx)
	self.ui.single_mod_up_stack.setCurrentIndex(subidx)
	self.ui.vsaWorkflow_meter.setCurrentIndex(idx)
	self.ui.single_mod_meter_stack.setCurrentIndex(subidx)
	self.ui.vsaWorkflow_sa.setCurrentIndex(idx)
	self.ui.single_mod_sa_stack.setCurrentIndex(subidx)
	self.ui.vsaWorkflow_power1.setCurrentIndex(idx)
	self.ui.single_mod_p1_stack.setCurrentIndex(subidx)
	self.ui.vsaWorkflow_power2.setCurrentIndex(idx)
	self.ui.single_mod_p2_stack.setCurrentIndex(subidx)

def setVSAWorkflowsNoModNoDown(self,idx,subidx):
	self.ui.vsaWorkflow_vsg.setCurrentIndex(idx)
	self.ui.single_vsg_stack.setCurrentIndex(subidx)
	self.ui.vsaWorkflow_up.setCurrentIndex(idx)
	self.ui.single_up_stack.setCurrentIndex(subidx)
	self.ui.vsaWorkflow_meter.setCurrentIndex(idx)
	self.ui.single_meter_stack.setCurrentIndex(subidx)
	self.ui.vsaWorkflow_sa.setCurrentIndex(idx)
	self.ui.single_sa_stack.setCurrentIndex(subidx)
	self.ui.vsaWorkflow_power1.setCurrentIndex(idx)
	self.ui.single_p1_stack.setCurrentIndex(subidx)
	self.ui.vsaWorkflow_power2.setCurrentIndex(idx)
	self.ui.single_p2_stack.setCurrentIndex(subidx)
	
def setVSAWorkflowsNoModWithDown(self,idx,twoidx,subidx):
	self.ui.vsaWorkflow.setCurrentIndex(idx) # 4
	self.ui.single_down_vsa_stack.setCurrentIndex(subidx) # 1 = scope, 0 = dig
	self.ui.vsaWorkflow_vsg.setCurrentIndex(idx)
	self.ui.single_down_vsg_stack.setCurrentIndex(subidx)
	self.ui.vsaWorkflow_up.setCurrentIndex(idx)
	self.ui.single_down_up_stack.setCurrentIndex(subidx)
	self.ui.vsaWorkflow_meter.setCurrentIndex(idx)
	self.ui.single_down_meter_stack.setCurrentIndex(subidx)
	self.ui.vsaWorkflow_sa.setCurrentIndex(idx)
	self.ui.single_down_sa_stack.setCurrentIndex(subidx)
	self.ui.vsaWorkflow_power1.setCurrentIndex(idx)
	self.ui.single_down_p1_stack.setCurrentIndex(subidx)
	self.ui.vsaWorkflow_power2.setCurrentIndex(idx)
	self.ui.single_down_p2_stack.setCurrentIndex(subidx)
	self.ui.vsaWorkflowForDown.setCurrentIndex(twoidx) #0
	self.ui.single_down_down_stack.setCurrentIndex(subidx)
	self.ui.vsaWorkflow_power3.setCurrentIndex(twoidx)
	self.ui.single_down_p3_stack.setCurrentIndex(subidx)
	
def setVSAWorkflowsWithModWithDown(self,idx,twoidx,subidx):
	self.ui.vsaWorkflow.setCurrentIndex(idx) # 3
	self.ui.single_mod_down_vsa_stack.setCurrentIndex(subidx) # 0 = scope, 1 = dig
	self.ui.vsaWorkflow_vsg.setCurrentIndex(idx)
	self.ui.single_mod_down_vsg_stack.setCurrentIndex(subidx)
	self.ui.vsaWorkflow_up.setCurrentIndex(idx)
	self.ui.single_mod_down_up_stack.setCurrentIndex(subidx)
	self.ui.vsaWorkflow_meter.setCurrentIndex(idx)
	self.ui.single_mod_down_meter_stack.setCurrentIndex(subidx)
	self.ui.vsaWorkflow_sa.setCurrentIndex(idx)
	self.ui.single_mod_down_sa_stack.setCurrentIndex(subidx)
	self.ui.vsaWorkflow_power1.setCurrentIndex(idx)
	self.ui.single_mod_down_p1_stack.setCurrentIndex(subidx)
	self.ui.vsaWorkflow_power2.setCurrentIndex(idx)
	self.ui.single_mod_down_p2_stack.setCurrentIndex(subidx)
	self.ui.vsaWorkflowForDown.setCurrentIndex(twoidx) #1
	self.ui.single_mod_down_down_stack.setCurrentIndex(subidx)
	self.ui.vsaWorkflow_power3.setCurrentIndex(twoidx)
	self.ui.single_mod_down_p3_stack.setCurrentIndex(subidx)
	
def uxaOrPxaSet(self,idx,averaging,demod,equipChecked,buttonGreyBHover,unsetBox):	
	style = self.ui.uxaMod.styleSheet()
	
	self.ui.vsaEquipStack.setCurrentIndex(0)
	self.ui.vsaAdvancedStack.setCurrentIndex(2)
	
	self.ui.uxa_pxa_titleStack.setCurrentIndex(idx)
	self.ui.uxa_pxa_titleStackAdv.setCurrentIndex(idx)
	self.ui.uxa_pxa_set.setCurrentIndex(idx)
	
	if averaging == 0:
		self.ui.vsaNextStack.setCurrentIndex(0)
	elif equipChecked:
		if demod == 1:
			if style == "":
				self.ui.vsaNextStack.setCurrentIndex(1)
			else:
				self.ui.vsaNextStack.setCurrentIndex(3)
		else:
			self.ui.vsaNextStack.setCurrentIndex(3)
	else:
		self.ui.vsaNextStack.setCurrentIndex(1)
		self.ui.uxaEquipGeneralVSA.setStyleSheet(unsetBox)
		
	if equipChecked:
		self.ui.meterButton_vsa.setStyleSheet(buttonGreyBHover)
		self.ui.meterButton_vsa.setCursor(QCursor(Qt.PointingHandCursor))
	
def digOrScopeSet(self,idx,averaging,demod,equipChecked,buttonGreyBHover,unsetBox,vsaIdx):
	styleDig = self.ui.digMod.styleSheet()
	styleScope = self.ui.scopeMod.styleSheet()
	
	self.ui.vsaEquipStack.setCurrentIndex(idx)
	self.ui.vsaAdvancedStack.setCurrentIndex(1)
	
	if averaging == 0:
		self.ui.vsaNextStack.setCurrentIndex(0)
	elif equipChecked:
		if demod == 1:
			if vsaIdx == 1:
				if styleScope == "":
					self.ui.vsaNextStack.setCurrentIndex(1)
				else:
					self.ui.vsaNextStack.setCurrentIndex(3)
			elif vsaIdx == 2:
				if styleDig == "":
					self.ui.vsaNextStack.setCurrentIndex(1)
				else:
					self.ui.vsaNextStack.setCurrentIndex(3)
		else:
			self.ui.vsaNextStack.setCurrentIndex(3)
	else:
		self.ui.vsaNextStack.setCurrentIndex(1)
		
	if equipChecked:
		self.ui.meterButton_vsa.setStyleSheet(buttonGreyBHover)
		self.ui.meterButton_vsa.setCursor(QCursor(Qt.PointingHandCursor))

def digOrScopeDownSet(self,idx,averaging,demod,equipChecked,buttonGreyB,buttonGreyGHover,unsetBox,vsaIdx):	
	styleDig = self.ui.digMod.styleSheet()
	styleScope = self.ui.scopeMod.styleSheet()
	
	self.ui.vsaEquipStack.setCurrentIndex(idx)
	self.ui.vsaAdvancedStack.setCurrentIndex(1)
	
	if averaging == 0:
		self.ui.vsaNextStack.setCurrentIndex(0)
	elif equipChecked:
		if demod == 1:
			if vsaIdx == 5:			
				if styleScope == "":
					self.ui.vsaNextStack.setCurrentIndex(1)
				else:
					self.ui.vsaNextStack.setCurrentIndex(2)
			elif vsaIdx == 6:
				if styleDig == "":
					self.ui.vsaNextStack.setCurrentIndex(1)
				else:
					self.ui.vsaNextStack.setCurrentIndex(2)
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