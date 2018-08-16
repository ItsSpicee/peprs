# parameterFunctions.py contains functions that are called when parameter values are chosen

from PyQt5.QtGui import (QCursor)
from PyQt5.QtCore import (Qt)
from PyQt5.QtWidgets import (QMessageBox)
import setParameters as set

# change what is shown in GUI based on which VSG instrument is selected from VSG Type dropdown
def displayVsg(self,greyHover,greyButton):
	awgChecked = self.ui.awgSetGeneral.isChecked()
	vsgChecked = self.ui.vsgSetGeneral.isChecked()
	upChecked = self.ui.upSet.isChecked()
	psgChecked = self.ui.psgSet.isChecked()
	i = self.ui.vsgSetup.currentIndex()
	# change pages in stacks and colour buttons appropriately
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
			
# change what is displayed in GUI based on which VSA instrument is selected
def displayVsa(self,unsetBox,greyHover,greyButton):	
	vsaIdx = self.ui.vsaType.currentIndex()
	averaging = self.ui.averagingEnable.currentIndex()
	demod = self.ui.demodulationEnable.currentIndex()
	scopeChecked = self.ui.scopeSet.isChecked()
	uxaChecked = self.ui.uxaSet.isChecked()
	pxaChecked = self.ui.pxaSet.isChecked()
	digChecked = self.ui.digSet.isChecked()
	
	# AVERAGING CHANGES
	# if averaging is true/false, then enable/disable averaging fields and labels
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
	
	# VSA TYPE CHANGES
	# if scope or digitizer is selected
	if vsaIdx == 1 or vsaIdx == 2 or vsaIdx == 5 or vsaIdx == 6:
		# enable downconversion filter file fields
		self.ui.downFilterFileField_vsgMeas.setEnabled(True)
		self.ui.downFileLabel_awgCal.setEnabled(True)
		self.ui.filePushButton_47.setEnabled(True)
		self.ui.downFileLabel_hetero.setEnabled(True)
		self.ui.downFileField_vsgMeas.setEnabled(True)
		self.ui.filePushButton_20.setEnabled(True)
		self.ui.downFileLabel_homo.setEnabled(True)
		self.ui.downFileField_vsgMeas_2.setEnabled(True)
		self.ui.filePushButton_37.setEnabled(True)
		self.ui.downFileLabel_calval.setEnabled(True)
		self.ui.downFileField_algo.setEnabled(True)
		self.ui.filePushButton_3.setEnabled(True)
		self.ui.downFileLabel_prechar.setEnabled(True)
		self.ui.downFileField_algo_2.setEnabled(True)
		self.ui.filePushButton_7.setEnabled(True)
		self.ui.downFileLabel_dpd.setEnabled(True)
		self.ui.downFileField_algo_3.setEnabled(True)
		self.ui.filePushButton_16.setEnabled(True)
	else:
		# disable downconversion filter file fields
		self.ui.downFilterFileField_vsgMeas.setEnabled(False)
		self.ui.downFileLabel_awgCal.setEnabled(False)
		self.ui.filePushButton_47.setEnabled(False)
		self.ui.downFileLabel_hetero.setEnabled(False)
		self.ui.downFileField_vsgMeas.setEnabled(False)
		self.ui.filePushButton_20.setEnabled(False)
		self.ui.downFileLabel_homo.setEnabled(False)
		self.ui.downFileField_vsgMeas_2.setEnabled(False)
		self.ui.filePushButton_37.setEnabled(False)
		self.ui.downFileLabel_calval.setEnabled(False)
		self.ui.downFileField_algo.setEnabled(False)
		self.ui.filePushButton_3.setEnabled(False)
		self.ui.downFileLabel_prechar.setEnabled(False)
		self.ui.downFileField_algo_2.setEnabled(False)
		self.ui.filePushButton_7.setEnabled(False)
		self.ui.downFileLabel_dpd.setEnabled(False)
		self.ui.downFileField_algo_3.setEnabled(False)
		self.ui.filePushButton_16.setEnabled(False)
	
	# if digitizer is selected
	if vsaIdx == 2 or vsaIdx == 6:
		self.ui.vsaMeasGenStack.setCurrentIndex(1)
		# disable averaging enable dropdown
		self.ui.averagingEnableLabel.setEnabled(False)
		self.ui.averagingEnable.setEnabled(False)
		if vsaIdx ==2:
			# styling and next stack
			digOrScopeSet(self,2,averaging,demod,digChecked,greyHover,unsetBox,vsaIdx)
		elif vsaIdx == 6:
			self.ui.single_down_vsaMeas_stack.setCurrentIndex(0)
			self.ui.single_down_vsaMeas_stack_2.setCurrentIndex(0)
			# styling and next stack
			digOrScopeDownSet(self,2,averaging,demod,digChecked,greyButton,greyHover,unsetBox,vsaIdx)
	else:
		self.ui.vsaMeasGenStack.setCurrentIndex(0)
		self.ui.averagingEnableLabel.setEnabled(True)
		self.ui.averagingEnable.setEnabled(True)
	
	# if scope is selected
	if vsaIdx == 1 or vsaIdx == 5:
		self.ui.scopeEquip_homo.setEnabled(True)
		if vsaIdx == 1:
			# styling and next stack
			digOrScopeSet(self,1,averaging,demod,scopeChecked,greyHover,unsetBox,vsaIdx)
		elif vsaIdx == 5:
			self.ui.single_down_vsaMeas_stack.setCurrentIndex(1)
			self.ui.single_down_vsaMeas_stack_2.setCurrentIndex(1)
			# styling and next stack
			digOrScopeDownSet(self,1,averaging,demod,scopeChecked,greyButton,greyHover,unsetBox,vsaIdx)
	else:
		self.ui.scopeEquip_homo.setEnabled(False)
	
	# if uxa/pxa selected
	if vsaIdx == 3 or vsaIdx == 4:
		self.ui.vsaEquipTabs.setTabEnabled(1, True) # enable advanced tab
		if vsaIdx == 3:
			# styling and next stack
			uxaOrPxaSet(self,0,averaging,demod,uxaChecked,greyHover,unsetBox)
		elif vsaIdx == 4:
			# styling and next stack
			uxaOrPxaSet(self,1,averaging,demod,pxaChecked,greyHover,unsetBox)
	else:
		self.ui.vsaEquipTabs.setTabEnabled(1, False) # disable advance tab
	
	# if downconverter is selected
	if vsaIdx == 1 or vsaIdx == 2 or vsaIdx == 3 or vsaIdx == 4:
		self.ui.downStack_vsaMeas.setCurrentIndex(0)
		self.ui.vsaMeasParamTabs.setTabEnabled(1,False)
	elif vsaIdx == 5 or vsaIdx == 6:
		self.ui.downStack_vsaMeas.setCurrentIndex(1)
		self.ui.vsaMeasParamTabs.setTabEnabled(1,True)
	
	# if the vsa type dropdown is at select, then revert everything to default
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
	
	# DEMODULATION CHANGES
	# if demodulation enabled is left at select or is false
	if demod == 0 or demod == 2:
		self.ui.uxaMod.setEnabled(False)
		self.ui.digMod.setEnabled(False)
		self.ui.scopeMod.setEnabled(False)
		if vsaIdx == 1:
			self.ui.single_vsa_stack.setCurrentIndex(0)
			setVSAWorkflowsNoModNoDown(self,1,0,False)
			self.ui.vsaWorkflow.setCurrentIndex(1)
			self.ui.vsaWorkflow_vsaMeas.setCurrentIndex(0)
			self.ui.vsaWorkflow_vsgMeas.setCurrentIndex(0)
			if demod == 0:
				self.ui.vsaEquipStack.setCurrentIndex(1)
				self.ui.vsaAdvancedStack.setCurrentIndex(1)
		elif vsaIdx == 2:
			self.ui.single_vsa_stack.setCurrentIndex(1)
			setVSAWorkflowsNoModNoDown(self,1,1,False)
			self.ui.vsaWorkflow_vsaMeas.setCurrentIndex(0)
			self.ui.vsaWorkflow_vsgMeas.setCurrentIndex(0)
			self.ui.vsaWorkflow.setCurrentIndex(1)
			if demod == 0:
				self.ui.vsaEquipStack.setCurrentIndex(2)
				self.ui.vsaAdvancedStack.setCurrentIndex(1)
		elif vsaIdx == 3:
			self.ui.vsaWorkflow.setCurrentIndex(1)
			self.ui.single_vsa_stack.setCurrentIndex(2)
			self.ui.vsaWorkflow_vsaMeas.setCurrentIndex(0)
			self.ui.vsaWorkflow_vsgMeas.setCurrentIndex(0)
			setVSAWorkflowsNoModNoDown(self,1,2,True)
			if demod == 0:
				self.ui.vsaEquipStack.setCurrentIndex(0)
				self.ui.uxa_pxa_titleStack.setCurrentIndex(0)
				self.ui.vsaAdvancedStack.setCurrentIndex(2)
				self.ui.uxa_pxa_titleStackAdv.setCurrentIndex(0)
				self.ui.uxa_pxa_set.setCurrentIndex(0)
		elif vsaIdx == 4:
			self.ui.vsaWorkflow.setCurrentIndex(1)
			self.ui.single_vsa_stack.setCurrentIndex(3)
			self.ui.vsaWorkflow_vsaMeas.setCurrentIndex(0)
			self.ui.vsaWorkflow_vsgMeas.setCurrentIndex(0)
			setVSAWorkflowsNoModNoDown(self,1,3,True)
			if demod == 0:
				self.ui.vsaEquipStack.setCurrentIndex(0)
				self.ui.uxa_pxa_titleStack.setCurrentIndex(1)
				self.ui.vsaAdvancedStack.setCurrentIndex(2)
				self.ui.uxa_pxa_titleStackAdv.setCurrentIndex(1)
				self.ui.uxa_pxa_set.setCurrentIndex(1)	
		elif vsaIdx == 5:
			self.ui.vsaWorkflow_vsaMeas.setCurrentIndex(1)
			self.ui.vsaWorkflow_vsgMeas.setCurrentIndex(1)
			setVSAWorkflowsNoModWithDown(self,4,0,1,False)
			if demod == 0:
				self.ui.vsaEquipStack.setCurrentIndex(1)
				self.ui.vsaAdvancedStack.setCurrentIndex(1)
		elif vsaIdx == 6:
			self.ui.vsaWorkflow_vsaMeas.setCurrentIndex(1)
			self.ui.vsaWorkflow_vsgMeas.setCurrentIndex(1)
			setVSAWorkflowsNoModWithDown(self,4,0,0,False)
			if demod == 0:
				self.ui.vsaEquipStack.setCurrentIndex(2)
				self.ui.vsaAdvancedStack.setCurrentIndex(1)
					
	# if demodulation enabled is true
	elif demod == 1:
		self.ui.uxaMod.setEnabled(True)
		self.ui.digMod.setEnabled(True)
		self.ui.scopeMod.setEnabled(True)	
		if vsaIdx == 1:
			self.ui.vsaWorkflow.setCurrentIndex(2)
			self.ui.single_mod_vsa_stack.setCurrentIndex(0)
			self.ui.vsaWorkflow_vsaMeas.setCurrentIndex(3)
			self.ui.vsaWorkflow_vsgMeas.setCurrentIndex(3)			
			setVSAWorkflowsWithModNoDown(self,2,0,False)	
		elif vsaIdx == 2:
			self.ui.vsaWorkflow.setCurrentIndex(2)
			self.ui.single_mod_vsa_stack.setCurrentIndex(1)
			self.ui.vsaWorkflow_vsaMeas.setCurrentIndex(3)	
			self.ui.vsaWorkflow_vsgMeas.setCurrentIndex(3)
			setVSAWorkflowsWithModNoDown(self,2,1,False)	
		elif vsaIdx == 3:
			self.ui.vsaWorkflow.setCurrentIndex(2)
			self.ui.single_mod_vsa_stack.setCurrentIndex(2)
			self.ui.vsaWorkflow_vsaMeas.setCurrentIndex(3)
			self.ui.vsaWorkflow_vsgMeas.setCurrentIndex(3)
			setVSAWorkflowsWithModNoDown(self,2,2,True)
		elif vsaIdx == 4:			
			self.ui.vsaWorkflow.setCurrentIndex(2)
			self.ui.single_mod_vsa_stack.setCurrentIndex(3)
			self.ui.vsaWorkflow_vsaMeas.setCurrentIndex(3)
			self.ui.vsaWorkflow_vsgMeas.setCurrentIndex(3)
			setVSAWorkflowsWithModNoDown(self,2,3,True)
		elif vsaIdx == 5:
			self.ui.vsaWorkflow_vsaMeas.setCurrentIndex(2)
			self.ui.vsaWorkflow_vsgMeas.setCurrentIndex(2)
			setVSAWorkflowsWithModWithDown(self,3,1,0,False)
		elif vsaIdx == 6:
			self.ui.vsaWorkflow_vsaMeas.setCurrentIndex(2)
			self.ui.vsaWorkflow_vsgMeas.setCurrentIndex(2)
			setVSAWorkflowsWithModWithDown(self,3,1,1,False)			
				
