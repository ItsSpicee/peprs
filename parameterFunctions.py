# parameterFunctions.py contains functions that are called when parameter values are chosen

from PyQt5.QtGui import (QCursor)
from PyQt5.QtCore import (Qt)
from PyQt5.QtWidgets import (QMessageBox)
import setParameters as set

def displayVsg(self,greyHover,greyButton):
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
		self.ui.vsaButton_vsg.setStyleSheet(greyButton)
		self.ui.vsaButton_vsg.setCursor(QCursor(Qt.ArrowCursor))
	elif i == 1 or i == 2 or i == 3:
		self.ui.vsgEquipStack.setCurrentIndex(0)
		self.ui.vsgEquipStackAdv.setCurrentIndex(0)
		if i == 1: # AWG
			self.ui.vsgWorkflows.setCurrentIndex(1)
			setVSGWorkflows(self,0)
			if awgChecked:
				self.ui.vsgNextSteps.setCurrentIndex(5)
				self.ui.vsaButton_vsg.setStyleSheet(greyHover)
				self.ui.vsaButton_vsg.setCursor(QCursor(Qt.PointingHandCursor))
			else:
				self.ui.vsgNextSteps.setCurrentIndex(1)	
				self.ui.vsaButton_vsg.setStyleSheet(greyButton)
				self.ui.vsaButton_vsg.setCursor(QCursor(Qt.ArrowCursor))
		if i == 2: # AWG & Up
			self.ui.vsgWorkflows.setCurrentIndex(2)
			setVSGWorkflows(self,1)
			self.ui.up_psg_next.setCurrentIndex(0)
			if upChecked == False:
				self.ui.vsaButton_vsg.setStyleSheet(greyButton)
				self.ui.vsaButton_vsg.setCursor(QCursor(Qt.ArrowCursor))
			if awgChecked and upChecked == False:
				self.ui.vsgNextSteps.setCurrentIndex(2)
				self.ui.upButton_vsg.setStyleSheet(greyHover)
				self.ui.upButton_vsg.setCursor(QCursor(Qt.PointingHandCursor))
			else:
				self.ui.vsgNextSteps.setCurrentIndex(1)
		if i == 3: # AWG & PSG
			self.ui.vsgWorkflows.setCurrentIndex(3)
			setVSGWorkflows(self,2)
			self.ui.up_psg_next.setCurrentIndex(1) 
			if psgChecked == False:
				self.ui.vsaButton_vsg.setStyleSheet(greyButton)
				self.ui.vsaButton_vsg.setCursor(QCursor(Qt.ArrowCursor))
			if awgChecked and psgChecked == False:
				self.ui.vsgNextSteps.setCurrentIndex(3)
				self.ui.psgButton_vsg.setStyleSheet(greyHover)
				self.ui.psgButton_vsg.setCursor(QCursor(Qt.PointingHandCursor))
			else:
				self.ui.vsgNextSteps.setCurrentIndex(1)
	elif i == 4: # VSG
		self.ui.vsgEquipStack.setCurrentIndex(1)
		self.ui.vsgEquipStackAdv.setCurrentIndex(1)
		self.ui.vsgNextSteps.setCurrentIndex(4)
		self.ui.vsgWorkflows.setCurrentIndex(4)
		setVSGWorkflows(self,3)
		self.ui.vsaButton_vsg.setStyleSheet(greyButton)
		self.ui.vsaButton_vsg.setCursor(QCursor(Qt.ArrowCursor))
		if vsgChecked:
			self.ui.vsgNextSteps.setCurrentIndex(5)
			self.ui.vsaButton_vsg.setStyleSheet(greyHover)
			self.ui.vsaButton_vsg.setCursor(QCursor(Qt.PointingHandCursor))
		else:
			self.ui.vsgNextSteps.setCurrentIndex(4)

