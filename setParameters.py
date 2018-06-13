# setParameters.py contains all the functions that are called whenever a "set" "set & run" or "preview" button is clicked

from PyQt5.QtWidgets import (QProgressBar)
from PyQt5.QtGui import (QCursor)
from PyQt5.QtCore import (Qt)

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# functions used in main.py

def setGeneralAWG(self,buttonColourFocus, boxDone):
	self.ui.awgButton_vsg.setStyleSheet(buttonColourFocus)
	self.ui.awgButton_vsg_2.setStyleSheet(buttonColourFocus)
	self.ui.awgButton_vsg_3.setStyleSheet(buttonColourFocus)
	setStandardMessage(self)
	self.ui.awgEquipGeneral.setStyleSheet(boxDone)
	setupIdx = self.ui.vsgWorkflows.currentIndex()
	if setupIdx == 1:
		self.ui.vsgNextSteps.setCurrentIndex(5)
	elif setupIdx == 2:
		self.ui.vsgNextSteps.setCurrentIndex(2)
	elif setupIdx == 3:
		self.ui.vsgNextSteps.setCurrentIndex(3)
	
def setGeneralVSG(self, buttonColourFocus, boxDone):
	self.ui.vsgButton_vsg.setStyleSheet(buttonColourFocus)
	self.ui.vsgEquipGeneral.setStyleSheet(boxDone)
	setStandardMessage(self)
	self.ui.vsgNextSteps.setCurrentIndex(5)

def setAdvanced(self,box,boxDone):
	box.setStyleSheet(boxDone)
	self.ui.statusBar.showMessage('Successfully Set Advanced Settings',2000)

def setUp(self,buttonColourFocus,buttonColourDone,boxDone):
	self.ui.upButton_up.setStyleSheet(buttonColourFocus)
	self.ui.upButton_vsg.setStyleSheet(buttonColourDone)
	self.ui.upEquip.setStyleSheet(boxDone)
	self.ui.up_psg_next.setCurrentIndex(2)
	setStandardMessage(self)

def setPSG(self,buttonColourFocus,buttonColourDone,boxDone):
	self.ui.psgButton_up.setStyleSheet(buttonColourFocus)
	self.ui.psgButton_vsg.setStyleSheet(buttonColourDone)
	self.ui.psgEquip.setStyleSheet(boxDone)
	self.ui.up_psg_next.setCurrentIndex(2)
	setStandardMessage(self)
		