# apply changes from one demod box to all demod boxes
def copyDemod(self,changedModField,replacedFieldOne,replacedFieldTwo):
	value = changedModField.text()
	replacedFieldOne.blockSignals(True)
	replacedFieldTwo.blockSignals(True)
	replacedFieldOne.setText(value)
	replacedFieldTwo.setText(value)
	replacedFieldOne.blockSignals(False)
	replacedFieldTwo.blockSignals(False)
	
# enable or disable power meter averaging field
def powerMeterAveraging(self,averagingTextBox,index,label):
	if index == 2:
		label.setDisabled(False)
		averagingTextBox.setDisabled(False)
		averagingTextBox.setReadOnly(False)
	else:
		label.setDisabled(True)
		averagingTextBox.setDisabled(True)
		averagingTextBox.setReadOnly(True)
	
# change what is displayed in GUI based on SA type selected
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

# enable or disable power supply channels if they are in use based on the number of channels field		
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
	
# if power supply in use field is changed, enable/disable channels	
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
		
# if power supply in use field is changed, enable/disable channels	
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
		
# if power supply in use field is changed, enable/disable channels	
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

# enable or disable fields if rx calibration will be performed or not
def enableVSACalFile(self,boxDone,boxUnset):
	checked = self.ui.generateVSACalCheck.isChecked()
	setChecked = self.ui.downSetVSAMeas.isChecked()
	setRunChecked = self.ui.set_run_vsa.isChecked()
	
	#enabling boxes when generate vsacal file is enabled
	self.ui.rxEquip_vsaMeas.setEnabled(checked)
	self.ui.trigEquip_vsaMeas.setEnabled(checked)
	self.ui.combEquip_vsaMeas.setEnabled(checked)
		
	if checked:
		self.ui.vsaMeasRunStack.setCurrentIndex(0)
		if setRunChecked:
			self.ui.combEquip_vsaMeas.setStyleSheet(boxDone)
		else:
			self.ui.combEquip_vsaMeas.setStyleSheet(boxUnset)
	else:
		self.ui.vsaMeasRunStack.setCurrentIndex(1)
		if setChecked:
			self.ui.combEquip_vsaMeas.setStyleSheet(boxDone)
		else:
			self.ui.combEquip_vsaMeas.setStyleSheet(boxUnset)
		