def displayVsa(self,unsetBox,greyHover,greyButton):	
	self.ui.vsaEquipTabs.setTabEnabled(1, True)
	vsaIdx = self.ui.vsaType.currentIndex()
	averaging = self.ui.averagingEnable.currentIndex()
	demod = self.ui.demodulationEnable.currentIndex()
	scopeChecked = self.ui.scopeSet.isChecked()
	uxaChecked = self.ui.uxaSet.isChecked()
	pxaChecked = self.ui.pxaSet.isChecked()
	digChecked = self.ui.digSet.isChecked()
	
	if averaging == 0:
		self.ui.noAveragesField_scope.setEnabled(False)
		self.ui.noAveragesLabel_scope.setEnabled(False)
		self.ui.noAveragesField_sa.setEnabled(False)
		self.ui.noAveragesLabel_sa.setEnabled(False)
	elif averaging == 1:
		self.ui.noAveragesField_scope.setEnabled(True)
		self.ui.noAveragesLabel_scope.setEnabled(True)
		self.ui.noAveragesField_sa.setEnabled(True)
		self.ui.noAveragesLabel_sa.setEnabled(True)
	elif averaging == 2:
		self.ui.noAveragesField_scope.setEnabled(False)
		self.ui.noAveragesLabel_scope.setEnabled(False)
		self.ui.noAveragesField_sa.setEnabled(False)
		self.ui.noAveragesLabel_sa.setEnabled(False)
	
	if vsaIdx == 0:
		self.ui.vsaWorkflow.setCurrentIndex(0)
		self.ui.vsaEquipStack.setCurrentIndex(3)
		self.ui.vsaAdvancedStack.setCurrentIndex(0)
		self.ui.vsaNextStack.setCurrentIndex(0)
		self.ui.vsaWorkflow_vsg.setCurrentIndex(0)
		self.ui.vsaWorkflow_up.setCurrentIndex(0)
		self.ui.averagingEnableLabel.setEnabled(True)
		self.ui.averagingEnable.setEnabled(True)
		self.ui.scopeEquip_homo.setEnabled(False)
	elif demod == 0:
		self.ui.uxaMod.setEnabled(False)
		self.ui.digMod.setEnabled(False)
		self.ui.scopeMod.setEnabled(False)
		if vsaIdx == 1:
			self.ui.vsaWorkflow.setCurrentIndex(1)
			
			#removes advance tab
			self.ui.vsaEquipTabs.setTabEnabled(1, False)
			
			self.ui.single_vsa_stack.setCurrentIndex(0)
			self.ui.vsaEquipStack.setCurrentIndex(1)
			self.ui.vsaAdvancedStack.setCurrentIndex(1)
			self.ui.vsaMeasGenStack.setCurrentIndex(0)
			self.ui.vsaWorkflow_vsaMeas.setCurrentIndex(0)
			self.ui.vsaWorkflow_vsgMeas.setCurrentIndex(0)
			self.ui.downStack_vsaMeas.setCurrentIndex(0)
			self.ui.vsaMeasParamTabs.setTabEnabled(1,False)
			self.ui.averagingEnableLabel.setEnabled(True)
			self.ui.averagingEnable.setEnabled(True)
			setVSAWorkflowsNoModNoDown(self,1,0,False)
			self.ui.scopeEquip_homo.setEnabled(True)
		elif vsaIdx == 2:
			self.ui.vsaWorkflow.setCurrentIndex(1)
			#removes advance tab
			self.ui.vsaEquipTabs.setTabEnabled(1, False)
			self.ui.single_vsa_stack.setCurrentIndex(1)
			self.ui.vsaEquipStack.setCurrentIndex(2)
			self.ui.vsaAdvancedStack.setCurrentIndex(1)
			self.ui.vsaMeasGenStack.setCurrentIndex(1)
			self.ui.vsaWorkflow_vsaMeas.setCurrentIndex(0)
			self.ui.downStack_vsaMeas.setCurrentIndex(0)
			self.ui.vsaMeasParamTabs.setTabEnabled(1,False)
			self.ui.vsaWorkflow_vsgMeas.setCurrentIndex(0)
			self.ui.averagingEnableLabel.setEnabled(False)
			self.ui.averagingEnable.setEnabled(False)
			setVSAWorkflowsNoModNoDown(self,1,1,False)
			self.ui.scopeEquip_homo.setEnabled(False)
		elif vsaIdx == 3:
			self.ui.vsaWorkflow.setCurrentIndex(1)
			self.ui.single_vsa_stack.setCurrentIndex(2)
			self.ui.vsaEquipStack.setCurrentIndex(0)
			self.ui.uxa_pxa_titleStack.setCurrentIndex(0)
			self.ui.vsaAdvancedStack.setCurrentIndex(2)
			self.ui.uxa_pxa_titleStackAdv.setCurrentIndex(0)
			self.ui.uxa_pxa_set.setCurrentIndex(0)
			self.ui.vsaMeasGenStack.setCurrentIndex(0)
			self.ui.vsaWorkflow_vsaMeas.setCurrentIndex(0)
			self.ui.downStack_vsaMeas.setCurrentIndex(0)
			self.ui.vsaMeasParamTabs.setTabEnabled(1,False)
			self.ui.vsaWorkflow_vsgMeas.setCurrentIndex(0)
			self.ui.averagingEnableLabel.setEnabled(True)
			self.ui.averagingEnable.setEnabled(True)
			setVSAWorkflowsNoModNoDown(self,1,2,True)
			self.ui.scopeEquip_homo.setEnabled(False)
		elif vsaIdx == 4:
			self.ui.vsaWorkflow.setCurrentIndex(1)
			self.ui.single_vsa_stack.setCurrentIndex(3)
			self.ui.vsaEquipStack.setCurrentIndex(0)
			self.ui.uxa_pxa_titleStack.setCurrentIndex(1)
			self.ui.vsaAdvancedStack.setCurrentIndex(2)
			self.ui.uxa_pxa_titleStackAdv.setCurrentIndex(1)
			self.ui.uxa_pxa_set.setCurrentIndex(1)
			self.ui.vsaMeasGenStack.setCurrentIndex(0)
			self.ui.vsaWorkflow_vsaMeas.setCurrentIndex(0)
			self.ui.downStack_vsaMeas.setCurrentIndex(0)
			self.ui.vsaMeasParamTabs.setTabEnabled(1,False)
			self.ui.vsaWorkflow_vsgMeas.setCurrentIndex(0)
			self.ui.averagingEnableLabel.setEnabled(True)
			self.ui.averagingEnable.setEnabled(True)
			setVSAWorkflowsNoModNoDown(self,1,3,True)
			self.ui.scopeEquip_homo.setEnabled(False)
		elif vsaIdx == 5:
			self.ui.vsaEquipStack.setCurrentIndex(1)
			#removes advance tab
			self.ui.vsaEquipTabs.setTabEnabled(1, False)
			self.ui.vsaAdvancedStack.setCurrentIndex(1)
			self.ui.vsaMeasGenStack.setCurrentIndex(0)
			self.ui.vsaWorkflow_vsaMeas.setCurrentIndex(1)
			self.ui.downStack_vsaMeas.setCurrentIndex(1)
			self.ui.vsaMeasParamTabs.setTabEnabled(1,True)
			self.ui.vsaWorkflow_vsgMeas.setCurrentIndex(1)
			self.ui.averagingEnableLabel.setEnabled(True)
			self.ui.averagingEnable.setEnabled(True)
			setVSAWorkflowsNoModWithDown(self,4,0,1,False)
			self.ui.single_down_vsaMeas_stack.setCurrentIndex(1)
			self.ui.scopeEquip_homo.setEnabled(True)
		elif vsaIdx == 6:
			self.ui.vsaEquipStack.setCurrentIndex(2)
			#removes advance tab
			self.ui.vsaEquipTabs.setTabEnabled(1, False)
			self.ui.vsaAdvancedStack.setCurrentIndex(1)
			self.ui.vsaMeasGenStack.setCurrentIndex(1)
			self.ui.vsaWorkflow_vsaMeas.setCurrentIndex(1)
			self.ui.downStack_vsaMeas.setCurrentIndex(1)
			self.ui.vsaMeasParamTabs.setTabEnabled(1,True)
			self.ui.vsaWorkflow_vsgMeas.setCurrentIndex(1)
			self.ui.averagingEnableLabel.setEnabled(False)
			self.ui.averagingEnable.setEnabled(False)
			setVSAWorkflowsNoModWithDown(self,4,0,0,False)
			self.ui.single_down_vsaMeas_stack.setCurrentIndex(0)
			self.ui.scopeEquip_homo.setEnabled(False)
	elif demod == 1:
		self.ui.uxaMod.setEnabled(True)
		self.ui.digMod.setEnabled(True)
		self.ui.scopeMod.setEnabled(True)	
		if vsaIdx == 1:
		#removes advance tab
			self.ui.vsaEquipTabs.setTabEnabled(1, False)
			digOrScopeSet(self,1,averaging,demod,scopeChecked,greyHover,unsetBox,vsaIdx)
			self.ui.vsaWorkflow.setCurrentIndex(2)
			self.ui.single_mod_vsa_stack.setCurrentIndex(0)
			self.ui.vsaMeasGenStack.setCurrentIndex(0)
			self.ui.vsaWorkflow_vsaMeas.setCurrentIndex(0)
			self.ui.downStack_vsaMeas.setCurrentIndex(0)
			self.ui.vsaMeasParamTabs.setTabEnabled(1,False)
			self.ui.vsaWorkflow_vsgMeas.setCurrentIndex(0)
			self.ui.averagingEnableLabel.setEnabled(True)
			self.ui.averagingEnable.setEnabled(True)
			setVSAWorkflowsWithModNoDown(self,2,0,False)
			self.ui.scopeEquip_homo.setEnabled(True)
		elif vsaIdx == 2:
		#removes advance tab
			self.ui.vsaEquipTabs.setTabEnabled(1, False)
			digOrScopeSet(self,2,averaging,demod,digChecked,greyHover,unsetBox,vsaIdx)
			self.ui.vsaWorkflow.setCurrentIndex(2)
			self.ui.single_mod_vsa_stack.setCurrentIndex(1)
			self.ui.vsaMeasGenStack.setCurrentIndex(1)
			self.ui.vsaWorkflow_vsaMeas.setCurrentIndex(0)
			self.ui.downStack_vsaMeas.setCurrentIndex(0)
			self.ui.vsaMeasParamTabs.setTabEnabled(1,False)
			self.ui.vsaWorkflow_vsgMeas.setCurrentIndex(0)
			self.ui.averagingEnableLabel.setEnabled(False)
			self.ui.averagingEnable.setEnabled(False)
			setVSAWorkflowsWithModNoDown(self,2,1,False)
			self.ui.scopeEquip_homo.setEnabled(False)
		elif vsaIdx == 3:
			uxaOrPxaSet(self,0,averaging,demod,uxaChecked,greyHover,unsetBox)
			self.ui.vsaWorkflow.setCurrentIndex(2)
			self.ui.single_mod_vsa_stack.setCurrentIndex(2)
			self.ui.vsaMeasGenStack.setCurrentIndex(0)
			self.ui.vsaWorkflow_vsaMeas.setCurrentIndex(0)
			self.ui.downStack_vsaMeas.setCurrentIndex(0)
			self.ui.vsaMeasParamTabs.setTabEnabled(1,False)
			self.ui.vsaWorkflow_vsgMeas.setCurrentIndex(0)
			self.ui.averagingEnableLabel.setEnabled(True)
			self.ui.averagingEnable.setEnabled(True)
			setVSAWorkflowsWithModNoDown(self,2,2,True)
			self.ui.scopeEquip_homo.setEnabled(False)
		elif vsaIdx == 4:
			uxaOrPxaSet(self,1,averaging,demod,pxaChecked,greyHover,unsetBox)
			self.ui.vsaWorkflow.setCurrentIndex(2)
			self.ui.single_mod_vsa_stack.setCurrentIndex(3)
			self.ui.vsaMeasGenStack.setCurrentIndex(0)
			self.ui.vsaWorkflow_vsaMeas.setCurrentIndex(0)
			self.ui.downStack_vsaMeas.setCurrentIndex(0)
			self.ui.vsaMeasParamTabs.setTabEnabled(1,False)
			self.ui.vsaWorkflow_vsgMeas.setCurrentIndex(0)
			self.ui.averagingEnableLabel.setEnabled(True)
			self.ui.averagingEnable.setEnabled(True)
			setVSAWorkflowsWithModNoDown(self,2,3,True)
			self.ui.scopeEquip_homo.setEnabled(False)
		elif vsaIdx == 5:
		#removes advance tab
			self.ui.vsaEquipTabs.setTabEnabled(1, False)
			digOrScopeDownSet(self,1,averaging,demod,scopeChecked,greyButton,greyHover,unsetBox,vsaIdx)
			self.ui.vsaMeasGenStack.setCurrentIndex(0)
			self.ui.vsaWorkflow_vsaMeas.setCurrentIndex(1)
			self.ui.downStack_vsaMeas.setCurrentIndex(1)
			self.ui.vsaMeasParamTabs.setTabEnabled(1,True)
			self.ui.vsaWorkflow_vsgMeas.setCurrentIndex(1)
			self.ui.averagingEnableLabel.setEnabled(True)
			self.ui.averagingEnable.setEnabled(True)
			setVSAWorkflowsWithModWithDown(self,3,1,0,False)
			self.ui.single_down_vsaMeas_stack.setCurrentIndex(1)
			self.ui.scopeEquip_homo.setEnabled(True)
		elif vsaIdx == 6:
		#removes advance tab
			self.ui.vsaEquipTabs.setTabEnabled(1, False)
			digOrScopeDownSet(self,2,averaging,demod,digChecked,greyButton,greyHover,unsetBox,vsaIdx)
			self.ui.vsaMeasGenStack.setCurrentIndex(1)
			self.ui.vsaWorkflow_vsaMeas.setCurrentIndex(1)
			self.ui.downStack_vsaMeas.setCurrentIndex(1)
			self.ui.vsaMeasParamTabs.setTabEnabled(1,True)
			self.ui.vsaWorkflow_vsgMeas.setCurrentIndex(1)
			self.ui.averagingEnableLabel.setEnabled(False)
			self.ui.averagingEnable.setEnabled(False)
			setVSAWorkflowsWithModWithDown(self,3,1,1,False)
			self.ui.single_down_vsaMeas_stack.setCurrentIndex(0)
			self.ui.scopeEquip_homo.setEnabled(False)
	elif demod == 2:
		self.ui.uxaMod.setEnabled(False)
		self.ui.digMod.setEnabled(False)
		self.ui.scopeMod.setEnabled(False)
		if vsaIdx == 1:
			#removes advance tab
			self.ui.vsaEquipTabs.setTabEnabled(1, False)
			digOrScopeSet(self,1,averaging,demod,scopeChecked,greyHover,unsetBox,vsaIdx)
			self.ui.vsaWorkflow.setCurrentIndex(1)
			self.ui.single_vsa_stack.setCurrentIndex(0)
			self.ui.vsaMeasGenStack.setCurrentIndex(0)
			self.ui.vsaWorkflow_vsaMeas.setCurrentIndex(0)
			self.ui.downStack_vsaMeas.setCurrentIndex(0)
			self.ui.vsaMeasParamTabs.setTabEnabled(1,False)
			self.ui.vsaWorkflow_vsgMeas.setCurrentIndex(0)
			self.ui.averagingEnableLabel.setEnabled(True)
			self.ui.averagingEnable.setEnabled(True)
			setVSAWorkflowsNoModNoDown(self,1,0,False)
			self.ui.scopeEquip_homo.setEnabled(True)
		elif vsaIdx == 2:
			#removes advance tab
			self.ui.vsaEquipTabs.setTabEnabled(1, False)
			digOrScopeSet(self,2,averaging,demod,digChecked,greyHover,unsetBox,vsaIdx)
			self.ui.vsaWorkflow.setCurrentIndex(1)
			self.ui.single_vsa_stack.setCurrentIndex(1)
			self.ui.vsaMeasGenStack.setCurrentIndex(1)
			self.ui.vsaWorkflow_vsaMeas.setCurrentIndex(0)
			self.ui.downStack_vsaMeas.setCurrentIndex(0)
			self.ui.vsaMeasParamTabs.setTabEnabled(1,False)
			self.ui.vsaWorkflow_vsgMeas.setCurrentIndex(0)
			self.ui.averagingEnableLabel.setEnabled(False)
			self.ui.averagingEnable.setEnabled(False)
			setVSAWorkflowsNoModNoDown(self,1,1,False)
			self.ui.scopeEquip_homo.setEnabled(False)
		elif vsaIdx == 3:
			uxaOrPxaSet(self,0,averaging,demod,uxaChecked,greyHover,unsetBox)
			self.ui.vsaWorkflow.setCurrentIndex(1)
			self.ui.single_vsa_stack.setCurrentIndex(2)
			self.ui.vsaMeasGenStack.setCurrentIndex(0)
			self.ui.vsaWorkflow_vsaMeas.setCurrentIndex(0)
			self.ui.downStack_vsaMeas.setCurrentIndex(0)
			self.ui.vsaMeasParamTabs.setTabEnabled(1,False)
			self.ui.vsaWorkflow_vsgMeas.setCurrentIndex(0)
			self.ui.averagingEnableLabel.setEnabled(True)
			self.ui.averagingEnable.setEnabled(True)
			setVSAWorkflowsNoModNoDown(self,1,2,True)
			self.ui.scopeEquip_homo.setEnabled(False)
		elif vsaIdx == 4:

			uxaOrPxaSet(self,1,averaging,demod,pxaChecked,greyHover,unsetBox)
			self.ui.vsaWorkflow.setCurrentIndex(1)
			self.ui.single_vsa_stack.setCurrentIndex(3)
			self.ui.vsaMeasGenStack.setCurrentIndex(0)
			self.ui.vsaWorkflow_vsaMeas.setCurrentIndex(0)
			self.ui.downStack_vsaMeas.setCurrentIndex(0)
			self.ui.vsaMeasParamTabs.setTabEnabled(1,False)
			self.ui.vsaWorkflow_vsgMeas.setCurrentIndex(0)
			self.ui.averagingEnableLabel.setEnabled(True)
			self.ui.averagingEnable.setEnabled(True)
			setVSAWorkflowsNoModNoDown(self,1,3,True)
			self.ui.scopeEquip_homo.setEnabled(False)
		elif vsaIdx == 5:
		#removes advance tab
			self.ui.vsaEquipTabs.setTabEnabled(1, False)
			digOrScopeDownSet(self,1,averaging,demod,scopeChecked,greyButton,greyHover,unsetBox,vsaIdx)
			self.ui.vsaMeasGenStack.setCurrentIndex(0)
			self.ui.vsaWorkflow_vsaMeas.setCurrentIndex(1)
			self.ui.downStack_vsaMeas.setCurrentIndex(1)
			self.ui.vsaMeasParamTabs.setTabEnabled(1,True)
			self.ui.vsaWorkflow_vsgMeas.setCurrentIndex(1)
			self.ui.averagingEnableLabel.setEnabled(True)
			self.ui.averagingEnable.setEnabled(True)
			setVSAWorkflowsNoModWithDown(self,4,0,1,False)
			self.ui.single_down_vsaMeas_stack.setCurrentIndex(1)
			self.ui.scopeEquip_homo.setEnabled(True)
		elif vsaIdx == 6:	
		#removes advance tab
			self.ui.vsaEquipTabs.setTabEnabled(1, False)
			digOrScopeDownSet(self,2,averaging,demod,digChecked,greyButton,greyHover,unsetBox,vsaIdx)
			self.ui.vsaMeasGenStack.setCurrentIndex(1)
			self.ui.vsaWorkflow_vsaMeas.setCurrentIndex(1)
			self.ui.downStack_vsaMeas.setCurrentIndex(1)
			self.ui.vsaMeasParamTabs.setTabEnabled(1,True)
			self.ui.vsaWorkflow_vsgMeas.setCurrentIndex(1)
			self.ui.averagingEnableLabel.setEnabled(False)
			self.ui.averagingEnable.setEnabled(False)
			setVSAWorkflowsNoModWithDown(self,4,0,0,False)
			self.ui.single_down_vsaMeas_stack.setCurrentIndex(0)	
			self.ui.scopeEquip_homo.setEnabled(False)
				