def setVSA(self,buttonFocusP,buttonFocusG,buttonPHover,boxDone,buttonHoverB, buttonHoverG):
	averaging = self.ui.averagingEnable.currentIndex()
	demod = self.ui.demodulationEnable.currentIndex()
	typeIdx = self.ui.vsaType.currentIndex()
	
	# if all top vsa parameters are filled out
	if averaging != 0 and demod != 0:
		# set new activated buttons
		if typeIdx == 1 or typeIdx == 2 or typeIdx == 3 or typeIdx == 4:
			self.ui.meterButton_vsa.setStyleSheet(buttonHoverB)
			self.ui.meterButton_vsa.setCursor(QCursor(Qt.PointingHandCursor))
		elif typeIdx == 5 or typeIdx == 6:
			self.ui.downButton_vsa.setStyleSheet(buttonHoverG)
			self.ui.downButton_vsa_2.setStyleSheet(buttonHoverG)
			self.ui.downButton_vsa.setCursor(QCursor(Qt.PointingHandCursor))
			self.ui.downButton_vsa_2.setCursor(QCursor(Qt.PointingHandCursor))
		
		# style mod related widgets
		if typeIdx == 3 or typeIdx == 4: # UXA & PXA
			self.ui.uxaEquipGeneralVSA.setStyleSheet(boxDone)
			demod = self.ui.uxaMod.isEnabled()
			if demod:
				setAllDemod(self, boxDone)
				self.ui.modButton_vsa.setStyleSheet(buttonFocusG)
			self.ui.vsaNextStack.setCurrentIndex(3)
		elif typeIdx == 1 or typeIdx == 2 or typeIdx == 5 or typeIdx == 6:
			demodScope = self.ui.scopeMod.isEnabled()
			demodDig = self.ui.digMod.isEnabled()
			if demodScope or demodDig:
				setAllDemod(self, boxDone)
				self.ui.modButton_vsa_2.setStyleSheet(buttonFocusG)
				self.ui.modButton_vsa.setStyleSheet(buttonFocusG)
			
		if typeIdx == 3: #UXA
			self.ui.uxaButton_vsa.setStyleSheet(buttonFocusP)
			self.ui.uxaButton_vsa_2.setStyleSheet(buttonFocusP)
			setPrevVSAButtons(self,buttonPHover)
		elif typeIdx == 4: #PXA
			self.ui.pxaButton_vsa.setStyleSheet(buttonFocusP)
			self.ui.pxaButton_vsa_2.setStyleSheet(buttonFocusP)
			setPrevVSAButtons(self,buttonPHover)		
		elif typeIdx == 1 or typeIdx == 5: #Scope
			self.ui.scopeEquipGeneral.setStyleSheet(boxDone)
			self.ui.scopeButton_vsa.setStyleSheet(buttonFocusP)
			self.ui.scopeButton_vsa_2.setStyleSheet(buttonFocusP)
			self.ui.scopeButton_vsa_3.setStyleSheet(buttonFocusP)
			self.ui.scopeButton_vsa_4.setStyleSheet(buttonFocusP)
			setPrevVSAButtons(self,buttonPHover)
			if typeIdx == 1:
				self.ui.vsaNextStack.setCurrentIndex(3)
			elif typeIdx == 5:
				self.ui.vsaNextStack.setCurrentIndex(2)
		elif typeIdx == 2 or typeIdx ==6: #Digitizer
			self.ui.digEquipGeneral.setStyleSheet(boxDone)
			self.ui.digButton_vsa.setStyleSheet(buttonFocusP)
			self.ui.digButton_vsa_2.setStyleSheet(buttonFocusP)
			self.ui.digButton_vsa_3.setStyleSheet(buttonFocusP)
			self.ui.digButton_vsa_4.setStyleSheet(buttonFocusP)
			setPrevVSAButtons(self,buttonPHover)
			if typeIdx == 2:
				self.ui.vsaNextStack.setCurrentIndex(3)
			elif typeIdx == 6:
				self.ui.vsaNextStack.setCurrentIndex(2)
	else:
		self.fillParametersMsg()
		self.ui.digSet.setChecked(False)
		self.ui.scopeSet.setChecked(False)
		self.ui.uxaSet.setChecked(False)
		
def setVSAAdv(self,boxDone):
	averaging = self.ui.averagingEnable.currentIndex()
	demod = self.ui.demodulationEnable.currentIndex()
	if averaging != 0 and demod != 0:
		self.ui.uxaVSAAdv.setStyleSheet(boxDone)
		self.ui.statusBar.showMessage('Successfully Set Advanced Settings',2000)
	else:
		self.fillParametersMsg()
		self.ui.uxaVSASetAdv.setChecked(False)
		
def rxCalRoutine(self):
	self.resize(1265,950)
	self.center()
	self.progressBar = QProgressBar()
	self.progressBar.setRange(1,10);
	self.progressBar.setTextVisible(True);
	self.progressBar.setFormat("Currently Running: RX Calibration Routine")
	self.ui.statusBar.addWidget(self.progressBar,1)
	completed = 0
	while completed < 100:
		completed = completed + 0.00001
		self.progressBar.setValue(completed)
	self.ui.statusBar.removeWidget(self.progressBar)
	# to show progress bar, need both addWidget() and show()
	self.ui.statusBar.showMessage("RX Calibration Routine Complete",3000)

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# functions for setParameters.py	

def setPrevVSAButtons(self,buttonPHover):
	self.ui.vsaButton_vsg.setStyleSheet(buttonPHover)
	self.ui.vsaButton_vsg.setCursor(QCursor(Qt.PointingHandCursor))
	self.ui.vsaButton_up.setStyleSheet(buttonPHover)
	self.ui.vsaButton_up.setCursor(QCursor(Qt.PointingHandCursor))

def setAllDemod(self, boxDone):
	self.ui.digMod.setStyleSheet(boxDone)
	self.ui.scopeMod.setStyleSheet(boxDone)
	self.ui.uxaMod.setStyleSheet(boxDone)
	
def setStandardMessage(self):
	self.ui.statusBar.showMessage('Successfully Set Standard Settings',2000)