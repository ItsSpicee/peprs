# workflowNav.py contains all the functions that are called when an equipment workflow button is hit, it also contains the dashboard equipment options

from PyQt5.QtGui import (QCursor)
from PyQt5.QtCore import (Qt)

def changeStack(self,stackName,idx):
	stackName.setCurrentIndex(idx)

def vsgOnlySetup(self,greyButton,purpleButton):
	self.ui.vsgDash.setStyleSheet(purpleButton)
	self.ui.meterDash.setStyleSheet(greyButton)
	self.ui.vsaDash.setStyleSheet(greyButton)
	self.ui.saDash.setStyleSheet(greyButton)
	
def vsaOnlySetup(self,greyButton,purpleButton,blueButton):
	self.ui.vsgDash.setStyleSheet(greyButton)
	self.ui.meterDash.setStyleSheet(blueButton)
	self.ui.vsaDash.setStyleSheet(purpleButton)
	self.ui.saDash.setStyleSheet(purpleButton)

def awgOnClick(self,unactiveButton,activeButton,buttonPHover):
	self.ui.equipStack.setCurrentIndex(0)
	upChecked = self.ui.upSet.isChecked()
	psgChecked = self.ui.psgSet.isChecked()
	scopeChecked = self.ui.scopeSet.isChecked()
	digChecked = self.ui.digSet.isChecked()
	uxaChecked = self.ui.uxaSet.isChecked()
	pxaChecked = self.ui.pxaSet.isChecked()
	if upChecked or psgChecked:
		self.ui.vsaButton_vsg.setStyleSheet(activeButton)
		self.ui.vsaButton_vsg.setCursor(QCursor(Qt.PointingHandCursor))
	elif scopeChecked or digChecked or uxaChecked or pxaChecked:
		self.ui.vsaButton_vsg.setStyleSheet(buttonPHover)
		self.ui.vsaButton_vsg.setCursor(QCursor(Qt.PointingHandCursor))
		self.ui.vsaButton_up.setStyleSheet(buttonPHover)
		self.ui.vsaButton_up.setCursor(QCursor(Qt.PointingHandCursor))
	else:
		self.ui.vsaButton_vsg.setStyleSheet(unactiveButton)

def upOnClick(self):
	awgSet = self.ui.awgSetGeneral.isChecked()
	if awgSet:
		self.ui.equipStack.setCurrentIndex(1)
		self.ui.up_psg_stack.setCurrentIndex(0)
		self.ui.up_psg_next.setCurrentIndex(0)
		self.ui.up_psg_workflow.setCurrentIndex(0)
	else:
		self.fillParametersMsg()
	
def psgOnClick(self):
	awgSet = self.ui.awgSetGeneral.isChecked()
	if awgSet:
		self.ui.equipStack.setCurrentIndex(1)
		self.ui.up_psg_stack.setCurrentIndex(1)
		self.ui.up_psg_next.setCurrentIndex(1) 
		self.ui.up_psg_workflow.setCurrentIndex(1)
	else:
		self.fillParametersMsg()

def vsaOnClick(self):
	awgChecked = self.ui.awgSetGeneral.isChecked()
	vsgChecked = self.ui.vsgSetGeneral.isChecked()
	upChecked = self.ui.upSet.isChecked()
	psgChecked = self.ui.psgSet.isChecked()
	vsgSetupIdx = self.ui.vsgWorkflows.currentIndex() 
	if vsgSetupIdx == 1:
		if awgChecked:
			self.ui.equipStack.setCurrentIndex(2)
		else:
			self.fillParametersMsg()
	elif vsgSetupIdx == 4:
		if vsgChecked:
			self.ui.equipStack.setCurrentIndex(2)
		else:
			self.fillParametersMsg()
	elif vsgSetupIdx == 2:
		if upChecked:
			self.ui.equipStack.setCurrentIndex(2)
	elif vsgSetupIdx == 3:
		if psgChecked:
			self.ui.equipStack.setCurrentIndex(2)

def powerOnClick(self):
	typeIdx = self.ui.vsaType.currentIndex()
	if typeIdx == 1 or typeIdx == 2 or typeIdx == 3 or typeIdx == 4:
		self.ui.equipStack.setCurrentIndex(4)

def downOnClick(self):
	digChecked = self.ui.digSet.isChecked()
	scopeChecked = self.ui.scopeSet.isChecked()
	typeIdx = self.ui.vsaType.currentIndex()
	if typeIdx == 5:
		if scopeChecked:
			self.ui.equipStack.setCurrentIndex(3)
	elif typeIdx == 6:
		if digChecked:
			self.ui.equipStack.setCurrentIndex(3)