# apply changes from one demod box to all demod boxes
def copyDemod(self,changedModField,replacedFieldOne,replacedFieldTwo):
	value = changedModField.text()
	replacedFieldOne.blockSignals(True)
	replacedFieldTwo.blockSignals(True)
	replacedFieldOne.setText(value)
	replacedFieldTwo.setText(value)
	replacedFieldOne.blockSignals(False)
	replacedFieldTwo.blockSignals(False)
	
def displaySa(self,buttonSelected,buttonFocus,buttonHover,greyHover,greyButton):

	saIdx = self.ui.saType.currentIndex()
	saChecked = self.ui.saSet.isChecked()
	self.ui.saEquipTabs.setTabEnabled(0, True)
	self.ui.saEquipTabs.setTabEnabled(1, True)
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
			set.setPrevSAButtons(self,greyHover,Qt.PointingHandCursor,greyButton,Qt.ArrowCursor)
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
			set.setPrevSAButtons(self,greyHover,Qt.PointingHandCursor,greyButton,Qt.ArrowCursor)
	elif saIdx == 3:
		#disables the parameter tabs since index 3 is no sa 
		self.ui.saEquipTabs.setTabEnabled(1, False)
		self.ui.saNextStack.setCurrentIndex(0)
		self.ui.meterNextStack.setCurrentIndex(2)
		self.ui.downNextStack.setCurrentIndex(3)
		self.ui.vsaNextStack.setCurrentIndex(5)
		self.ui.up_psg_next.setCurrentIndex(7)
		self.ui.vsgNextSteps.setCurrentIndex(9)
		self.ui.saEquipStandardStack.setCurrentIndex(2)
		self.ui.saEquipAdvStack.setCurrentIndex(2)
		self.ui.saButton_sa.setStyleSheet(buttonFocus)
		self.ui.saButton_sa_2.setStyleSheet(buttonFocus)
		self.ui.saButton_sa_3.setStyleSheet(buttonFocus)
		self.ui.saButton_sa_4.setStyleSheet(buttonFocus)
		set.setPrevSAButtons(self,buttonHover,Qt.PointingHandCursor,greyHover,Qt.PointingHandCursor)
		
