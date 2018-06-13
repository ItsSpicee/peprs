# parameterFunctions.py contains functions that are called when parameter values are chosen

from PyQt5.QtGui import (QCursor)
from PyQt5.QtCore import (Qt)

def displayVsg(self):
	awgChecked = self.ui.awgSetGeneral.isChecked()
	vsgChecked = self.ui.vsgSetGeneral.isChecked()
	i = self.ui.vsgSetup.currentIndex()
	purpleBox = "QPushButton{ border:3px solid purple;  background-color:qlineargradient(spread:pad, x1:1, y1:1, x2:1, y2:0, stop:0 rgba(209, 209, 209, 255), stop:1 rgba(254, 254, 254, 255)); border-radius:5px; color:black;}"
	purpleHover = "QPushButton{ border:3px solid purple;  background-color:qlineargradient(spread:pad, x1:1, y1:1, x2:1, y2:0, stop:0 rgba(209, 209, 209, 255), stop:1 rgba(254, 254, 254, 255)); border-radius:5px; color:black;} QPushButton:hover{background-color:rgb(243, 243, 243);}"
	if i == 0: # select
		self.ui.vsgEquipStack.setCurrentIndex(2)
		self.ui.vsgEquipStackAdv.setCurrentIndex(2)
		self.ui.vsgNextSteps.setCurrentIndex(0)
		self.ui.vsgWorkflows.setCurrentIndex(0)
		self.ui.vsaButton_vsg.setStyleSheet(purpleBox)
		self.ui.vsaButton_vsg.setCursor(QCursor(Qt.ArrowCursor))
	elif i == 1 or i == 2 or i == 3:
		self.ui.vsgEquipStack.setCurrentIndex(0)
		self.ui.vsgEquipStackAdv.setCurrentIndex(0)
		if i == 1: # AWG
			self.ui.vsgWorkflows.setCurrentIndex(1)
			self.ui.vsgWorkflowForVSA.setCurrentIndex(0) # vsa: awg
			self.ui.vsaButton_vsg.setStyleSheet(purpleHover) # make vsa change colour on hover
			self.ui.vsaButton_vsg.setCursor(QCursor(Qt.PointingHandCursor)) # make cursor pointer over vsa
			if awgChecked:
				self.ui.vsgNextSteps.setCurrentIndex(5)
			else:
				self.ui.vsgNextSteps.setCurrentIndex(1)	
		if i == 2: # AWG & Up
			self.ui.vsgWorkflows.setCurrentIndex(2)
			self.ui.vsgWorkflowForVSA.setCurrentIndex(1) # vsa: awg and up
			
			self.ui.vsaButton_vsg.setCursor(QCursor(Qt.ArrowCursor))
			if awgChecked:
				self.ui.vsgNextSteps.setCurrentIndex(2)
			else:
				self.ui.vsgNextSteps.setCurrentIndex(1)
		if i == 3: # AWG & PSG
			self.ui.vsgWorkflows.setCurrentIndex(3)
			self.ui.vsgWorkflowForVSA.setCurrentIndex(2) # vsa: awg and psg
			self.ui.vsaButton_vsg.setStyleSheet(purpleBox)
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
		self.ui.vsaButton_vsg.setStyleSheet(purpleHover)
		self.ui.vsaButton_vsg.setCursor(QCursor(Qt.PointingHandCursor))
		if vsgChecked:
			self.ui.vsgNextSteps.setCurrentIndex(5)
		else:
			self.ui.vsgNextSteps.setCurrentIndex(4)