# enable or disable frame time in vsaMeas tab		
def determineFrameTimeEnable(self,dropdown):
	idx = dropdown.currentIndex()
	if idx == 1 or idx == 0:
		self.ui.frameTime_vsaMeas.setEnabled(False)
		self.ui.frameTime_vsaMeas_2.setEnabled(False)
	elif idx == 2:
		self.ui.frameTime_vsaMeas.setEnabled(True)
		self.ui.frameTime_vsaMeas_2.setEnabled(True)

# display different parameter boxes based on which type of calibration is selected
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

# enable AWG meas external clock freq field based on what was chosen in Step 1
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

# for AWG set equipment to create an appropriate channel mapping		
def enableChannelOptions(self):
	# 0 = Select, 1 = None, 2 = Channel 1, 3 = Channel 2
	iIdx = self.ui.iChannel_awg.currentIndex()
	qIdx = self.ui.qChannel_awg.currentIndex()
	# check that channels are not both I or Q
	if iIdx == qIdx and iIdx != 0 and iIdx != 1:
		invalidFieldError(self,"Cannot set Channel 1 and Channel 2 to be the same signal part. Select 'None' for channel to output complete RF signal.")
		self.ui.iChannel_awg.setCurrentIndex(0)
		self.ui.qChannel_awg.setCurrentIndex(0)
	# check that not only one channel outputs RF
	if (iIdx == 1 and (qIdx != 1 and qIdx != 0)) or (qIdx == 1 and (iIdx != 1 and iIdx != 0)):
		invalidFieldError(self,"Must set both Channel 1 and Channel 2 to None.")
		self.ui.iChannel_awg.setCurrentIndex(0)
		self.ui.qChannel_awg.setCurrentIndex(0)