def enableChannel(self):
	numberChannelsP1 = self.ui.noChannels_p1.currentIndex()
	numberChannelsP2 = self.ui.noChannels_p2.currentIndex()
	numberChannelsP3 = self.ui.noChannels_p3.currentIndex()
	
	if numberChannelsP1 == 0:
		self.ui.p1c1Equip.setEnabled(False)
		self.ui.p1c2Equip.setEnabled(False)
		self.ui.p1c3Equip.setEnabled(False)
		self.ui.p1c4Equip.setEnabled(False)
	elif numberChannelsP1 == 1:
		self.ui.p1c1Equip.setEnabled(True)
		self.ui.p1c2Equip.setEnabled(False)
		self.ui.p1c3Equip.setEnabled(False)
		self.ui.p1c4Equip.setEnabled(False)
	elif numberChannelsP1 == 2:
		self.ui.p1c1Equip.setEnabled(True)
		self.ui.p1c2Equip.setEnabled(True)
		self.ui.p1c3Equip.setEnabled(False)
		self.ui.p1c4Equip.setEnabled(False)
	elif numberChannelsP1 == 3:
		self.ui.p1c1Equip.setEnabled(True)
		self.ui.p1c2Equip.setEnabled(True)
		self.ui.p1c3Equip.setEnabled(True)
		self.ui.p1c4Equip.setEnabled(False)
	elif numberChannelsP1 == 4:
		self.ui.p1c1Equip.setEnabled(True)
		self.ui.p1c2Equip.setEnabled(True)
		self.ui.p1c3Equip.setEnabled(True)
		self.ui.p1c4Equip.setEnabled(True)
		
	if numberChannelsP2 == 0:
		self.ui.p2c1Equip.setEnabled(False)
		self.ui.p2c2Equip.setEnabled(False)
		self.ui.p2c3Equip.setEnabled(False)
		self.ui.p2c4Equip.setEnabled(False)
	elif numberChannelsP2 == 1:
		self.ui.p2c1Equip.setEnabled(True)
		self.ui.p2c2Equip.setEnabled(False)
		self.ui.p2c3Equip.setEnabled(False)
		self.ui.p2c4Equip.setEnabled(False)
	elif numberChannelsP2 == 2:
		self.ui.p2c1Equip.setEnabled(True)
		self.ui.p2c2Equip.setEnabled(True)
		self.ui.p2c3Equip.setEnabled(False)
		self.ui.p2c4Equip.setEnabled(False)
	elif numberChannelsP2 == 3:
		self.ui.p2c1Equip.setEnabled(True)
		self.ui.p2c2Equip.setEnabled(True)
		self.ui.p2c3Equip.setEnabled(True)
		self.ui.p2c4Equip.setEnabled(False)
	elif numberChannelsP2 == 4:
		self.ui.p2c1Equip.setEnabled(True)
		self.ui.p2c2Equip.setEnabled(True)
		self.ui.p2c3Equip.setEnabled(True)
		self.ui.p2c4Equip.setEnabled(True)
		
	if numberChannelsP3 == 0:
		self.ui.p3c1Equip.setEnabled(False)
		self.ui.p3c2Equip.setEnabled(False)
		self.ui.p3c3Equip.setEnabled(False)
		self.ui.p3c4Equip.setEnabled(False)
	elif numberChannelsP3 == 1:
		self.ui.p3c1Equip.setEnabled(True)
		self.ui.p3c2Equip.setEnabled(False)
		self.ui.p3c3Equip.setEnabled(False)
		self.ui.p3c4Equip.setEnabled(False)
	elif numberChannelsP3 == 2:
		self.ui.p3c1Equip.setEnabled(True)
		self.ui.p3c2Equip.setEnabled(True)
		self.ui.p3c3Equip.setEnabled(False)
		self.ui.p3c4Equip.setEnabled(False)
	elif numberChannelsP3 == 3:
		self.ui.p3c1Equip.setEnabled(True)
		self.ui.p3c2Equip.setEnabled(True)
		self.ui.p3c3Equip.setEnabled(True)
		self.ui.p3c4Equip.setEnabled(False)
	elif numberChannelsP3 == 4:
		self.ui.p3c1Equip.setEnabled(True)
		self.ui.p3c2Equip.setEnabled(True)
		self.ui.p3c3Equip.setEnabled(True)
		self.ui.p3c4Equip.setEnabled(True)
		
