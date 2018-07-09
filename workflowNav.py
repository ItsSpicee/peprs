# workflowNav.py contains all the functions that are called when an equipment workflow button is hit, it also contains the dashboard equipment options

from PyQt5.QtGui import (QCursor)
from PyQt5.QtCore import (Qt)
from PyQt5.QtWidgets import (QFileDialog)


def fileBrowse(self, lineEdit):
	fileInfo = str(QFileDialog.getOpenFileName())
	fileList = fileInfo.split(",")
	file = fileList[0]
	file = file.replace("'","")
	file = file.replace("(","")
	lineEdit.clear()
	lineEdit.insertPlainText(file)

def changeStack(self,stackName,idx):
	stackName.setCurrentIndex(idx)

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
			print("hi")
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
def powerMeterAveraging(self,averagingTextBox,index,label):
	
	if index == 2:
		label.setDisabled(False)
		averagingTextBox.setDisabled(False)
		averagingTextBox.setReadOnly(False)
	else:
		label.setDisabled(True)
		averagingTextBox.setDisabled(True)
		averagingTextBox.setReadOnly(True)
def awgVSAMeasOnClick(self):
	vsaSetChecked = self.ui.vsaMeasSet.isChecked()
	vsaSetTwoChecked = self.ui.vsaMeasSet_2.isChecked()
	runChecked = self.ui.set_run_vsa.isChecked()
	downChecked = self.ui.downSetVSAMeas.isChecked()
	downEnabled = self.ui.vsaWorkflow_vsaMeas.currentIndex()
	
	if downEnabled == 1: # down enabled
		if downChecked:
			self.ui.measStack.setCurrentIndex(1)
			self.ui.vsgMeasNextStack.setCurrentIndex(0)
	else:
		if vsaSetChecked or vsaSetTwoChecked:
			self.ui.measStack.setCurrentIndex(1)
			self.ui.vsgMeasNextStack.setCurrentIndex(2)
				
def saVSGMeasOnClick(self):
	self.ui.vsaMeasParamTabs.setCurrentIndex(2)
	self.ui.measStack.setCurrentIndex(0)

def downVSGMeasOnClick(self):
	self.ui.vsaMeasParamTabs.setCurrentIndex(1)
	self.ui.measStack.setCurrentIndex(0)

def analyzerVSGMeasOnClick(self):
	self.ui.vsaMeasParamTabs.setCurrentIndex(0)
	self.ui.measStack.setCurrentIndex(0)
		
# OLD CODE

# for old vsa and vsg only dash buttons
# def vsgOnlySetup(self,greyButton,blueButton):
	# self.ui.vsgDash.setStyleSheet(blueButton)
	# self.ui.meterDash.setStyleSheet(greyButton)
	# self.ui.vsaDash.setStyleSheet(greyButton)
	# self.ui.saDash.setStyleSheet(greyButton)
	
# def vsaOnlySetup(self,greyButton, blueButton):
	# self.ui.vsgDash.setStyleSheet(greyButton)
	# self.ui.meterDash.setStyleSheet(blueButton)
	# self.ui.vsaDash.setStyleSheet(blueButton)
	# self.ui.saDash.setStyleSheet(blueButton)
	
# def standardSetup(self,blueButton):
	# self.ui.vsgDash.setStyleSheet(blueButton)
	# self.ui.meterDash.setStyleSheet(blueButton)
	# self.ui.vsaDash.setStyleSheet(blueButton)
	# self.ui.saDash.setStyleSheet(blueButton)