# enable or disable trigger level based on trigger source		
def disableTrigLevelVSA(self):
	trigSource = self.ui.trigSource_sa.currentIndex()
	if trigSource == 1 or trigSource == 2 or trigSource == 3:
		self.ui.trigLevelLabel_sa.setEnabled(True)
		self.ui.trigLevel_sa.setEnabled(True)
	elif trigSource == 0 or trigSource == 4:
		self.ui.trigLevelLabel_sa.setEnabled(False)
		self.ui.trigLevel_sa.setEnabled(False)
	
# enable or disable trigger level based on trigger source		
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
	
# clear equipment setting errors in dockable widget
def clearErrors(self):
	layout = self.ui.errorLayout
	for i in reversed(range(layout.count())): 
		widgetToRemove = layout.itemAt(i).widget()
		# remove it from the layout list
		layout.removeWidget(widgetToRemove)
		# remove it from the gui
		widgetToRemove.setParent(None)
	
def enableExpansionMargin(self):
	idx = self.ui.expansionMarginEnable_hetero.currentIndex();
	if idx == 1:
		self.ui.expansionMarginLabel_hetero.setEnabled(True)
		self.ui.expansionMargin_hetero.setEnabled(True)
	else:
		self.ui.expansionMarginLabel_hetero.setEnabled(False)
		self.ui.expansionMargin_hetero.setEnabled(False)
	