def enableSupplyOne(self):
	idx = self.ui.p1Enabled.currentIndex()
	numberChannels = self.ui.noChannels_p1.currentIndex()
	
	if idx == 0 or idx == 1:
		self.ui.p1Channels.setEnabled(True)
		self.ui.noChannels_p1.setEnabled(True)
		if numberChannels == 0:
			self.ui.p1c1Equip.setEnabled(False)
			self.ui.p1c2Equip.setEnabled(False)
			self.ui.p1c3Equip.setEnabled(False)
			self.ui.p1c4Equip.setEnabled(False)
		elif numberChannels == 1:
			self.ui.p1c1Equip.setEnabled(True)
			self.ui.p1c2Equip.setEnabled(False)
			self.ui.p1c3Equip.setEnabled(False)
			self.ui.p1c4Equip.setEnabled(False)
		elif numberChannels == 2:
			self.ui.p1c1Equip.setEnabled(True)
			self.ui.p1c2Equip.setEnabled(True)
			self.ui.p1c3Equip.setEnabled(False)
			self.ui.p1c4Equip.setEnabled(False)
		elif numberChannels == 3:
			self.ui.p1c1Equip.setEnabled(True)
			self.ui.p1c2Equip.setEnabled(True)
			self.ui.p1c3Equip.setEnabled(True)
			self.ui.p1c4Equip.setEnabled(False)
		elif numberChannels == 4:
			self.ui.p1c1Equip.setEnabled(True)
			self.ui.p1c2Equip.setEnabled(True)
			self.ui.p1c3Equip.setEnabled(True)
			self.ui.p1c4Equip.setEnabled(True)
	elif idx == 2:
		self.ui.p1Channels.setEnabled(False)
		self.ui.noChannels_p1.setEnabled(False)
		self.ui.p1c1Equip.setEnabled(False)
		self.ui.p1c2Equip.setEnabled(False)
		self.ui.p1c3Equip.setEnabled(False)
		self.ui.p1c4Equip.setEnabled(False)
		