def displayVsa(self,unsetBox):	
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
			self.ui.uxa_pxa_titleStack.setCurrentIndex(1)
			self.ui.vsaAdvancedStack.setCurrentIndex(2)
			self.ui.uxa_pxa_titleStackAdv.setCurrentIndex(0)
			self.ui.uxa_pxa_set.setCurrentIndex(0)
		elif vsaIdx == 4:
			self.ui.vsaWorkflow.setCurrentIndex(1)
			self.ui.single_vsa_stack.setCurrentIndex(3)
			self.ui.vsaEquipStack.setCurrentIndex(0)
			self.ui.uxa_pxa_titleStack.setCurrentIndex(0)
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
			self.ui.vsaWorkflow.setCurrentIndex(2)
			self.ui.single_mod_vsa_stack.setCurrentIndex(0)
			self.ui.vsaEquipStack.setCurrentIndex(1)
			self.ui.vsaAdvancedStack.setCurrentIndex(1)
			if averaging == 0:
				self.ui.vsaNextStack.setCurrentIndex(0)
			elif scopeChecked:
				self.ui.vsaNextStack.setCurrentIndex(3)
			else:
				self.ui.vsaNextStack.setCurrentIndex(1)
		elif vsaIdx == 2:
			self.ui.vsaWorkflow.setCurrentIndex(2)
			self.ui.single_mod_vsa_stack.setCurrentIndex(1)
			self.ui.vsaEquipStack.setCurrentIndex(2)
			self.ui.vsaAdvancedStack.setCurrentIndex(1)
			if averaging == 0:
				self.ui.vsaNextStack.setCurrentIndex(0)
			elif digChecked:
				self.ui.vsaNextStack.setCurrentIndex(3)
			else:
				self.ui.vsaNextStack.setCurrentIndex(1)
		elif vsaIdx == 3:
			self.ui.vsaWorkflow.setCurrentIndex(2)
			self.ui.single_mod_vsa_stack.setCurrentIndex(2)
			self.ui.vsaEquipStack.setCurrentIndex(0)
			self.ui.uxa_pxa_titleStack.setCurrentIndex(1)
			self.ui.vsaAdvancedStack.setCurrentIndex(2)
			self.ui.uxa_pxa_titleStackAdv.setCurrentIndex(0)
			self.ui.uxa_pxa_set.setCurrentIndex(0)
			if averaging == 0:
				self.ui.vsaNextStack.setCurrentIndex(0)
			elif uxaChecked:
				self.ui.vsaNextStack.setCurrentIndex(3)
			else:
				self.ui.vsaNextStack.setCurrentIndex(1)
				self.ui.uxaEquipGeneralVSA.setStyleSheet(unsetBox)
		elif vsaIdx == 4:
			self.ui.vsaWorkflow.setCurrentIndex(2)
			self.ui.single_mod_vsa_stack.setCurrentIndex(3)
			self.ui.vsaEquipStack.setCurrentIndex(0)
			self.ui.uxa_pxa_titleStack.setCurrentIndex(0)
			self.ui.vsaAdvancedStack.setCurrentIndex(2)
			self.ui.uxa_pxa_titleStackAdv.setCurrentIndex(1)
			self.ui.uxa_pxa_set.setCurrentIndex(1)
			if averaging == 0:
				self.ui.vsaNextStack.setCurrentIndex(0)
			elif pxaChecked:
				self.ui.vsaNextStack.setCurrentIndex(3)
			else:
				self.ui.vsaNextStack.setCurrentIndex(1)
				self.ui.uxaEquipGeneralVSA.setStyleSheet(unsetBox)
		elif vsaIdx == 5:
			self.ui.vsaWorkflow.setCurrentIndex(3)
			self.ui.single_mod_down_vsa_stack.setCurrentIndex(0)
			self.ui.vsaEquipStack.setCurrentIndex(1)
			self.ui.vsaAdvancedStack.setCurrentIndex(1)
			if averaging == 0:
				self.ui.vsaNextStack.setCurrentIndex(0)
			elif scopeChecked:
				self.ui.vsaNextStack.setCurrentIndex(2)
			else:
				self.ui.vsaNextStack.setCurrentIndex(1)
		elif vsaIdx == 6:
			self.ui.vsaWorkflow.setCurrentIndex(3)
			self.ui.single_mod_down_vsa_stack.setCurrentIndex(1)
			self.ui.vsaEquipStack.setCurrentIndex(2)
			self.ui.vsaAdvancedStack.setCurrentIndex(1)
			if averaging == 0:
				self.ui.vsaNextStack.setCurrentIndex(0)
			elif digChecked:
				self.ui.vsaNextStack.setCurrentIndex(2)
			else:
				self.ui.vsaNextStack.setCurrentIndex(1)
	elif demod == 2:
		self.ui.uxaMod.setEnabled(False)
		self.ui.digMod.setEnabled(False)
		self.ui.scopeMod.setEnabled(False)
		if averaging == 0:
			self.ui.vsaNextStack.setCurrentIndex(0)
		elif vsaIdx == 1:
			self.ui.vsaWorkflow.setCurrentIndex(1)
			self.ui.single_vsa_stack.setCurrentIndex(0)
			self.ui.vsaEquipStack.setCurrentIndex(1)
			self.ui.vsaAdvancedStack.setCurrentIndex(1)
			if averaging == 0:
				self.ui.vsaNextStack.setCurrentIndex(0)
			elif scopeChecked:
				self.ui.vsaNextStack.setCurrentIndex(3)
			else:
				self.ui.vsaNextStack.setCurrentIndex(1)
		elif vsaIdx == 2:
			self.ui.vsaWorkflow.setCurrentIndex(1)
			self.ui.single_vsa_stack.setCurrentIndex(1)
			self.ui.vsaEquipStack.setCurrentIndex(2)
			self.ui.vsaAdvancedStack.setCurrentIndex(1)
			if averaging == 0:
				self.ui.vsaNextStack.setCurrentIndex(0)
			elif digChecked:
				self.ui.vsaNextStack.setCurrentIndex(3)
			else:
				self.ui.vsaNextStack.setCurrentIndex(1)
		elif vsaIdx == 3:
			self.ui.vsaWorkflow.setCurrentIndex(1)
			self.ui.single_vsa_stack.setCurrentIndex(2)
			self.ui.vsaEquipStack.setCurrentIndex(0)
			self.ui.uxa_pxa_titleStack.setCurrentIndex(1)
			self.ui.vsaAdvancedStack.setCurrentIndex(2)
			self.ui.uxa_pxa_titleStackAdv.setCurrentIndex(0)
			self.ui.uxa_pxa_set.setCurrentIndex(0)
			if averaging == 0:
				self.ui.vsaNextStack.setCurrentIndex(0)
			elif uxaChecked:
				self.ui.vsaNextStack.setCurrentIndex(3)
			else:
				self.ui.vsaNextStack.setCurrentIndex(1)
				self.ui.uxaEquipGeneralVSA.setStyleSheet(unsetBox)
		elif vsaIdx == 4:
			self.ui.vsaWorkflow.setCurrentIndex(1)
			self.ui.single_vsa_stack.setCurrentIndex(3)
			self.ui.vsaEquipStack.setCurrentIndex(0)
			self.ui.uxa_pxa_titleStack.setCurrentIndex(0)
			self.ui.vsaAdvancedStack.setCurrentIndex(2)
			self.ui.uxa_pxa_titleStackAdv.setCurrentIndex(1)
			self.ui.uxa_pxa_set.setCurrentIndex(1)
			if averaging == 0:
				self.ui.vsaNextStack.setCurrentIndex(0)
			elif pxaChecked:
				self.ui.vsaNextStack.setCurrentIndex(3)
			else:
				self.ui.vsaNextStack.setCurrentIndex(1)
				self.ui.uxaEquipGeneralVSA.setStyleSheet(unsetBox)
		elif vsaIdx == 5:
			self.ui.vsaWorkflow.setCurrentIndex(4)
			self.ui.single_down_vsa_stack.setCurrentIndex(1)
			self.ui.vsaEquipStack.setCurrentIndex(1)	
			self.ui.vsaAdvancedStack.setCurrentIndex(1)
			if averaging == 0:
				self.ui.vsaNextStack.setCurrentIndex(0)
			elif scopeChecked:
				self.ui.vsaNextStack.setCurrentIndex(2)
			else:
				self.ui.vsaNextStack.setCurrentIndex(1)
		elif vsaIdx == 6:
			self.ui.vsaWorkflow.setCurrentIndex(4)
			self.ui.single_down_vsa_stack.setCurrentIndex(0)
			self.ui.vsaEquipStack.setCurrentIndex(2)
			self.ui.vsaAdvancedStack.setCurrentIndex(1)
			if averaging == 0:
				self.ui.vsaNextStack.setCurrentIndex(0)
			elif digChecked:
				self.ui.vsaNextStack.setCurrentIndex(2)
			else:
				self.ui.vsaNextStack.setCurrentIndex(1)
				
# apply changes from one demod box to all demod boxes
def copyDemod(self,changedModField,replacedFieldOne,replacedFieldTwo):
	value = changedModField.toPlainText()
	replacedFieldOne.blockSignals(True)
	replacedFieldTwo.blockSignals(True)
	replacedFieldOne.setPlainText(value)
	replacedFieldTwo.setPlainText(value)
	replacedFieldOne.blockSignals(False)
	replacedFieldTwo.blockSignals(False)