def enableVSACalFileHetero(self):
	idx = self.ui.vsaCalFileEnable_hetero.currentIndex();
	if idx == 1:
		self.ui.vsaCalFileLabel_hetero.setEnabled(True)
		self.ui.vsaCalFileField_vsgMeas_2.setEnabled(True)
		self.ui.filePushButton_24.setEnabled(True)
	else:
		self.ui.vsaCalFileLabel_hetero.setEnabled(False)
		self.ui.vsaCalFileField_vsgMeas_2.setEnabled(False)
		self.ui.filePushButton_24.setEnabled(False)
	
def invalidFieldError(self,error):
	msg = QMessageBox(self)
	msg.setIcon(QMessageBox.Critical)
	msg.setWindowTitle('Invalid Field Settings')
	msg.setText(error)
	msg.setStandardButtons(QMessageBox.Ok)
	msg.exec_();

# copy the UXA center frequency from the equipment tab to the measurement tab	
def copyUXACenterFreq(self):
	uxaText = self.ui.freq_sa.text()
	self.ui.centerFreq_vsaMeas.setText(uxaText)
	self.ui.centerFreq_vsaMeas_2.setText(uxaText)
	
# copy awg ext. freq. from AWG measurement settings to AWG meas. set with calibration
def copyAWGExternalFreq(self):
	awgText = self.ui.extRefFreq_awg.text()
	self.ui.sampleClockFreq_awgCal_2.setText(awgText)
	self.ui.sampleClockFreq_awgCal.setText(awgText)
	
# copy awg dac range from AWG measurement settings to AWG meas. set with calibration
def copyAWGDacRange(self):
	awgText = self.ui.dacRange_awg.text()
	self.ui.vfs_awgCal.setText(awgText)
	self.ui.vfs_awgCal_2.setText(awgText)
	