def enableSupplyTwo(self):
	idx = self.ui.p2Enabled.currentIndex()
	numberChannels = self.ui.noChannels_p2.currentIndex()
	
	if idx == 0 or idx == 1:
		self.ui.p2Channels.setEnabled(True)
		self.ui.noChannels_p2.setEnabled(True)
		if numberChannels == 0:
			self.ui.p2c1Equip.setEnabled(False)
			self.ui.p2c2Equip.setEnabled(False)
			self.ui.p2c3Equip.setEnabled(False)
			self.ui.p2c4Equip.setEnabled(False)
		elif numberChannels == 1:
			self.ui.p2c1Equip.setEnabled(True)
			self.ui.p2c2Equip.setEnabled(False)
			self.ui.p2c3Equip.setEnabled(False)
			self.ui.p2c4Equip.setEnabled(False)
		elif numberChannels == 2:
			self.ui.p2c1Equip.setEnabled(True)
			self.ui.p2c2Equip.setEnabled(True)
			self.ui.p2c3Equip.setEnabled(False)
			self.ui.p2c4Equip.setEnabled(False)
		elif numberChannels == 3:
			self.ui.p2c1Equip.setEnabled(True)
			self.ui.p2c2Equip.setEnabled(True)
			self.ui.p2c3Equip.setEnabled(True)
			self.ui.p2c4Equip.setEnabled(False)
		elif numberChannels == 4:
			self.ui.p2c1Equip.setEnabled(True)
			self.ui.p2c2Equip.setEnabled(True)
			self.ui.p2c3Equip.setEnabled(True)
			self.ui.p2c4Equip.setEnabled(True)
	elif idx == 2:
		self.ui.p2Channels.setEnabled(False)
		self.ui.noChannels_p2.setEnabled(False)
		self.ui.p2c1Equip.setEnabled(False)
		self.ui.p2c2Equip.setEnabled(False)
		self.ui.p2c3Equip.setEnabled(False)
		self.ui.p2c4Equip.setEnabled(False)

def enableSupplyThree(self):
	idx = self.ui.p3Enabled.currentIndex()
	numberChannels = self.ui.noChannels_p3.currentIndex()
	
	if idx == 0 or idx == 1:
		self.ui.p3Channels.setEnabled(True)
		self.ui.noChannels_p3.setEnabled(True)
		if numberChannels == 0:
			self.ui.p3c1Equip.setEnabled(False)
			self.ui.p3c2Equip.setEnabled(False)
			self.ui.p3c3Equip.setEnabled(False)
			self.ui.p3c4Equip.setEnabled(False)
		elif numberChannels == 1:
			self.ui.p3c1Equip.setEnabled(True)
			self.ui.p3c2Equip.setEnabled(False)
			self.ui.p3c3Equip.setEnabled(False)
			self.ui.p3c4Equip.setEnabled(False)
		elif numberChannels == 2:
			self.ui.p3c1Equip.setEnabled(True)
			self.ui.p3c2Equip.setEnabled(True)
			self.ui.p3c3Equip.setEnabled(False)
			self.ui.p3c4Equip.setEnabled(False)
		elif numberChannels == 3:
			self.ui.p3c1Equip.setEnabled(True)
			self.ui.p3c2Equip.setEnabled(True)
			self.ui.p3c3Equip.setEnabled(True)
			self.ui.p3c4Equip.setEnabled(False)
		elif numberChannels == 4:
			self.ui.p3c1Equip.setEnabled(True)
			self.ui.p3c2Equip.setEnabled(True)
			self.ui.p3c3Equip.setEnabled(True)
			self.ui.p3c4Equip.setEnabled(True)
	elif idx == 2:
		self.ui.p3Channels.setEnabled(False)
		self.ui.noChannels_p3.setEnabled(False)
		self.ui.p3c1Equip.setEnabled(False)
		self.ui.p3c2Equip.setEnabled(False)
		self.ui.p3c3Equip.setEnabled(False)
		self.ui.p3c4Equip.setEnabled(False)

