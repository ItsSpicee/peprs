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

def upOnClick(self,buttonGreyPHover,buttonGreyP):
	awgSet = self.ui.awgSetGeneral.isChecked()
	upSet = self.ui.upSet.isChecked()
	if awgSet:
		self.ui.equipStack.setCurrentIndex(1)
		self.ui.up_psg_stack.setCurrentIndex(0)
		self.ui.up_psg_workflow.setCurrentIndex(0)
		
		if upSet:
			self.ui.vsaButton_up.setStyleSheet(buttonGreyPHover)
			self.ui.vsaButton_up.setCursor(QCursor(Qt.PointingHandCursor))
		else:
			self.ui.vsaButton_up.setStyleSheet(buttonGreyP)
			self.ui.vsaButton_up.setCursor(QCursor(Qt.ArrowCursor))
	else:
		self.fillParametersMsg()
	
def psgOnClick(self,buttonGreyPHover,buttonGreyP):
	awgSet = self.ui.awgSetGeneral.isChecked()
	psgSet = self.ui.psgSet.isChecked()
	if awgSet:
		self.ui.equipStack.setCurrentIndex(1)
		self.ui.up_psg_stack.setCurrentIndex(1)
		self.ui.up_psg_workflow.setCurrentIndex(1)
		if psgSet:
			self.ui.vsaButton_up.setStyleSheet(buttonGreyPHover)
			self.ui.vsaButton_up.setCursor(QCursor(Qt.PointingHandCursor))
		else:
			self.ui.vsaButton_up.setStyleSheet(buttonGreyP)
			self.ui.vsaButton_up.setCursor(QCursor(Qt.ArrowCursor))
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
		else:
			self.fillParametersMsg()
	elif vsgSetupIdx == 3:
		if psgChecked:
			self.ui.equipStack.setCurrentIndex(2)
		else:
			self.fillParametersMsg()

def meterOnClick(self):
	typeIdx = self.ui.vsaType.currentIndex()
	downChecked = self.ui.downSet.isChecked()
	digChecked = self.ui.digSet.isChecked()
	scopeChecked = self.ui.scopeSet.isChecked()
	uxaChecked = self.ui.uxaSet.isChecked()
	pxaChecked = self.ui.pxaSet.isChecked()
	if typeIdx == 1 and scopeChecked:
		self.ui.equipStack.setCurrentIndex(4)
	elif typeIdx == 2  and digChecked:
		self.ui.equipStack.setCurrentIndex(4)
	elif typeIdx == 3 and uxaChecked:
		self.ui.equipStack.setCurrentIndex(4)
	elif typeIdx == 4 and pxaChecked:	
		self.ui.equipStack.setCurrentIndex(4)
	elif typeIdx == 5 or typeIdx ==6:
		if downChecked:
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
			
def saOnClick(self):
	meterChecked = self.ui.meterSet.isChecked()
	if meterChecked:
		self.ui.equipStack.setCurrentIndex(5)
		
def p1OnClick(self):
	saChecked = self.ui.saSet.isChecked()
	saType = self.ui.saType.currentIndex()
	if saChecked or saType == 3:
		self.ui.equipStack.setCurrentIndex(6)
		
def p2OnClick(self):
	p1Checked = self.ui.p1Set.isChecked()
	if p1Checked:
		self.ui.equipStack.setCurrentIndex(7)
		
def p3OnClick(self):
	vsgType = self.ui.vsgSetup.currentIndex()
	p1Checked = self.ui.p1Set.isChecked()
	p2Checked = self.ui.p2Set.isChecked()
	
	if p2Checked:
		self.ui.equipStack.setCurrentIndex(8)
	if vsgType == 1 or vsgType == 4:
		if p1Checked:
			self.ui.equipStack.setCurrentIndex(8)

def awgVSAMeasOnClick(self):
	vsaSetType = self.ui.vsaMeasGenStack.currentIndex()
	vsaSetChecked = self.ui.vsaMeasSet.isChecked()
	vsaSetTwoChecked = self.ui.vsaMeasSet_2.isChecked()
	# vsaRunChecked = self.ui.
	
	# if vsaSetType == 0:
		# if vsaSetTwoChecked and :
			
	# elif vsaSetType == 1:
		# if vsaSetChecked and :