# enable or disable file fields based on vsa val. dropdown selection
def enableVSACalPrechar(self):
	idx = self.ui.useVSACal_prechar.currentIndex()
	if idx == 0 or idx == 2:
		self.ui.vsaCalFileLabel_prechar.setEnabled(False)
		self.ui.vsaCalFileField_algo_2.setEnabled(False)
		self.ui.filePushButton_8.setEnabled(False)
	else:
		self.ui.vsaCalFileLabel_prechar.setEnabled(True)
		self.ui.vsaCalFileField_algo_2.setEnabled(True)
		self.ui.filePushButton_8.setEnabled(True)

# enable or disable file fields based on vsg cal. dropdown selection		
def enableVSGCalPrechar(self):
	idx = self.ui.useVSGCal_prechar.currentIndex()
	if idx == 0 or idx == 2:
		self.ui.calFileIField_algo_2.setEnabled(False)
		self.ui.calFileILabel_prechar.setEnabled(False)
		self.ui.filePushButton_9.setEnabled(False)
		self.ui.calFileQLabel_prechar.setEnabled(False)
		self.ui.calFileQField_algo_2.setEnabled(False)
		self.ui.filePushButton_10.setEnabled(False)
	else:
		self.ui.calFileIField_algo_2.setEnabled(True)
		self.ui.calFileILabel_prechar.setEnabled(True)
		self.ui.filePushButton_9.setEnabled(True)
		self.ui.calFileQLabel_prechar.setEnabled(True)
		self.ui.calFileQField_algo_2.setEnabled(True)
		self.ui.filePushButton_10.setEnabled(True)
	
def enableExpansionPrechar(self):
	idx = self.ui.gainExpansionFlag_prechar.currentIndex()
	if idx == 0 or idx == 2:
		self.ui.gainExpansionLabel_prechar.setEnabled(False)
		self.ui.gainExpansion_prechar.setEnabled(False)
	else:
		self.ui.gainExpansionLabel_prechar.setEnabled(True)
		self.ui.gainExpansion_prechar.setEnabled(True)
	
def enableFreqMultPrechar(self):
	idx = self.ui.freqMultiplierFlag_prechar.currentIndex()
	if idx == 0 or idx == 2:
		self.ui.freqMultiplierFactorLabel_prechar.setEnabled(False)
		self.ui.freqMultiplierFactor_prechar.setEnabled(False)
	else:
		self.ui.freqMultiplierFactorLabel_prechar.setEnabled(True)
		self.ui.freqMultiplierFactor_prechar.setEnabled(True)
	
def copyAWGCenterFreq(self):
	text = self.ui.centerFreq_awgCal_2.text()
	self.ui.centerFreq_awgCal.setText(text)
	
def copyAWGAmpCorr(self):
	idx = self.ui.ampCorrection_awgCal_2.currentIndex()
	self.ui.ampCorrection_awgCal.setCurrentIndex(idx)
	
def copyAWGTrigAmp(self):
	text= self.ui.trigAmp_awgCal_2.text()
	self.ui.trigAmp_awgCal.setText(text)
	
def copyAWGNoPeriods(self):	
	text = self.ui.noTXPeriods_awgMeas.text()
	self.ui.noTXPeriods_awgCal.setText(text)
	
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# functions called within displayVSA	

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
	self.ui.single_vsaMeas_stack_2.setCurrentIndex(subidx)
	self.ui.single_vsgMeas_stack.setCurrentIndex(subidx)
	self.ui.single_vsgMeas_stack_2.setCurrentIndex(subidx)

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
	self.ui.single_vsaMeas_stack_2.setCurrentIndex(subidx)
	self.ui.single_vsgMeas_stack.setCurrentIndex(subidx)
	self.ui.single_vsgMeas_stack_2.setCurrentIndex(subidx)
	
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
	self.ui.single_down_vsgMeas_stack_2.setCurrentIndex(subidx)
	
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
	self.ui.single_down_vsgMeas_stack_2.setCurrentIndex(subidx)
	
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