def enableVSACalFile(self,boxDone,boxUnset):
	checked = self.ui.generateVSACalCheck.isChecked()
	setChecked = self.ui.downSetVSAMeas.isChecked()
	setRunChecked = self.ui.set_run_vsa.isChecked()
	
	#enabling subrate flag when generate vsacal file is enabled
	self.ui.subrateLabel_comb.setEnabled(checked)
	self.ui.subrateField_comb.setEnabled(checked)
	self.ui.rfSpacingLabel_comb.setEnabled(checked)
	self.ui.rfSpacingField_comb.setEnabled(checked)
	self.ui.ifSpacingLabel_comb.setEnabled(checked)
	self.ui.ifSpacingField_comb.setEnabled(checked)
	self.ui.refFileLabel_comb.setEnabled(checked)
	self.ui.refFileField_comb.setEnabled(checked)
	self.ui.rfCenterFreqLabel_comb.setEnabled(checked)
	self.ui.rfCenterFreqField_comb.setEnabled(checked)
	self.ui.rfCalStartFreqLabel_comb.setEnabled(checked)
	self.ui.rfCalStartFreqField_comb.setEnabled(checked)
	self.ui.rfCalStopFreqLabel_comb.setEnabled(checked)
	self.ui.rfCalStopFreqField_comb.setEnabled(checked)
	self.ui.loFreqOffsetLabel_comb.setEnabled(checked)
	self.ui.loFreqOffsetField_comb.setEnabled(checked)
	self.ui.vsaCalSaveLocLabel_comb.setEnabled(checked)
	self.ui.vsaCalSaveLocField_comb.setEnabled(checked)
	self.ui.filePushButton_2.setEnabled(checked)
	self.ui.filePushButton_19.setEnabled(checked)
	self.ui.freqResField_comb.setEnabled(checked)
	self.ui.freqResLabel_comb.setEnabled(checked)
	self.ui.despurFlagField_comb.setEnabled(checked)
	self.ui.despurFlagLabel_comb.setEnabled(checked)
	self.ui.spurStartField_comb.setEnabled(checked)
	self.ui.spurStartLabel_comb.setEnabled(checked)
	self.ui.spurSpacingField_comb.setEnabled(checked)
	self.ui.spurSpacingLabel_comb.setEnabled(checked)
	self.ui.spurEndField_comb.setEnabled(checked)
	self.ui.spurEndLabel_comb.setEnabled(checked)
	self.ui.smoothFlagField_comb.setEnabled(checked)
	self.ui.smoothFlagLabel_comb.setEnabled(checked)
	self.ui.smoothOrderField_comb.setEnabled(checked)
	self.ui.smoothOrderLabel_comb.setEnabled(checked)
	self.ui.rxEquip_vsaMeas.setEnabled(checked)
	self.ui.trigEquip_vsaMeas.setEnabled(checked)
		
	if checked:
		self.ui.vsaCalFileLabel_comb.setEnabled(False)
		self.ui.vsaCalFileField_comb.setEnabled(False)
		self.ui.filePushButton.setEnabled(False)
		self.ui.vsaMeasRunStack.setCurrentIndex(0)
		if setRunChecked:
			self.ui.combEquip_vsaMeas.setStyleSheet(boxDone)
		else:
			self.ui.combEquip_vsaMeas.setStyleSheet(boxUnset)
	else:
		self.ui.vsaCalFileLabel_comb.setEnabled(True)
		self.ui.vsaCalFileField_comb.setEnabled(True)
		self.ui.filePushButton.setEnabled(True)
		self.ui.vsaMeasRunStack.setCurrentIndex(1)
		if setChecked:
			self.ui.combEquip_vsaMeas.setStyleSheet(boxDone)
		else:
			self.ui.combEquip_vsaMeas.setStyleSheet(boxUnset)
			
def determineFrameTimeEnable(self,dropdown):
	idx = dropdown.currentIndex()
	if idx == 1 or idx == 0:
		self.ui.frameTime_vsaMeas.setEnabled(False)
		self.ui.frameTime_vsaMeas_2.setEnabled(False)
	elif idx == 2:
		self.ui.frameTime_vsaMeas.setEnabled(True)
		self.ui.frameTime_vsaMeas_2.setEnabled(True)

def displayVSGMeas(self):
	idx = self.ui.vsgCalType.currentIndex()
	vsgType = self.ui.vsgWorkflow_vsgMeas.currentIndex()
	
	if idx == 0:
		self.ui.awgParamsStack_vsgMeas.setCurrentIndex(0)
		self.ui.upParamsStack_vsgMeas.setCurrentIndex(0)
		self.ui.advParamsStack_vsgMeas.setCurrentIndex(0)
	elif idx == 1:
		if vsgType == 3:
			msg = QMessageBox(self)
			msg.setIcon(QMessageBox.Critical)
			msg.setWindowTitle('No AWG')
			msg.setText("It is not possible to perform this kind of VSG calibration when there is no AWG in the setup.")
			msg.setStandardButtons(QMessageBox.Ok)
			msg.exec_();
		else:
			self.ui.advParamsStack_vsgMeas.setCurrentIndex(1)
			self.ui.awgParamsStack_vsgMeas.setCurrentIndex(1)
			self.ui.upParamsStack_vsgMeas.setCurrentIndex(1)
	elif idx == 2:
		if vsgType == 0 or vsgType == 3:
			self.ui.vsgCalType.setCurrentIndex(0)
			msg = QMessageBox(self)
			msg.setIcon(QMessageBox.Critical)
			msg.setWindowTitle('No Upconverter')
			msg.setText("It is not possible to perform this kind of VSG calibration when there is no upconverter in the setup.")
			msg.setStandardButtons(QMessageBox.Ok)
			msg.exec_();
		else:
			self.ui.advParamsStack_vsgMeas.setCurrentIndex(2)
			self.ui.awgParamsStack_vsgMeas.setCurrentIndex(2)
			self.ui.upParamsStack_vsgMeas.setCurrentIndex(2)
	elif idx == 3:
		if vsgType == 0 or vsgType == 3:
			self.ui.vsgCalType.setCurrentIndex(0)
			msg = QMessageBox(self)
			msg.setIcon(QMessageBox.Critical)
			msg.setWindowTitle('No Upconverter')
			msg.setText("It is not possible to perform this kind of VSG calibration when there is no upconverter in the setup.")
			msg.setStandardButtons(QMessageBox.Ok)
			msg.exec_();
		else:
			self.ui.advParamsStack_vsgMeas.setCurrentIndex(2)
			self.ui.awgParamsStack_vsgMeas.setCurrentIndex(2)
			self.ui.upParamsStack_vsgMeas.setCurrentIndex(3)
	elif idx == 4:
		self.ui.advParamsStack_vsgMeas.setCurrentIndex(1)
		self.ui.awgParamsStack_vsgMeas.setCurrentIndex(2)
		self.ui.upParamsStack_vsgMeas.setCurrentIndex(1)

def enableExtClkFreq(self):
	idx = self.ui.refClockSorce_awg.currentIndex()
	if idx == 2 or idx == 4:
		self.ui.extRefFreq_awg.setEnabled(True)
		self.ui.extRefFreqLabel_awg.setEnabled(True)
		self.ui.sampleClockFreqLabel_awgCal_2.setEnabled(True)
		self.ui.sampleClockFreqLabel_awgCal.setEnabled(True)
		self.ui.sampleClockFreq_awgCal_2.setEnabled(True)
		self.ui.sampleClockFreq_awgCal.setEnabled(True)
	else:
		self.ui.extRefFreq_awg.setEnabled(False)
		self.ui.extRefFreqLabel_awg.setEnabled(False)
		self.ui.sampleClockFreqLabel_awgCal_2.setEnabled(False)
		self.ui.sampleClockFreqLabel_awgCal.setEnabled(False)
		self.ui.sampleClockFreq_awgCal_2.setEnabled(False)
		self.ui.sampleClockFreq_awgCal.setEnabled(False)
		
def enableChannelOptions(self):
	# 0 = Select, 1 = None, 2 = Channel 1, 3 = Channel 2
	iIdx = self.ui.iChannel_awg.currentIndex()
	qIdx = self.ui.qChannel_awg.currentIndex()
	if iIdx == qIdx and iIdx != 0 and iIdx != 1:
		msg = QMessageBox(self)
		msg.setIcon(QMessageBox.Critical)
		msg.setWindowTitle('Invalid Field Settings')
		msg.setText("Cannot set Channel 1 and Channel 2 to be the same signal part. Select 'None' for channel to output complete RF signal.")
		msg.setStandardButtons(QMessageBox.Ok)
		msg.exec_();
		
		self.ui.iChannel_awg.setCurrentIndex(0)
		self.ui.qChannel_awg.setCurrentIndex(0)
		
def disableTrigLevelVSA(self):
	trigSource = self.ui.trigSource_sa.currentIndex()
	if trigSource == 1 or trigSource == 2 or trigSource == 3:
		self.ui.trigLevelLabel_sa.setEnabled(True)
		self.ui.trigLevel_sa.setEnabled(True)
	elif trigSource == 0 or trigSource == 4:
		self.ui.trigLevelLabel_sa.setEnabled(False)
		self.ui.trigLevel_sa.setEnabled(False)
		
def disableTrigLevelSA(self):
	trigSource = self.ui.trigSource_spa.currentIndex()
	if trigSource == 1 or trigSource == 2:
		self.ui.trigLevelLabel_spa.setEnabled(True)
		self.ui.trigLevel_spa.setEnabled(True)
	elif trigSource == 0 or trigSource == 3:
		self.ui.trigLevelLabel_spa.setEnabled(False)
		self.ui.trigLevel_spa.setEnabled(False)
		
def enableAveragingSA(self):
	idx = self.ui.averaging_spa.currentIndex()
	if idx == 1:
		self.ui.avgCountLabel_spa.setEnabled(True)
		self.ui.avgCount_spa.setEnabled(True)
	elif idx == 2 or idx == 0:
		self.ui.avgCountLabel_spa.setEnabled(False)
		self.ui.avgCount_spa.setEnabled(False)
	
def clearErrors(self):
	layout = self.ui.errorLayout
	for i in reversed(range(layout.count())): 
		widgetToRemove = layout.itemAt(i).widget()
		# remove it from the layout list
		layout.removeWidget(widgetToRemove)
		# remove it from the gui
		widgetToRemove.setParent(None)
	
# def enableTraceAveragingSA(self):
	# idx = self.ui.traceAvg_spa.currentIndex()
	# if idx == 1:
		# self.ui.traceAvgCount_spa.setEnabled(True)
		# self.ui.taceAvgCountLabel_spa.setEnabled(True)
	# elif idx == 2 or idx == 0:
		# self.ui.traceAvgCount_spa.setEnabled(False)
		# self.ui.taceAvgCountLabel_spa.setEnabled(False)
	
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# functions called within parameterFunctions	

def setVSGWorkflows(self,idx):
	self.ui.vsgWorkflowForVSA.setCurrentIndex(idx)
	self.ui.vsgWorkflowForDown.setCurrentIndex(idx)
	self.ui.vsgWorkflow_meter.setCurrentIndex(idx)
	self.ui.vsgWorkflow_sa.setCurrentIndex(idx)
	self.ui.vsgWorkflow_power1.setCurrentIndex(idx)
	self.ui.vsgWorkflow_power3.setCurrentIndex(idx)
	self.ui.vsgWorkflow_vsaMeas.setCurrentIndex(idx)
	self.ui.vsgWorkflow_vsgMeas.setCurrentIndex(idx)
	
def setVSAWorkflowsWithModNoDown(self,idx,subidx,state):
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
	self.ui.single_vsaMeas_stack.setCurrentIndex(subidx)
	self.ui.single_vsgMeas_stack.setCurrentIndex(subidx)

def setVSAWorkflowsNoModNoDown(self,idx,subidx,state):
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
	self.ui.single_vsaMeas_stack.setCurrentIndex(subidx)
	self.ui.single_vsgMeas_stack.setCurrentIndex(subidx)
	
def setVSAWorkflowsNoModWithDown(self,idx,twoidx,subidx,state):
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
	self.ui.single_down_vsgMeas_stack.setCurrentIndex(subidx)
	
def setVSAWorkflowsWithModWithDown(self,idx,twoidx,subidx,state):
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
	self.ui.single_down_vsgMeas_stack.setCurrentIndex(subidx)
	
def uxaOrPxaSet(self,idx,averaging,demod,equipChecked,greyHover,unsetBox):	
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
		self.ui.meterButton_vsa.setStyleSheet(greyHover)
		self.ui.meterButton_vsa.setCursor(QCursor(Qt.PointingHandCursor))
	
def digOrScopeSet(self,idx,averaging,demod,equipChecked,greyHover,unsetBox,vsaIdx):
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
		self.ui.meterButton_vsa.setStyleSheet(greyHover)
		self.ui.meterButton_vsa.setCursor(QCursor(Qt.PointingHandCursor))

def digOrScopeDownSet(self,idx,averaging,demod,equipChecked,greyButton,greyHover,unsetBox,vsaIdx):	
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
		self.ui.meterButton_vsa.setStyleSheet(greyButton)
		self.ui.meterButton_vsa.setCursor(QCursor(Qt.ArrowCursor))
		self.ui.downButton_vsa.setStyleSheet(greyHover)
		self.ui.downButton_vsa_2.setStyleSheet(greyHover)
		self.ui.downButton_vsa.setCursor(QCursor(Qt.PointingHandCursor))
		self.ui.downButton_vsa_2.setCursor(QCursor(Qt.PointingHandCursor))